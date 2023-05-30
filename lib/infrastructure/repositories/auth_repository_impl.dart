import 'package:fullfit_app/domain/datasources/datasources.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/domain/repositories/repositories.dart';
import 'package:fullfit_app/infrastructure/datasources/datasources.dart';
import 'package:fullfit_app/infrastructure/services/services.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(
      {AuthDataSource? authDataSource,
      PersonDatasource? personDatasource,
      required KeyValueStorageService storageService})
      : _authDataSource = authDataSource ??
            FirebaseAuthDatasourceImpl(
                storageService: storageService,
                personDatasource: personDatasource ?? PersonDatasourceImpl());

  @override
  bool get didLoggedOutOrFailedBiometricAuth =>
      _authDataSource.didLoggedOutOrFailedBiometricAuth;

  @override
  set didLoggedOutOrFailedBiometricAuth(
      bool didLoggedOutOrFailedBiometricAuth) {
    _authDataSource.didLoggedOutOrFailedBiometricAuth =
        didLoggedOutOrFailedBiometricAuth;
  }

  @override
  Future<void> deleteStoredCredentials() {
    return _authDataSource.deleteStoredCredentials();
  }

  @override
  bool get hasBiometricSupport => _authDataSource.hasBiometricSupport;

  @override
  bool get hasLoggedWithEmailPassword =>
      _authDataSource.hasLoggedWithEmailPassword;

  @override
  bool get isUserLogged => _authDataSource.isUserLogged;

  @override
  Future<bool> performBiometricAuthentication() {
    return _authDataSource.performBiometricAuthentication();
  }

  @override
  Future<void> performBiometricLogin() {
    return _authDataSource.performBiometricLogin();
  }

  @override
  Future<void> performLoginWithApple(Function(bool success) closure) {
    return _authDataSource.performLoginWithApple(closure);
  }

  @override
  Future<void> performLoginWithEmailPassword(
      String email, String password, Function(bool success) closure) {
    return _authDataSource.performLoginWithEmailPassword(
        email, password, closure);
  }

  @override
  Future<void> performLoginWithGoogle(Function(bool success) closure) {
    return _authDataSource.performLoginWithGoogle(closure);
  }

  @override
  Future<void> performLoginWithTwitter(Function(bool success) closure) {
    return _authDataSource.performLoginWithTwitter(closure);
  }

  @override
  Future<void> performLogout() {
    return _authDataSource.performLogout();
  }

  @override
  Future<Person> register(String email, String password, String fullname) {
    return _authDataSource.register(email, password, fullname);
  }

  @override
  Future<void> saveCredentials(
      {required String email, required String password}) {
    return _authDataSource.saveCredentials(email: email, password: password);
  }
}