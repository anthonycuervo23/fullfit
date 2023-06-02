import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeightSlider extends StatelessWidget {
  final int height;

  const HeightSlider({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SliderLabel(height: height),
          const Row(
            children: <Widget>[
              _SliderCircle(),
              Expanded(child: SliderLine()),
            ],
          ),
        ],
      ),
    );
  }
}

class _SliderLabel extends StatelessWidget {
  final int height;

  const _SliderLabel({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(
        left: 4.0.w,
        bottom: 2.0.h,
      ),
      child: Text(
        "$height",
        style: textStyles.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
          color: colors.primary,
        ),
      ),
    );
  }
}

class SliderLine extends StatelessWidget {
  const SliderLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: List.generate(
          40,
          (i) => Expanded(
                child: Container(
                  height: 2.0,
                  decoration: BoxDecoration(
                      color: i.isEven
                          ? Theme.of(context).primaryColor
                          : Colors.white),
                ),
              )),
    );
  }
}

class _SliderCircle extends StatelessWidget {
  const _SliderCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.unfold_more,
        color: Colors.white,
        size: 0.6 * 32.w,
      ),
    );
  }
}
