import 'package:local_auth_android/local_auth_android.dart';

abstract class AuthDataSource {
  bool get isUserLogged;
  bool get hasLoggedWithEmailPassword;
  bool get hasBiometricSupport;
  bool get didLoggedOutOrFailedBiometricAuth;
  List<BiometricType> get availableBiometrics;
  set didLoggedOutOrFailedBiometricAuth(bool didLoggedOutOrFailedBiometricAuth);

  Future<void> deleteStoredCredentials();

  Future<void> performLoginWithEmailPassword(
      String email, String password, Function(bool success) closure);
  Future<void> performLoginWithTwitter(Function(bool success) closure);
  Future<void> performLoginWithGoogle(Function(bool success) closure);
  Future<void> performLoginWithApple(Function(bool success) closure);

  Future<void> performBiometricLogin();
  Future<bool> performBiometricAuthentication();

  Future<bool> register(String email, String password);
  Future<void> performLogout();

  Future<bool> checkAccountExists(String email);

  Future<void> saveCredentials(
      {required String email, required String password});
}
