import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class HeightPicker extends StatefulWidget {
  final int maxHeight;
  final int minHeight;
  final int height;
  final double widgetHeight;
  final ValueChanged<int> onChange;

  const HeightPicker(
      {Key? key,
      required this.height,
      required this.widgetHeight,
      required this.onChange,
      this.maxHeight = 195,
      this.minHeight = 150})
      : super(key: key);

  int get totalUnits => maxHeight - minHeight;

  @override
  HeightPickerState createState() => HeightPickerState();
}

class HeightPickerState extends State<HeightPicker> {
  late double startDragYOffset;
  late int startDragHeight;

  double get _pixelsPerUnit {
    return _drawingHeight / widget.totalUnits;
  }

  double get _sliderPosition {
    double halfOfBottomLabel = 14.sp / 2;
    int unitsFromBottom = widget.height - widget.minHeight;
    return halfOfBottomLabel + unitsFromBottom * _pixelsPerUnit;
  }

  ///returns actual input_page.height of slider to be able to slide
  double get _drawingHeight {
    double totalHeight = widget.widgetHeight;
    double marginBottom = 16.0.h;
    double marginTop = 26.0.h;
    return totalHeight - (marginBottom + marginTop + 14.sp);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (TapDownDetails tapDownDetails) =>
            _onTapDown(tapDownDetails, constraints),
        onVerticalDragStart: (DragStartDetails dragStartDetails) =>
            _onDragStart(dragStartDetails, constraints),
        onVerticalDragUpdate: _onDragUpdate,
        child: Stack(
          children: <Widget>[
            _drawPersonImage(),
            _drawSlider(),
            _drawLabels(),
          ],
        ),
      );
    });
  }

  int _globalOffsetToHeight(Offset globalOffset, BoxConstraints constraints) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(globalOffset);
    double dy = localPosition.dy;
    dy = dy - 26.h - 14.sp / 2;
    int height = widget.maxHeight - (dy ~/ _pixelsPerUnit);
    return height;
  }

  _onTapDown(TapDownDetails tapDownDetails, BoxConstraints constraints) {
    int height =
        _globalOffsetToHeight(tapDownDetails.globalPosition, constraints);
    widget.onChange(_normalizeHeight(height));
  }

  _onDragStart(DragStartDetails dragStartDetails, BoxConstraints constraints) {
    int newHeight =
        _globalOffsetToHeight(dragStartDetails.globalPosition, constraints);
    widget.onChange(newHeight);
    setState(() {
      startDragYOffset = dragStartDetails.globalPosition.dy;
      startDragHeight = newHeight;
    });
  }

  _onDragUpdate(DragUpdateDetails dragUpdateDetails) {
    double currentYOffset = dragUpdateDetails.globalPosition.dy;
    double verticalDifference = startDragYOffset - currentYOffset;
    int diffHeight = verticalDifference ~/ _pixelsPerUnit;
    int height = _normalizeHeight(startDragHeight + diffHeight);
    setState(() => widget.onChange(height));
  }

  int _normalizeHeight(int height) {
    return math.max(widget.minHeight, math.min(widget.maxHeight, height));
  }

  Widget _drawSlider() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: _sliderPosition,
      child: HeightSlider(height: widget.height),
    );
  }

  Widget _drawLabels() {
    int labelsToDisplay = widget.totalUnits ~/ 5 + 1;
    List<Widget> labels = List.generate(
      labelsToDisplay,
      (idx) {
        return Text(
          "${widget.maxHeight - 5 * idx}",
          // style: labelsTextStyle,
        );
      },
    );

    return Align(
      alignment: Alignment.centerRight,
      child: IgnorePointer(
        child: Padding(
          padding: EdgeInsets.only(
            right: 12.0.w,
            bottom: 16.0.h,
            top: 26.0.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels,
          ),
        ),
      ),
    );
  }

  Widget _drawPersonImage() {
    double personImageHeight = _sliderPosition + 16.0.h;
    return Align(
      alignment: Alignment.bottomCenter,
      child: SvgPicture.asset(
        "assets/images/person.svg",
        height: personImageHeight,
        width: personImageHeight / 3,
      ),
    );
  }
}
