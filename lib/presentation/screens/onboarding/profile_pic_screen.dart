import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicScreen extends StatefulWidget {
  const ProfilePicScreen({super.key});

  @override
  ProfilePicScreenState createState() => ProfilePicScreenState();
}

class ProfilePicScreenState extends State<ProfilePicScreen> {
  File? _image;
  final _imagePicker = ImagePicker();
  List<dynamic> pics = [
    '🐵',
    '👻',
    '🐱',
    '👽',
    '🤠',
    '🤪',
    '😍',
    '🤡',
    '🐸',
    '🐲',
    '🐥',
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
        pics.add(_image);
      });
    }
  }

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        'This will be visible to other users',
        style: TextStyle(fontSize: 15.0.sp),
      ),
      title: Text(
        'Add Profile Picture',
        style: TextStyle(fontSize: 18.0.sp),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              setState(() {
                _image = File(image.path);
                pics.add(_image);
              });
              await Future.delayed(const Duration(milliseconds: 300), () {
                controller.move(pics.length - 1, animation: false);
              });
            }
          },
          child: const Text('Choose from gallery'),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.camera);
            if (image != null) {
              setState(() {
                _image = File(image.path);
                pics.add(_image);
              });
              await Future.delayed(const Duration(milliseconds: 300), () {
                controller.move(pics.length - 1, animation: false);
              });
            }
          },
          child: const Text('Take a picture'),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text('Cancel'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
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
              'Profile Picture',
              style: textStyles.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(55, 8.0, 55, 32),
            child: Text(
              'You can select photo from one of this emoji or add your own photo as profile picture',
              textAlign: TextAlign.center,
              style: textStyles.bodyMedium?.copyWith(
                color: colors.onBackground.withOpacity(0.6),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _onCameraClick(),
            child: Text(
              'Add Custom Photo',
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

  buildPicWidget(dynamic pic) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => controller.move(pics.indexOf(pic),
          animation:
              pics.indexOf(pic) != pics.length - 1 && pics.indexOf(pic) != 0),
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
            child: pic is String
                ? Text(
                    pic,
                    style: textStyles.titleMedium?.copyWith(
                      fontSize: 40.sp,
                    ),
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: Image.file(
                      pic,
                    ).image,
                  ),
          ),
        ),
      ),
    );
  }
}
