// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeightSlider extends StatelessWidget {
  WeightSlider({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.onChanged,
    required this.width,
  })  : scrollController = ScrollController(
          initialScrollOffset: (value - minValue) * width / 3,
        ),
        super(key: key);

  final int minValue;
  final int maxValue;
  final int value;
  final ValueChanged<int> onChanged;
  final double width;
  final ScrollController scrollController;

  double get itemExtent => width / 3;

  int _indexToValue(int index) => minValue + (index - 1);

  @override
  build(BuildContext context) {
    int itemCount = (maxValue - minValue) + 3;
    return NotificationListener(
      onNotification: _onNotification,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemExtent: itemExtent,
        itemCount: itemCount,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          int itemValue = _indexToValue(index);
          bool isExtra = index == 0 || index == itemCount - 1;

          return isExtra
              ? Container() //empty first and last element
              : GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _animateTo(itemValue, durationMillis: 50),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      itemValue.toString(),
                      style: _getTextStyle(context, itemValue),
                    ),
                  ),
                );
        },
      ),
    );
  }

  TextStyle _getDefaultTextStyle() {
    return TextStyle(
      color: const Color.fromRGBO(196, 197, 203, 1.0),
      fontSize: 18.0.sp,
    );
  }

  TextStyle _getHighlightTextStyle(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return textStyles.titleMedium!.copyWith(
      color: colors.primary,
      fontSize: 40.0.sp,
    );
  }

  TextStyle _getTextStyle(BuildContext context, int itemValue) {
    return itemValue == value
        ? _getHighlightTextStyle(context)
        : _getDefaultTextStyle();
  }

  bool _userStoppedScrolling(Notification notification) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  _animateTo(int valueToSelect, {int durationMillis = 200}) {
    double targetExtent = (valueToSelect - minValue) * itemExtent;
    scrollController.animateTo(
      targetExtent,
      duration: Duration(milliseconds: durationMillis),
      curve: Curves.decelerate,
    );
  }

  int _offsetToMiddleIndex(double offset) => (offset + width / 2) ~/ itemExtent;

  int _offsetToMiddleValue(double offset) {
    int indexOfMiddleElement = _offsetToMiddleIndex(offset);
    int middleValue = _indexToValue(indexOfMiddleElement);
    middleValue = math.max(minValue, math.min(maxValue, middleValue));
    return middleValue;
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      int middleValue = _offsetToMiddleValue(notification.metrics.pixels);

      if (_userStoppedScrolling(notification)) {
        _animateTo(middleValue);
      }

      if (middleValue != value) {
        onChanged(middleValue); //update selection
      }
    }
    return true;
  }
}