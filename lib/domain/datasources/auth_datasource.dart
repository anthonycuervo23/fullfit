import 'package:fullfit_app/domain/entities/entities.dart';

abstract class AuthDataSource {
  Future<Person> getLoggedInUser();
  Future<Person> loginWithEmailPassword(String email, String password);
  Future<Person> loginWithTwitter();
  Future<Person> loginWithGoogle();
  Future<Person> loginWithApple();
  Future<Person> register(String email, String password, String fullname);
  Future<void> logout();
  bool isUserLoggedIn();
}
