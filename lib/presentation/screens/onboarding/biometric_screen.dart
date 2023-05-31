import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  BiometricScreenState createState() => BiometricScreenState();
}

class BiometricScreenState extends State<BiometricScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 55.w, right: 55.w, top: 143.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xff8B63E6), colors.primary],
              ).createShader(
                Rect.fromLTRB(0, 0, rect.width, rect.height),
              );
            },
            blendMode: BlendMode.srcIn,
            //TODO: Cambiar el icono dependiendo del tipo de biometría disponible
            //TODO: usar fontawesome
            child: Icon(Icons.fingerprint, size: 124.w),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 31, 24, 8),
            child: Text(
              'Habilitar Touch ID',
              textAlign: TextAlign.center,
              style: textStyles.titleMedium,
            ),
          ),
          Text(
            'Si habilitas Touch ID, no necesitas ingresar tu contraseña cuando inicies sesión.',
            textAlign: TextAlign.center,
            style: textStyles.bodyMedium?.copyWith(
              color: colors.onBackground.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 54.h),
        ],
      ),
    );
  }
}
