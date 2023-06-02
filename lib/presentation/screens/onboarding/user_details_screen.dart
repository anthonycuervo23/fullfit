import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  UserDetailsScreenState createState() => UserDetailsScreenState();
}

enum AgeRange { eighteen, twentyFive, thirtyFive, fiftyFive }

class UserDetailsScreenState extends State<UserDetailsScreen> {
  AgeRange ageRange = AgeRange.eighteen;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 90.h),
              child: Text(
                'Datos personales',
                style: textStyles.titleMedium,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.h),
              child: TextFormField(
                initialValue: '',
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                // onChanged:
                //     ref.watch(onBoardingNotifierProvider.notifier).onEmailChanged,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Ingresa tu nombre',
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.h),
              child: TextFormField(
                initialValue: '',
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                // onChanged:
                //     ref.watch(onBoardingNotifierProvider.notifier).onEmailChanged,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Ingresa tu apellido',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(55, 8.0, 55, 32),
              child: Text(
                'Con tus datos podremos brindar un servicio mas personalizado.',
                textAlign: TextAlign.center,
                style: textStyles.bodyMedium?.copyWith(
                  color: colors.onBackground.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
