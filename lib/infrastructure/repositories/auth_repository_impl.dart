import 'package:fullfit_app/domain/datasources/datasources.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/domain/repositories/repositories.dart';
import 'package:fullfit_app/infrastructure/datasources/datasources.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl({AuthDataSource? authDataSource})
      : _authDataSource = authDataSource ?? FirebaseAuthDatasourceImpl();

  @override
  bool isUserLoggedIn() {
    return _authDataSource.isUserLoggedIn();
  }

  @override
  Future<Person> loginWithApple() {
    return _authDataSource.loginWithApple();
  }

  @override
  Future<Person> loginWithEmailPassword(String email, String password) {
    return _authDataSource.loginWithEmailPassword(email, password);
  }

  @override
  Future<Person> loginWithGoogle() {
    return _authDataSource.loginWithGoogle();
  }

  @override
  Future<Person> loginWithTwitter() {
    return _authDataSource.loginWithTwitter();
  }

  @override
  Future<void> logout() {
    return _authDataSource.logout();
  }

  @override
  Future<Person> register(String email, String password, String fullname) {
    return _authDataSource.register(email, password, fullname);
  }

  @override
  Future<Person> getLoggedInUser() {
    return _authDataSource.getLoggedInUser();
  }
}
