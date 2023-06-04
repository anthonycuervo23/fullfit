// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleCheckbox extends StatefulWidget {
  bool value;
  final ValueChanged<bool?> onChanged;
  final Color activeColor;
  final Color inactiveColor;

  CircleCheckbox(
      {Key? key,
      required this.value,
      required this.onChanged,
      required this.activeColor,
      inactiveColor})
      : inactiveColor = inactiveColor ?? const Color(0xffF4F6FA),
        super(key: key);

  @override
  CircleCheckboxState createState() => CircleCheckboxState();
}

class CircleCheckboxState extends State<CircleCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.value = !widget.value;
        widget.onChanged(widget.value);
        setState(() {});
      },
      child: Container(
          height: 24.h,
          width: 24.w,
          decoration: BoxDecoration(
            border: Border.all(width: 1.w, style: BorderStyle.none),
            color: widget.value ? widget.activeColor : widget.inactiveColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Visibility(
              visible: widget.value,
              child: Image.asset(
                'assets/icons/check_mark.png',
                color: Colors.white,
                height: 14.h,
                width: 14.h,
              ),
            ),
          )),
    );
  }
}
