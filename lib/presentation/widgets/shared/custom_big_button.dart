import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBigButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  const CustomBigButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: FilledButton(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
            Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
