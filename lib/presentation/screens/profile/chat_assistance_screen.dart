import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ChatBotScreen extends ConsumerStatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends ConsumerState<ChatBotScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Future<bool> clearMessages() {
    ref.read(openAIProvider.notifier).clearMessage();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: clearMessages,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ChatBot'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: buildMsgCard(size, context),
              ),
              buildTextInput(),
              buildErrorSheet(context, size),
            ],
          ),
        ),
      ),
    );
  }

  Column buildMsgCard(Size size, BuildContext context) {
    final openAIRef = ref.watch(openAIProvider);
    return Column(
      children: [
        Expanded(
            flex: 12,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: openAIRef.isClear ? 1 : openAIRef.messages.length,
              itemBuilder: (context, index) {
                if (openAIRef.isClear) {
                  return buildBotCard(context, null);
                }
                return openAIRef.messages[index].isBot == true
                    ? buildBotCard(context, openAIRef.messages[index].message)
                    : buildUserCard(context, openAIRef.messages[index].message);
              },
            )),
        const Spacer(
          flex: 1,
        )
      ],
    );
  }

  Widget buildErrorSheet(BuildContext context, Size size) {
    final openAIRef = ref.watch(openAIProvider);
    return openAIRef.openAIError
        ? Align(
            alignment: Alignment.bottomCenter,
            child: ErrorCard(
              height: size.height * .5,
              animation: 'assets/animation/error_animation.json',
              title: 'Server error',
              error: "Issue on our servers.",
            ),
          )
        : const SizedBox();
  }

  Padding buildUserCard(BuildContext context, String? message) {
    const double kDefaultPadding = 16.0;
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    final person = ref.watch(personProvider.notifier).user;
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ///content card
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(right: kDefaultPadding / 2),
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding / 1.5,
                  vertical: kDefaultPadding / 1.2),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(.32),
                borderRadius: BorderRadius.circular(kDefaultPadding / 2),
                // border: Border.all(color: ),
              ),
              child: Text(message ?? 'User Message.',
                  style: textStyles.titleSmall),
            ),
          ),

          ///user icon
          person != null
              ? ClipRRect(
                  child: Image.network(person.profilePic,
                      cacheWidth: 100,
                      cacheHeight: 100,
                      width: kDefaultPadding * 2.8,
                      height: kDefaultPadding * 2.8,
                      fit: BoxFit.cover),
                )
              : Container(
                  padding: const EdgeInsets.all(kDefaultPadding / 1.5),
                  decoration: BoxDecoration(
                      color: colors.primary.withOpacity(.32),
                      borderRadius: BorderRadius.circular(kDefaultPadding / 3),
                      boxShadow: [
                        BoxShadow(
                            color: colors.primary.withOpacity(.1),
                            offset: const Offset(0, 3),
                            blurRadius: 6.0)
                      ]),
                  child: Image.asset(
                    'assets/icons/user_icon.png',
                    color: colors.primary,
                    cacheWidth: 100,
                    cacheHeight: 100,
                    width: kDefaultPadding * 1.2,
                    height: kDefaultPadding * 1.2,
                  ),
                ),
        ],
      ),
    );
  }

  Padding buildBotCard(BuildContext context, String? message) {
    const double kDefaultPadding = 16.0;
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///bot icon
          Container(
              margin: const EdgeInsets.only(right: kDefaultPadding / 2),
              padding: const EdgeInsets.all(kDefaultPadding / 1.5),
              decoration: BoxDecoration(
                  color: colors.primary.withOpacity(.32),
                  borderRadius: BorderRadius.circular(kDefaultPadding / 3),
                  boxShadow: [
                    BoxShadow(
                        color: colors.primary.withOpacity(.1),
                        offset: const Offset(0, 3),
                        blurRadius: 6.0)
                  ]),
              child: Image.asset(
                'assets/icons/openai_icon.png',
                color: colors.primary,
                cacheWidth: 32,
                cacheHeight: 32,
                width: kDefaultPadding,
                height: kDefaultPadding,
              )),

          ///content card
          Flexible(
              child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding / 1.5,
                vertical: kDefaultPadding / 1.2),
            decoration: BoxDecoration(
                color: colors.primary.withOpacity(.1),
                borderRadius: BorderRadius.circular(kDefaultPadding / 2),
                border: Border.all(color: colors.primary.withOpacity(.1))),
            child: MarkdownBody(
              data: message ?? "How can I help you today?",
              selectable: true,
              onTapText: () {},
              styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
              styleSheet: MarkdownStyleSheet(
                  codeblockDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: colors.surface,
                  ),
                  code: textStyles.bodyMedium?.copyWith(
                      backgroundColor: Colors.transparent,
                      fontFamily: GoogleFonts.courierPrime().fontFamily,
                      fontSize: 16.sp),
                  p: textStyles.titleSmall),
            ),
          ))
        ],
      ),
    );
  }

  Align buildTextInput() {
    final openAIRef = ref.watch(openAIProvider);
    final colors = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.bottomCenter,
      child: openAIRef.showLoading
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: OpenAIButton(
                color: colors.primary,
                width: MediaQuery.of(context).size.width * .25,
                height: 16.0 * 2.8,
                title: 'Stop',
                tab: () {
                  ref.read(openAIProvider.notifier).onStopGenerate();
                },
              ),
            )
          : buildTextField(context),
    );
  }

  Container buildTextField(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    const double kDefaultPadding = 18.0;
    return Container(
        margin: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(kDefaultPadding / 2),
          border: Border.all(
            color: colors.primary.withOpacity(.4),
          ),
        ),
        child: TextField(
            controller: ref.watch(openAIProvider.notifier).getTextInput(),
            onSubmitted: (it) {
              ref.read(openAIProvider.notifier).sendMessageWithPrompt();
            },
            maxLines: null,
            style: textStyles.titleSmall,
            decoration: InputDecoration(
                suffixIcon: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
                  decoration: BoxDecoration(
                      color: colors.primary.withOpacity(.32),
                      borderRadius: BorderRadius.circular(kDefaultPadding / 2),
                      boxShadow: [
                        BoxShadow(
                            color: colors.primary.withOpacity(.1),
                            offset: const Offset(0, 3),
                            blurRadius: 6.0)
                      ]),
                  child: IconButton(
                    onPressed: () {
                      ref.read(openAIProvider.notifier).sendMessageWithPrompt();
                    },
                    color: colors.primary,
                    icon: Transform.rotate(
                        angle: -pi / 4,
                        child: Icon(Icons.send_outlined,
                            color: colors.primary, size: kDefaultPadding)),
                  ),
                ),
                hintText: 'Type a message...',
                hintStyle: textStyles.titleSmall?.copyWith(
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none)));
  }
}

class ErrorCard extends ConsumerWidget {
  const ErrorCard(
      {Key? key,
      required this.height,
      required this.animation,
      required this.title,
      required this.error})
      : super(key: key);

  final double height;
  final String animation;
  final String title;
  final String error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double kDefaultPadding = 16.0;
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      height: height,
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(kDefaultPadding * 2),
              topLeft: Radius.circular(kDefaultPadding * 2)),
          boxShadow: [
            BoxShadow(
                color: colors.surface.withOpacity(.4),
                offset: const Offset(8, 0),
                blurRadius: 27.0)
          ]),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(
                title,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(
                error,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Lottie.asset(
              animation,
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 10),
            OpenAIButton(
              width: MediaQuery.of(context).size.width * .56,
              height: kDefaultPadding * 2.8,
              title: 'Close',
              color: colors.primary,
              boxShadow: [
                BoxShadow(
                    color: colors.primary.withOpacity(.23),
                    offset: const Offset(0.0, 6),
                    blurRadius: 5.0)
              ],
              tab: () => ref.read(openAIProvider.notifier).closeOpenAIError(),
            ),
          ],
        ),
      ),
    );
  }
}

class OpenAIButton extends StatelessWidget {
  const OpenAIButton({
    super.key,
    required this.height,
    required this.width,
    required this.tab,
    required this.title,
    this.boxShadow,
    this.color = Colors.blue,
  });

  final double height;
  final double width;
  final GestureTapCallback tab;
  final String title;
  final List<BoxShadow>? boxShadow;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return Ink(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0 * 1.22),
          boxShadow: boxShadow),
      child: InkWell(
        onTap: tab,
        child: Center(
          child: Text(title, style: textStyles.titleMedium),
        ),
      ),
    );
  }
}
