import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  PageController controller = PageController();
  List<String> images = [
    'assets/images/welcome_image.png',
    'assets/images/welcome_image2.png',
    'assets/images/welcome_image3.png'
  ];
  List<String> titles = [
    'Bienvenido a FullFit.',
    'Entrenamientos personalizados.',
    'Seguimiento y medición de datos'
  ];
  List<String> subtitles = [
    'FullFit es la app que te ayudará a entrenar tu cuerpo y mente.',
    'Crea tu plan de entrenamiento personalizado a tus necesidades.',
    'Mide tu progreso y mejora tu rendimiento.'
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const AppLogo(),
              SizedBox(height: 18.h),
              SizedBox(
                height: 400.w,
                child: PageView.builder(
                    itemCount: images.length,
                    controller: controller,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 48.0.w),
                            child: Text(
                              titles[index],
                              textAlign: TextAlign.center,
                              style: textStyles.titleMedium,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 48.0.w),
                            child: Text(
                              subtitles[index],
                              textAlign: TextAlign.center,
                              style: textStyles.bodyMedium?.copyWith(
                                color: colors.onBackground.withOpacity(0.6),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Image.asset(
                            images[index],
                          ),
                        ],
                      );
                    }),
              ),
              SmoothPageIndicator(
                controller: controller,
                count: images.length,
                effect: ScaleEffect(
                  dotHeight: 6.h,
                  dotWidth: 6.w,
                  scale: 1.7,
                  spacing: 12,
                  activeDotColor: colors.primary,
                ),
              ),
              SizedBox(height: 40.h),
              CustomBigButton(
                onPressed: () {},
                child: const Text('Comenzar'),
              ),
              SizedBox(height: 16.h),
              RichText(
                text: TextSpan(
                  style: textStyles.bodyMedium?.copyWith(
                    color: colors.onBackground.withOpacity(0.6),
                  ),
                  text: '¿Ya tienes una cuenta?  ',
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Iniciar sesión',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.push('/login'),
                      style: textStyles.bodyMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
