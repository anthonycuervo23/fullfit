import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

//TODO: check if email already exists
class EmailScreen extends ConsumerWidget {
  const EmailScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
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
            child: TextFormField(
              initialValue: ref.read(onBoardingNotifierProvider).email.value,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged:
                  ref.watch(onBoardingNotifierProvider.notifier).onEmailChanged,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Ingresa tu correo electronico',
                hintStyle: textStyles.bodyMedium?.copyWith(
                  color: colors.onBackground.withOpacity(0.5),
                  fontSize: 18.sp,
                ),
                contentPadding: const EdgeInsets.all(20),
                fillColor: colors.surface,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
