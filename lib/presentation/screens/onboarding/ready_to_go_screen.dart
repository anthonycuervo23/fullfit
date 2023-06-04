import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/auth/auth.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class ReadyToGoScreen extends ConsumerWidget {
  const ReadyToGoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset('assets/images/purple_background.png').image,
              fit: BoxFit.fill),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 55.w),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                          height: 112.h,
                          width: 112.w,
                          decoration: BoxDecoration(
                              color: colors.surface, shape: BoxShape.circle),
                          child: const AppLogo()),
                      Image.asset(
                        'assets/images/bubbles.png',
                        height: 181.w,
                        width: 272.h,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 32.h, bottom: 12.h),
                    child: Text('¡Todo está listo!',
                        style: textStyles.titleMedium
                            ?.copyWith(color: Colors.white) //FontWeight.w500
                        ),
                  ),
                  Text(
                    'Gracias por tomarte el tiempo para crear una cuenta con nosotros. Ahora viene la parte divertida, exploremos la aplicación.',
                    textAlign: TextAlign.center,
                    style: textStyles.bodyMedium
                        ?.copyWith(fontSize: 16, color: Colors.white), //16
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colors.surface,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23.5))),
                    onPressed: () async => await ref
                        .read(authProvider.notifier)
                        .authenticateUser(),
                    child: Text(
                      'Comenzar',
                      style: textStyles.titleSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
