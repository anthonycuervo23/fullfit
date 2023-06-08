import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fullfit_app/infrastructure/services/services.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: const _LoginForm(),
        ),
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    final loginForm = ref.watch(loginFormProvider);
    final authRepository = ref.watch(authRepositoryProvider);
    final authNotifier = ref.watch(authProvider.notifier);

    ref.listen(authProvider, (previous, next) async {
      if (next.errorMessage.isNotEmpty) {
        Alert.error(context, msg: next.errorMessage);
      }

      if (next.status == AuthStatus.checkBiometric) {
        final hasBiometricEnabled = const KeyValueStorageServiceImplementation()
            .getValue<bool>(hasBiometricLoginEnabledKey);
        final lastLoggedEmail = const KeyValueStorageServiceImplementation()
            .getValue<String>(emailKey);
        authRepository.didLoggedOutOrFailedBiometricAuth = false;
        if (authRepository.hasBiometricSupport &&
            (hasBiometricEnabled == false ||
                loginForm.email.value != lastLoggedEmail)) {
          await Alert.promptEnableBiometrics(
            context,
            authRepository: authRepository,
            onEnable: () {
              Navigator.pop(context);
              const KeyValueStorageServiceImplementation()
                  .setKeyValue<bool>(hasBiometricLoginEnabledKey, true);
              authRepository.saveCredentials(
                  email: loginForm.email.value,
                  password: loginForm.password.value);
              const KeyValueStorageServiceImplementation()
                  .setKeyValue<String>(emailKey, loginForm.email.value);
            },
            onDisable: () {
              Navigator.pop(context);
              const KeyValueStorageServiceImplementation()
                  .setKeyValue<bool>(hasBiometricLoginEnabledKey, false);
              const KeyValueStorageServiceImplementation()
                  .setKeyValue<String>(emailKey, loginForm.email.value);
            },
          );
        } else if (authRepository.hasBiometricSupport &&
            hasBiometricEnabled == true) {
          authRepository.saveCredentials(
              email: loginForm.email.value, password: loginForm.password.value);
          const KeyValueStorageServiceImplementation()
              .setKeyValue<String>(emailKey, loginForm.email.value);
        } else {
          const KeyValueStorageServiceImplementation()
              .setKeyValue<String>(emailKey, loginForm.email.value);
        }

        await ref.read(authProvider.notifier).authenticateUser();
      }

      if (next.errorMessage.isEmpty) return;
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        //* Logo
        const TopIconRow(),
        SizedBox(height: 36.h),
        //* email textfield
        FocusDetector(
          onFocusGained: () {
            final hasBiometricEnabled =
                const KeyValueStorageServiceImplementation()
                    .getValue<bool>(hasBiometricLoginEnabledKey);

            if (authRepository.hasBiometricSupport &&
                hasBiometricEnabled == true &&
                !authRepository.didLoggedOutOrFailedBiometricAuth) {
              //* show loading
              // CustomLoader.show();
              authNotifier.loginWithBiometrics((success) async {
                if (success) {
                  authRepository.didLoggedOutOrFailedBiometricAuth = false;

                  await ref.read(authProvider.notifier).authenticateUser();
                  // CustomLoader.dismiss();
                } else {
                  authRepository.didLoggedOutOrFailedBiometricAuth = true;
                  // CustomLoader.dismiss();
                }
              });
            } else {
              authRepository.didLoggedOutOrFailedBiometricAuth = false;
            }
          },
          onForegroundGained: () {
            authRepository.didLoggedOutOrFailedBiometricAuth = false;
          },
          child: Column(
            children: [
              CustomLoginTextfield(
                hint: 'Correo electrónico',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                onChanged: ref.read(loginFormProvider.notifier).onEmailChanged,
                errorMessage: loginForm.isFormPosted
                    ? loginForm.email.errorMessage
                    : null,
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        //* password textfield
        CustomLoginTextfield(
          hint: 'Contraseña',
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          onChanged: ref.read(loginFormProvider.notifier).onPasswordChanged,
          onFieldSubmitted: (p0) =>
              ref.read(loginFormProvider.notifier).onFormSubmitted(),
          errorMessage:
              loginForm.isFormPosted ? loginForm.password.errorMessage : null,
        ),
        SizedBox(height: 50.h),
        const Text('Inicia sesión con'),
        SizedBox(height: 20.h),
        //* social buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              elevation: 0,
              onPressed: () =>
                  authNotifier.loginWithProvider(LoginType.twitter),
              backgroundColor: colors.surface,
              heroTag: 'twitter',
              child: Icon(
                FontAwesomeIcons.twitter,
                color: colors.primary,
              ),
            ),
            Platform.isIOS ? SizedBox(width: 20.w) : const SizedBox(),
            Platform.isIOS
                ? FloatingActionButton(
                    elevation: 0,
                    onPressed: () =>
                        authNotifier.loginWithProvider(LoginType.apple),
                    backgroundColor: colors.surface,
                    heroTag: 'apple',
                    child: Icon(
                      FontAwesomeIcons.apple,
                      color: colors.primary,
                    ),
                  )
                : const SizedBox(),
            SizedBox(width: 20.w),
            FloatingActionButton(
              elevation: 0,
              onPressed: () => authNotifier.loginWithProvider(LoginType.google),
              backgroundColor: colors.surface,
              heroTag: 'google',
              child: Icon(
                FontAwesomeIcons.google,
                color: colors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 80.h),
        CustomBigButton(
          onPressed: loginForm.isPosting
              ? null
              : ref.read(loginFormProvider.notifier).onFormSubmitted,
          child: const Text('Continuar'),
        ),
        SizedBox(height: 20.h),
        TextButton(
          onPressed: () {},
          child: const Text('¿Olvidaste tu contraseña?'),
        ),
      ],
    );
  }
}
