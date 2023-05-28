import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TopIconRow extends StatelessWidget {
  final void Function()? onBackPressed;
  const TopIconRow({
    super.key,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackPressed ?? () => context.pop(),
        ),
        Image.asset(
          'assets/images/app_logo2.png',
          height: 80.h,
          width: 80.w,
        ),
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: false,
          child:
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
        ),
      ],
    );
  }
}
