import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

class PasswordScreen extends ConsumerStatefulWidget {
  const PasswordScreen({super.key});

  @override
  PasswordScreenState createState() => PasswordScreenState();
}

class PasswordScreenState extends ConsumerState<PasswordScreen> {
  bool _obscureText = true,
      isLongEnough = false,
      hasUppercase = false,
      hasNumber = false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    checkPassword(ref.read(onBoardingNotifierProvider).password.value);
  }

  void checkPassword(String password) {
    isLongEnough = password.length >= 8;
    hasUppercase = password.contains(
      RegExp('(?=.*[A-Z])'),
    );
    hasNumber = password.contains(
      RegExp('(?=.*\\d)'),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 22.0.w, right: 22.0.w, top: 53.0.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: Text(
              'Ahora configura tu contraseña',
              textAlign: TextAlign.center,
              style: textStyles.titleMedium,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 22.h, bottom: 26.h),
            child: TextFormField(
              style: textStyles.titleMedium?.copyWith(
                color: colors.onBackground.withOpacity(0.5),
              ),
              initialValue: ref.read(onBoardingNotifierProvider).password.value,
              onChanged: (String newPassword) {
                checkPassword(newPassword);
                ref
                    .watch(onBoardingNotifierProvider.notifier)
                    .onPasswordChanged(newPassword);
              },
              obscureText: _obscureText,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              obscuringCharacter: '●',
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () => _toggle(),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Icon(
                    _obscureText
                        ? CupertinoIcons.eye_slash_fill
                        : CupertinoIcons.eye_fill,
                    color: colors.primary,
                  ),
                ),
                filled: true,
                isDense: false,
                hintText: 'Ingresa tu contraseña',
                hintStyle: textStyles.bodyMedium?.copyWith(
                  color: colors.onBackground.withOpacity(0.5),
                  fontSize: 20,
                ),
                contentPadding: const EdgeInsets.all(8),
                fillColor: colors.surface,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isLongEnough
                          ? colors.primary
                          : colors.onSurface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const SizedBox(
                      width: 15,
                      height: 15,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '8+ caracteres',
                    style: textStyles.bodyMedium?.copyWith(
                      color: colors.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 19),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: hasUppercase
                          ? colors.primary
                          : colors.onSurface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const SizedBox(
                      width: 15,
                      height: 15,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Al menos 1 mayúscula',
                    style: textStyles.bodyMedium?.copyWith(
                      color: colors.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 19),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: hasNumber
                          ? colors.primary
                          : colors.onSurface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const SizedBox(
                      width: 15,
                      height: 15,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Al menos 1 número',
                    style: textStyles.bodyMedium?.copyWith(
                      color: colors.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
