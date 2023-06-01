import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

class FitnessLevelScreen extends ConsumerWidget {
  const FitnessLevelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingProvider = ref.watch(onBoardingNotifierProvider);

    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 99.h, left: 22.w, right: 22.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 61.0.h, right: 38.w, left: 38.w),
            child: Text(
              '¿Cuál es tu condición física actual?',
              textAlign: TextAlign.center,
              style: textStyles.titleMedium,
            ),
          ),
          SizedBox(
            height: 50.h,
            child: _FitnessMeter(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 22.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 77.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17.5),
                      color: colors.primary.withOpacity(0.1)),
                  child: Center(
                    child: Text(
                      'Muy baja',
                      style: textStyles.bodyMedium?.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 77,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17.5),
                      color: colors.primary.withOpacity(0.1)),
                  child: Center(
                    child: Text(
                      'Excelente',
                      style: textStyles.bodyMedium?.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(77.w, 63.h, 77.w, 13.h),
            child: Text(
              onboardingProvider.fitnessLevel.title,
              style: textStyles.titleSmall,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 43.w),
            child: Text(onboardingProvider.fitnessLevel.description,
                textAlign: TextAlign.center, style: textStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _FitnessMeter extends ConsumerStatefulWidget {
  @override
  FitnessMeterState createState() => FitnessMeterState();
}

class FitnessMeterState extends ConsumerState<_FitnessMeter> {
  List<double> bars = [];
  late double barPosition = 150;
  double barWidth = 4.15;
  double maxBarHeight = 24;
  double minBarHeight = 4.96;
  double barIncreaseRate = 0.27;
  int numberOfBars = 65;

  void randomNumberGenerator() {
    bars = List.generate(numberOfBars,
        (index) => minBarHeight + (barIncreaseRate * (index + 1)));
  }

  _onTapDown(TapDownDetails details) {
    setState(() {
      barPosition = details.globalPosition.dx;
    });
  }

  @override
  void initState() {
    super.initState();
    if (bars.isNotEmpty) bars = [];
    randomNumberGenerator();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTapDown: (TapDownDetails details) => _onTapDown(details),
          child: ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [const Color(0xff8B63E6), colors.primary],
              ).createShader(
                Rect.fromLTRB(0, 0, rect.width, rect.height),
              );
            },
            blendMode: BlendMode.srcIn,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: bars.map(
                (double height) {
                  return Container(
                    margin: EdgeInsets.only(right: 1.04.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: height,
                    width: barWidth,
                  );
                },
              ).toList(),
            ),
          ),
        ),
        Positioned(
          left: barPosition - 50,
          child: GestureDetector(
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              if (details.globalPosition.dx >= 40 &&
                  details.globalPosition.dx <= 360) {
                setState(() {
                  barPosition = details.globalPosition.dx;
                });
                ref
                    .read(onBoardingNotifierProvider.notifier)
                    .onFitnessLevelChanged(barPosition);
              }
            },
            child: Card(
              elevation: 4,
              shape: const CircleBorder(),
              child: Container(
                width: 38.w,
                height: 38.h,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}
