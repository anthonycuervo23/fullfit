import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class WeightScreen extends ConsumerWidget {
  const WeightScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weight = ref.watch(onBoardingNotifierProvider).weight;
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return ListView(
      padding: EdgeInsets.only(top: 68.0.h),
      children: [
        Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 30.h),
                child: WeightCard(
                  weight: weight,
                  onChanged: (val) {
                    ref
                        .read(onBoardingNotifierProvider.notifier)
                        .onWeightChanged(val);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.h),
                child: Text(
                  'Cual es tu peso?',
                  style: textStyles.titleMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(55, 8.0, 55, 32),
                child: Text(
                  'Con tu peso y altura podemos calcular tu IMC y recomendarte un plan de entrenamiento personalizado.',
                  textAlign: TextAlign.center,
                  style: textStyles.bodyMedium?.copyWith(
                    color: colors.onBackground.withOpacity(0.6),
                  ),
                ),
              ),
            ]),
      ],
    );
  }
}
