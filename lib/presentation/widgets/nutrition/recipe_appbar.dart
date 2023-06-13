import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:go_router/go_router.dart';

class RecipeAppBar extends StatefulWidget {
  final Recipe info;
  const RecipeAppBar({
    super.key,
    required this.info,
  });

  @override
  State<StatefulWidget> createState() => _RecipeAppBarState();
}

class _RecipeAppBarState extends State<RecipeAppBar> {
  // Future<Uri> data() async {
  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //     uriPrefix: 'https://newapp2222.page.link/',
  //     link: Uri.parse(
  //         'https://ansh-rathod-blog.netlify.app/?id=${widget.info.id}'),
  //     androidParameters: AndroidParameters(
  //       packageName: 'com.example.android',
  //       minimumVersion: 125,
  //     ),
  //     googleAnalyticsParameters: GoogleAnalyticsParameters(
  //       campaign: 'example-promo',
  //       medium: 'social',
  //       source: 'orkut',
  //     ),
  //     socialMetaTagParameters: SocialMetaTagParameters(
  //       title: widget.info.title,
  //       description: widget.info.summary,
  //       imageUrl: Uri.parse(widget.info.image!),
  //     ),
  //   );

  //   final Uri dynamicUrl = await parameters.buildUrl();
  //   final ShortDynamicLink shortenedLink =
  //       await DynamicLinkParameters.shortenUrl(
  //     dynamicUrl,
  //     DynamicLinkParametersOptions(
  //         shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
  //   );

  //   final Uri shortUrl = shortenedLink.shortUrl;
  //   return shortUrl;
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    return SliverAppBar(
      expandedHeight: size.height * 0.4,
      backgroundColor: colors.background,
      foregroundColor: colors.onBackground,
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: const Icon(CupertinoIcons.back, color: Colors.white),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            //
            // final url = await data();
            // Share.share(
            //   'check out This tasty recipe $url',
            // );
          },
          icon: const Icon(CupertinoIcons.share, color: Colors.white),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
          background: Stack(
        children: [
          SizedBox.expand(
            child: Image.network(
              widget.info.image,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return FadeIn(child: child);
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                );
              },
            ),
          ),
          _customGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 0.2],
            colors: [Colors.black87, Colors.transparent],
          ),
          _customGradient(
            begin: Alignment.topLeft,
            stops: [0.0, 0.3],
            colors: [Colors.black87, Colors.transparent],
          ),
        ],
      )),
    );
  }

  SizedBox _customGradient({
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
    List<double>? stops,
    required List<Color> colors,
  }) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors,
          ),
        ),
      ),
    );
  }
}
