import 'dart:async';

import 'package:flutter/material.dart';

class FadeTransitionAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration fadingDuration;
  final Curve slidingCurve;
  final Offset slidingBeginOffset;

  final bool fadeIn;

  const FadeTransitionAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.fadingDuration = const Duration(milliseconds: 800),
    this.slidingCurve = Curves.decelerate,
    this.slidingBeginOffset = const Offset(0.0, -0.10),
    this.fadeIn = true,
  });

  @override
  FadeTransitionAnimationState createState() => FadeTransitionAnimationState();
}

class FadeTransitionAnimationState extends State<FadeTransitionAnimation>
    with TickerProviderStateMixin {
  late AnimationController _opacityController;

  late Animation<Offset> _slideAnimationOffset;

  Timer? _timer;

  Duration get delay => widget.delay;

  Duration get opacityTransitionDuration => widget.fadingDuration;

  Curve get slidingCurve => widget.slidingCurve;

  Offset get beginOffset => widget.slidingBeginOffset;

  bool get fadeIn => widget.fadeIn;

  @override
  void initState() {
    super.initState();

    _opacityController = AnimationController(
      vsync: this,
      duration: opacityTransitionDuration,
    );

    final CurvedAnimation curvedAnimation = CurvedAnimation(
      curve: slidingCurve,
      parent: _opacityController,
    );

    _slideAnimationOffset = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(curvedAnimation);

    _runFadeAnimation();
  }

  @override
  void dispose() {
    _opacityController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(FadeTransitionAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fadeIn == fadeIn) {
      return;
    }
    _runFadeAnimation();
  }

  void _runFadeAnimation() {
    _timer = Timer(delay, () {
      fadeIn ? _opacityController.forward() : _opacityController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
        position: _slideAnimationOffset,
        child: widget.child,
      ),
      opacity: _opacityController,
    );
  }
}
