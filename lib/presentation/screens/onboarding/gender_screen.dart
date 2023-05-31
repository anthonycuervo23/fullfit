import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  GenderScreenState createState() => GenderScreenState();
}

class GenderScreenState extends State<GenderScreen> {
  int genderSelected = 0;
  List<Gender> genders = [
    Gender('Male', '🙋🏼‍♂️'),
    Gender('Female', '🙋🏼'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding:
          EdgeInsets.only(left: 24.w, right: 24.w, top: 100.h, bottom: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 28.w, right: 28.w),
            child: Text(
              'Which one are you?',
              style: textStyles.titleMedium,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: genders
                  .map(
                    (gender) => GestureDetector(
                      onTap: () {
                        setState(() {
                          gender.title == 'Male'
                              ? genderSelected != 1
                                  ? genderSelected = 1
                                  : genderSelected = 0
                              : genderSelected != 2
                                  ? genderSelected = 2
                                  : genderSelected = 0;
                        });
                      },
                      child: Card(
                        color: colors.surface,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      gender.emoji,
                                      style: TextStyle(fontSize: 60.sp),
                                    ),
                                    SizedBox(height: 33.h),
                                    Text(
                                      gender.title,
                                      style: textStyles.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: CircleCheckbox(
                                    activeColor: colors.primary,
                                    inactiveColor:
                                        colors.onSurface.withOpacity(0.3),
                                    value: gender.title == 'Male'
                                        ? genderSelected == 1
                                        : genderSelected == 2,
                                    onChanged: (value) {
                                      setState(() {
                                        gender.title == 'Male'
                                            ? genderSelected != 1
                                                ? genderSelected = 1
                                                : genderSelected = 0
                                            : genderSelected != 2
                                                ? genderSelected = 2
                                                : genderSelected = 0;
                                      });
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23),
            child: Text(
              'To give you a better experience we need to know your gender',
              textAlign: TextAlign.center,
              style: textStyles.bodyMedium
                  ?.copyWith(color: colors.onSurface.withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }
}

class Gender {
  String title;
  String emoji;

  Gender(this.title, this.emoji);
}
