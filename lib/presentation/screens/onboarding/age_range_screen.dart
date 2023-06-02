import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

class AgeRangeScreen extends ConsumerStatefulWidget {
  const AgeRangeScreen({super.key});

  @override
  AgeRangeScreenState createState() => AgeRangeScreenState();
}

class AgeRangeScreenState extends ConsumerState<AgeRangeScreen> {
  @override
  Widget build(BuildContext context) {
    final ageRanges = ref.watch(onBoardingNotifierProvider).ageRanges;

    final textStyles = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 23, left: 47, right: 47, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 40, left: 25, right: 25),
            child: Text('¿A que rango de edad perteneces?',
                textAlign: TextAlign.center, style: textStyles.titleMedium),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            spacing: 40,
            runSpacing: 39,
            children:
                ageRanges.map((interest) => _buildInterest(interest)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInterest(AgeRange ageRange) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    final selectedAgeRange = ref.watch(onBoardingNotifierProvider).ageRange;

    return GestureDetector(
      onTap: () {
        ref
            .read(onBoardingNotifierProvider.notifier)
            .onAgeRangeChanged(ageRange.range);
      },
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                  // backgroundBlendMode: BlendMode.darken,
                  shape: BoxShape.circle,
                  color: ageRange.range == selectedAgeRange
                      ? colors.primary.withOpacity(0.4)
                      : Colors.white),
              child: Image.asset(
                ageRange.image,
                width: 80.w,
                fit: BoxFit.cover,
              )),
          SizedBox(height: 14.h),
          Text(ageRange.range,
              style: textStyles.titleSmall?.copyWith(
                color: ageRange.range == selectedAgeRange
                    ? colors.primary
                    : colors.onBackground.withOpacity(0.6),
              ))
        ],
      ),
    );
  }
}
