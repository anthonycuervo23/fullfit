import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicScreen extends ConsumerStatefulWidget {
  const ProfilePicScreen({super.key});

  @override
  ProfilePicScreenState createState() => ProfilePicScreenState();
}

class ProfilePicScreenState extends ConsumerState<ProfilePicScreen> {
  File? _image;
  final _imagePicker = ImagePicker();
  static List<String> pics = [
    'assets/avatars/avatar1.png',
    'assets/avatars/avatar2.png',
    'assets/avatars/avatar3.png',
    'assets/avatars/avatar4.png',
    'assets/avatars/avatar5.png',
    'assets/avatars/avatar6.png',
    'assets/avatars/avatar7.png',
    'assets/avatars/avatar8.png',
    'assets/avatars/avatar9.png',
    'assets/avatars/avatar10.png',
    'assets/avatars/avatar11.png',
    'assets/avatars/avatar12.png',
  ];
  SwiperController controller = SwiperController();

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _imagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file!.path);
        pics.add(_image!.path);
      });
      ref
          .read(onBoardingNotifierProvider.notifier)
          .onProfilePicChanged(_image!.path);
    }
  }

  _onCameraClick() {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    showAdaptiveActionSheet(
      context: context,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Agregar foto de perfil',
            style: textStyles.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onBackground.withOpacity(0.6)),
          ),
          SizedBox(height: 20.h),
          Text('Esta foto será visible para otros usuarios',
              style: textStyles.bodyMedium?.copyWith(
                color: colors.onBackground.withOpacity(0.6),
              )),
        ],
      ),
      actions: [
        BottomSheetAction(
          title: const Text('Elegir de la galería'),
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              setState(() {
                _image = File(image.path);
                pics.add(_image!.path);
              });
              await Future.delayed(const Duration(milliseconds: 300), () {
                controller.move(pics.length - 1, animation: false);
              });
              ref
                  .read(onBoardingNotifierProvider.notifier)
                  .onProfilePicChanged(_image!.path);
            }
          },
        ),
        BottomSheetAction(
          title: const Text('Tomar una foto'),
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.camera);
            if (image != null) {
              setState(() {
                _image = File(image.path);
                pics.add(_image!.path);
              });
              await Future.delayed(const Duration(milliseconds: 300), () {
                controller.move(pics.length - 1, animation: false);
              });
              ref
                  .read(onBoardingNotifierProvider.notifier)
                  .onProfilePicChanged(_image!.path);
            }
          },
        ),
      ],
      cancelAction: CancelAction(
        title: const Text('Cancelar'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    if (Platform.isAndroid) {
      retrieveLostData();
    }
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 98.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            // height: 195.h,
            child: Column(
              children: [
                Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 45.w,
                  color: colors.onBackground,
                ),
                SizedBox(
                  height: 100.h,
                  child: Swiper(
                    onIndexChanged: (value) {
                      ref
                          .read(onBoardingNotifierProvider.notifier)
                          .onProfilePicChanged(pics[value]);
                    },
                    controller: controller,
                    itemCount: pics.length,
                    loop: true,
                    viewportFraction: 0.27,
                    scale: 0.75,
                    itemBuilder: (context, index) =>
                        buildPicWidget(pics[index]),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_up_rounded,
                  size: 45.w,
                  color: colors.onBackground,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: Text(
              'Foto de perfil',
              style: textStyles.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(55, 8.0, 55, 32),
            child: Text(
              'Puede seleccionar una foto de nuestros amigos bots o agregar tu propia foto como imagen de perfil',
              textAlign: TextAlign.center,
              style: textStyles.bodyMedium?.copyWith(
                color: colors.onBackground.withOpacity(0.6),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _onCameraClick(),
            child: Text(
              'Agregar mi foto',
              textAlign: TextAlign.center,
              style: textStyles.bodyMedium?.copyWith(
                color: colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildPicWidget(String pic) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        controller.move(pics.indexOf(pic),
            animation:
                pics.indexOf(pic) != pics.length - 1 && pics.indexOf(pic) != 0);
        ref.read(onBoardingNotifierProvider.notifier).onProfilePicChanged(pic);
      },
      child: Card(
        color: colors.surface,
        elevation: 2,
        shape: const CircleBorder(),
        child: Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surface,
          ),
          child: Center(
            child: pic.contains('assets')
                ? Image.asset(
                    pic,
                    fit: BoxFit.cover,
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: Image.file(
                      File(pic),
                    ).image,
                  ),
          ),
        ),
      ),
    );
  }
}
