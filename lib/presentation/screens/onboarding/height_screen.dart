import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class HeightScreen extends ConsumerWidget {
  const HeightScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = ref.watch(onBoardingNotifierProvider).height;
    final textStyles = Theme.of(context).textTheme;
    return ListView(
      padding: EdgeInsets.only(top: 24.0.h),
      children: [
        Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 73.0.w, right: 73.0.w, bottom: 29.h),
                child: Text(
                  'Indica tu altura',
                  textAlign: TextAlign.center,
                  style: textStyles.titleMedium,
                ),
              ),
              HeightCard(
                height: height,
                onChanged: (val) {
                  ref
                      .read(onBoardingNotifierProvider.notifier)
                      .onHeightChanged(val);
                },
              ),
            ]),
      ],
    );
  }
}
