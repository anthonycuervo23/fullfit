import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:local_auth_android/local_auth_android.dart';

class BiometricScreen extends ConsumerWidget {
  const BiometricScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);

    bool isFaceId() =>
        authRepository.availableBiometrics.contains(BiometricType.face) ||
        authRepository.availableBiometrics.contains(BiometricType.strong);

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
            child: isFaceId()
                ? Icon(Icons.face, size: 124.w)
                : Icon(Icons.fingerprint, size: 124.w),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 31, 24, 8),
            child: Text(
              isFaceId() ? 'Habilitar Face ID' : 'Habilitar Touch ID',
              textAlign: TextAlign.center,
              style: textStyles.titleMedium,
            ),
          ),
          Text(
            isFaceId()
                ? 'Si habilitas Face ID, no necesitas ingresar tu contraseña cuando inicies sesión.'
                : 'Si habilitas Touch ID, no necesitas ingresar tu contraseña cuando inicies sesión.',
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
