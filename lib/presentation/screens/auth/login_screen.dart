import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              //* Logo
              const TopIconRow(),
              SizedBox(height: 36.h),
              //* email textfield
              const CustomLoginTextfield(
                hint: 'Correo electrónico',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.h),
              //* password textfield
              const CustomLoginTextfield(
                hint: 'Contraseña',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
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
                    onPressed: () {},
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
                          onPressed: () {},
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
                    onPressed: () {},
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
                onPressed: () {},
                child: const Text('Continuar'),
              ),
              SizedBox(height: 20.h),
              TextButton(
                onPressed: () {},
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
