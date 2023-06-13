import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    this.isLoading = true,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    return FadeInUp(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 32, right: 32),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          color: colors.primary.withOpacity(0.8),
        ),
        child: SizedBox(
          height: 180.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(width: 20),
              Padding(
                padding: EdgeInsets.only(top: 16.0.h, left: 16.w),
                child: Text(
                  isLoading
                      ? 'GENERATING YOUR WORKOUT FOR TODAY, PLEASE WAIT....'
                      : 'SOMETHING WENT WRONG, PLEASE TRY AGAIN LATER',
                  style: textStyles.titleMedium
                      ?.copyWith(fontSize: 16.sp, color: Colors.white),
                ),
              ),
              Expanded(
                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: colors.surface,
                        )
                      : Image.asset('assets/icons/check_mark.png',
                          width: 50.w, height: 50.h, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
