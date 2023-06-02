import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const CardTitle({
    Key? key,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 8.0.h,
            left: 13.0.w,
            right: 11.0.w,
            bottom: 8.0.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title,
                  style: textStyles.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  )),
              Text(
                subtitle ?? '',
                style: textStyles.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              )
            ],
          ),
        ),
        const Divider(
          height: 1.0,
          color: Color.fromRGBO(143, 144, 156, 0.22),
        ),
      ],
    );
  }
}
