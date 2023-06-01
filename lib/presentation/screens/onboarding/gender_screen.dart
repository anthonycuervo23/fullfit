import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class GenderScreen extends ConsumerWidget {
  const GenderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingProvider = ref.read(onBoardingNotifierProvider.notifier);
    final onboardingState = ref.watch(onBoardingNotifierProvider);
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
              '¿Cual eres tu?',
              style: textStyles.titleMedium,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: onboardingState.genders
                  .map(
                    (gender) => GestureDetector(
                      onTap: () {
                        onboardingProvider.onGenderSelected(gender.title);
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(gender.image, height: 120.h),
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
                                        ? onboardingState.genderSelected == 1
                                        : onboardingState.genderSelected == 2,
                                    onChanged: (value) {
                                      onboardingProvider
                                          .onGenderSelected(gender.title);
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
              'Para brindarte una mejor experiencia necesitamos saber tu género.',
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
