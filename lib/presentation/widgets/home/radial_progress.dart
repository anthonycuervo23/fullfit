import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class RadialProgress extends StatefulWidget {
  final double height, width, progress;
  final int leftAmount;

  const RadialProgress({
    Key? key,
    required this.height,
    required this.width,
    required this.progress,
    required this.leftAmount,
  }) : super(key: key);

  @override
  State<RadialProgress> createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      duration:
          const Duration(seconds: 2), // Define la duración de la animación aquí
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0, end: widget.progress)
        .animate(_progressAnimationController)
      ..addListener(() {
        setState(() {}); // llama a setState para volver a pintar
      });

    _progressAnimationController.forward(); // Inicia la animación
  }

  @override
  void didUpdateWidget(RadialProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(begin: 0, end: widget.progress)
          .animate(_progressAnimationController)
        ..addListener(() {
          setState(() {}); // llama a setState para volver a pintar
        });
      _progressAnimationController.reset();
      _progressAnimationController.forward(); // Inicia la animación
    }
  }

  @override
  void dispose() {
    _progressAnimationController.dispose(); // No olvides liberar los recursos
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    return CustomPaint(
      painter: _RadialPainter(
        progress: _progressAnimation.value == 0 ? 1 : _progressAnimation.value,
        progressColor: widget.progress == 0
            ? colors.primary.withOpacity(0.1)
            : colors.primary,
      ),
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                    text: '${widget.leftAmount.round()}',
                    style: textStyles.titleMedium?.copyWith(
                      fontSize: 24.sp,
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    )),
                const TextSpan(text: '\n'),
                TextSpan(
                  text: 'kcal left',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double progress;
  final Color progressColor;

  _RadialPainter({required this.progress, required this.progressColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 360 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
      math.radians(-relativeProgress),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_RadialPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }

  // @override
  // bool shouldRepaint(CustomPainter oldDelegate) {
  //   return true;
  // }
}
