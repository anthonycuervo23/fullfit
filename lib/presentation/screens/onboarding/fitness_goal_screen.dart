import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class FitnessGoalScreen extends StatefulWidget {
  const FitnessGoalScreen({super.key});

  @override
  HowToHelpYouState createState() => HowToHelpYouState();
}

class HowToHelpYouState extends State<FitnessGoalScreen> {
  Map<String, bool> helpOptions = {
    'Weight loss': false,
    'Better sleeping habit': false,
    'Track my nutrition': false,
    'Improve overall fitness': false
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 22.w, right: 22.w, top: 53.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 38.w),
            child: Text('Let us know how we can help you',
                textAlign: TextAlign.center, style: textStyles.titleMedium),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.h, left: 33.w, right: 33.w),
            child: Text(
              'You always can change this later',
              textAlign: TextAlign.center,
              style: textStyles.bodyMedium
                  ?.copyWith(color: colors.onSurface.withOpacity(0.5)),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 27.h),
            itemCount: helpOptions.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              String option = helpOptions.keys.elementAt(index);
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  height: 77,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colors.surface,
                      shape: BoxShape.rectangle),
                  child: Center(
                    child: ListTile(
                      trailing: CircleCheckbox(
                        value: helpOptions[option] ?? false,
                        activeColor: colors.primary,
                        inactiveColor: colors.onSurface.withOpacity(0.3),
                        onChanged: (value) {
                          setState(() {
                            helpOptions[option] = value ?? false;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          helpOptions[option] = !(helpOptions[option] ?? true);
                        });
                      },
                      title: Text(
                        helpOptions.keys.elementAt(index),
                        style: textStyles.bodyMedium
                            ?.copyWith(color: colors.primary),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
