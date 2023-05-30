import 'package:fullfit_app/domain/entities/entities.dart';

abstract class AuthRepository {
  bool get isUserLogged;
  bool get hasLoggedWithEmailPassword;
  bool get hasBiometricSupport;
  abstract bool didLoggedOutOrFailedBiometricAuth;

  Future<void> deleteStoredCredentials();

  Future<void> performLoginWithEmailPassword(
      String email, String password, Function(bool success) closure);
  Future<void> performLoginWithTwitter(Function(bool success) closure);
  Future<void> performLoginWithGoogle(Function(bool success) closure);
  Future<void> performLoginWithApple(Function(bool success) closure);

  Future<void> performBiometricLogin();
  Future<bool> performBiometricAuthentication();

  Future<Person> register(String email, String password, String fullname);
  Future<void> performLogout();

  Future<void> saveCredentials(
      {required String email, required String password});
}