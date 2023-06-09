import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fullfit_app/config/config.dart';
import 'package:fullfit_app/domain/repositories/repositories.dart';

class Alert extends StatelessWidget {
  final String title;
  final String? message;
  final String? errorMessage;
  final bool hasBackdrop;
  final bool isLoadingAlert;

  const Alert._(
    this.title,
    this.message,
    this.hasBackdrop, {
    Key? key,
    this.isLoadingAlert = false,
    this.errorMessage,
  }) : super(key: key);

  static Future<void> info(ctx, String title, String msg, {bool drop = true}) {
    return Alert._(title, msg, drop)._show(ctx);
  }

  static Future<void> error(ctx, {required String msg, bool drop = true}) {
    return Alert._('Oh no! :(', msg, drop)._show(ctx);
  }

  static Future<void> detailedError(ctx,
      {required String msg, bool drop = true, required String errorMessage}) {
    return Alert._(
      'Oh no! :(',
      msg,
      drop,
      errorMessage: errorMessage,
    )._show(ctx);
  }

  static Future<void> success(ctx, {required String msg, bool drop = true}) {
    return Alert._('Éxito!', msg, drop)._show(ctx);
  }

  static Future<void> loading(ctx, {required String title, bool drop = true}) {
    return Alert._(title, null, drop, isLoadingAlert: true)._show(ctx);
  }

  static Future<void> noInternet(ctx) {
    return error(ctx,
        msg:
            'Sin conexión a Internet. Por favor, inténtelo de nuevo más tarde.');
  }

  static Future<void> promtWithOptions(BuildContext context,
      {String confirmTitle = 'Confirm',
      String cancelTitle = 'Cancel',
      Widget? content,
      required String title,
      required void Function()? onConfirm,
      required void Function()? onCancel}) {
    Widget yesButton = Platform.isIOS
        ? TextButton(
            onPressed: () {
              onConfirm?.call();
              Navigator.pop(rootNavigatorKey.currentContext!);
            },
            child: Text(confirmTitle),
          )
        : CupertinoDialogAction(
            onPressed: () {
              onConfirm?.call();
              Navigator.pop(rootNavigatorKey.currentContext!);
            },
            child: Text(confirmTitle),
          );

    Widget noButton = Platform.isIOS
        ? TextButton(
            onPressed: () {
              onCancel?.call();
              Navigator.pop(rootNavigatorKey.currentContext!);
            },
            child: Text(cancelTitle),
          )
        : CupertinoDialogAction(
            onPressed: () {
              onCancel?.call();
              Navigator.pop(rootNavigatorKey.currentContext!);
            },
            child: Text(cancelTitle),
          );

    if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: content,
          actions: <Widget>[
            yesButton,
            noButton,
          ],
        ),
      );
    } else {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: content,
          actions: <Widget>[
            yesButton,
            noButton,
          ],
        ),
      );
    }
  }

  static Future<void> promptEnableBiometrics(BuildContext context,
      {required Function onEnable,
      required Function onDisable,
      required AuthRepository authRepository}) {
    Widget yesButton = Platform.isIOS
        ? TextButton(
            child: const Text('Si'),
            onPressed: () async {
              final bool didAuthenticate =
                  await authRepository.performBiometricAuthentication();
              if (didAuthenticate) {
                onEnable.call();
              } else {
                onDisable.call();
              }
            },
          )
        : CupertinoDialogAction(
            child: const Text('Si'),
            onPressed: () async {
              final bool didAuthenticate =
                  await authRepository.performBiometricAuthentication();
              if (didAuthenticate) {
                onEnable.call();
              } else {
                onDisable.call();
              }
            },
          );

    Widget noButton = Platform.isIOS
        ? TextButton(
            child: const Text('No'),
            onPressed: () {
              onDisable.call();
            },
          )
        : CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () {
              onDisable.call();
            },
          );

    if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('¿Desea habilitar el inicio de sesión biométrico?'),
          actions: <Widget>[
            yesButton,
            noButton,
          ],
        ),
      );
    } else {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¿Desea habilitar el inicio de sesión biométrico?'),
          actions: <Widget>[
            yesButton,
            noButton,
          ],
        ),
      );
    }
  }

  Widget _buildLoadingAlert(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CupertinoActivityIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(title),
            ),
          ],
        ),
      );
    } else {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(title),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildMessageAlert(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: message == null
            ? null
            : errorMessage == null
                ? Text(message!)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(message!),
                      const Divider(
                        height: 30,
                        thickness: 1,
                      ),
                      Flexible(
                          child: Text(
                        errorMessage!,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 60,
                      ))
                    ],
                  ),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: Text(title),
        content: message == null
            ? null
            : errorMessage == null
                ? Text(message!)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(message!),
                      const Divider(
                        height: 30,
                        thickness: 1,
                      ),
                      Flexible(
                          child: Text(
                        errorMessage!,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 60,
                      ))
                    ],
                  ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final alert = isLoadingAlert
        ? _buildLoadingAlert(context)
        : _buildMessageAlert(context);
    return hasBackdrop ? _Backdrop(child: alert) : alert;
  }

  Future<void> _show(BuildContext context) {
    if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        barrierDismissible: !isLoadingAlert,
        builder: (BuildContext context) => this,
      );
    } else {
      return showDialog(
        context: context,
        barrierDismissible: !isLoadingAlert,
        builder: (BuildContext context) => this,
      );
    }
  }
}

class _Backdrop extends StatelessWidget {
  final Widget child;

  const _Backdrop({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: child,
    );
  }
}
