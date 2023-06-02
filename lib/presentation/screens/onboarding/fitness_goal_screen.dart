import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class FitnessGoalScreen extends ConsumerWidget {
  const FitnessGoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    final Map<String, bool> helpOptions =
        ref.watch(onBoardingNotifierProvider).fitnessGoals;

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 22.w, right: 22.w, top: 53.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 38.w),
            child: Text('Cuentanos tus objetivos',
                textAlign: TextAlign.center, style: textStyles.titleMedium),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.h, left: 33.w, right: 33.w),
            child: Text(
              'Puedes cambiar esto más tarde.',
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
                          ref
                              .read(onBoardingNotifierProvider.notifier)
                              .onFitnessGoalChanged(option, value ?? false);
                        },
                      ),
                      onTap: () {
                        ref
                            .read(onBoardingNotifierProvider.notifier)
                            .onFitnessGoalChanged(
                                option, !(helpOptions[option] ?? true));
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
