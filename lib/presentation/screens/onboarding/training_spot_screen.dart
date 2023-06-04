import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class TrainingSpotScreen extends ConsumerWidget {
  const TrainingSpotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    final List<String> trainingSpots =
        ref.watch(onBoardingNotifierProvider).trainingSpots;

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 22.w, right: 22.w, top: 53.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 38.w),
            child: Text('Donde entrenas?',
                textAlign: TextAlign.center, style: textStyles.titleMedium),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.h, left: 33.w, right: 33.w),
            child: Text(
              'Cuentanos donde entrenas para poder ajustar tus entrenamientos.',
              textAlign: TextAlign.center,
              style: textStyles.bodyMedium
                  ?.copyWith(color: colors.onSurface.withOpacity(0.5)),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 27.h),
            itemCount: trainingSpots.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              String option = trainingSpots[index];
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
                        value:
                            ref.read(onBoardingNotifierProvider).selectedSpot ==
                                option,
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
                            .onTrainingSpotChanged(option);
                      },
                      title: Text(
                        option,
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
