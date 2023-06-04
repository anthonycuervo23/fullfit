import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class EmailScreen extends ConsumerWidget {
  const EmailScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onBoardingProvider = ref.watch(onBoardingNotifierProvider);
    final textStyles = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 53.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 73.0.w),
            child: Text(
              'Cual es tu correo electronico?',
              textAlign: TextAlign.center,
              style: textStyles.titleMedium,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0.w, vertical: 29.h),
            child: CustomTextFormField(
              initialValue: ref.read(onBoardingNotifierProvider).email.value,
              keyboardType: TextInputType.emailAddress,
              errorMessage: onBoardingProvider.errorMessage,
              hint: 'Ingresa tu correo electronico',
              onChanged:
                  ref.watch(onBoardingNotifierProvider.notifier).onEmailChanged,
            ),
          ),
        ],
      ),
    );
  }
}
