import 'package:flutter/rendering.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:twitter_login/twitter_login.dart';

import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/infrastructure/services/services.dart';
import 'package:fullfit_app/config/config.dart';
import 'package:fullfit_app/domain/datasources/datasources.dart';

class FirebaseAuthDatasourceImpl extends AuthDataSource {
  final KeyValueStorageService _storageService;

  FirebaseAuthDatasourceImpl(
      {required storageService, required personDatasource})
      : _storageService = storageService {
    checkBiometricSupport();
    checkLoggedUser();
  }

  final LocalAuthentication _localAuth = LocalAuthentication();
  final _storage = const FlutterSecureStorage();
  User? _loggedUser;
  List<BiometricType> _availableBiometrics = [];

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AppleAuthProvider _appleProvider = AppleAuthProvider();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TwitterLogin _twitterLogin = TwitterLogin(
    apiKey: Environment.twitterApiKey,
    apiSecretKey: Environment.twitterApiSecret,
    redirectURI: Environment.twitterRedirectUri,
  );

  final String _emailKey = "email_key";
  final String _passwordKey = "password_key";

  late final bool _hasBiometricSupport;
  bool _hasLoggedWithEmailPassword = false;

  @override
  List<BiometricType> get availableBiometrics => _availableBiometrics;

  @override
  set didLoggedOutOrFailedBiometricAuth(
      bool didLoggedOutOrFailedBiometricAuth) {
    _storageService.setKeyValue<bool>(didLoggedOutOrFailedBiometricAuthKey,
        didLoggedOutOrFailedBiometricAuth);
  }

  @override
  bool get didLoggedOutOrFailedBiometricAuth {
    return _storageService
            .getValue<bool>(didLoggedOutOrFailedBiometricAuthKey) ??
        false;
  }

  @override
  bool get hasBiometricSupport {
    return _hasBiometricSupport;
  }

  @override
  bool get hasLoggedWithEmailPassword {
    return _hasLoggedWithEmailPassword;
  }

  @override
  bool get isUserLogged => _loggedUser != null;

  @override
  Future<void> deleteStoredCredentials() async {
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _passwordKey);
  }

  @override
  Future<void> performLoginWithEmailPassword(
      String email, String password, Function(bool success) closure) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _hasLoggedWithEmailPassword = true;
      checkLoggedUser();

      closure(isUserLogged);
    } catch (e) {
      closure(false);
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> performLoginWithApple(Function(bool success) closure) async {
    try {
      await FirebaseAuth.instance.signInWithProvider(_appleProvider);
      _hasLoggedWithEmailPassword = false;
      checkLoggedUser();

      closure(isUserLogged);
    } catch (e) {
      closure(false);
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> performLoginWithGoogle(Function(bool success) closure) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      _hasLoggedWithEmailPassword = false;
      checkLoggedUser();

      closure(isUserLogged);
    } catch (e) {
      closure(false);
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> performLoginWithTwitter(Function(bool success) closure) async {
    try {
      final authResult = await _twitterLogin.loginV2();
      switch (authResult.status) {
        case TwitterLoginStatus.loggedIn:
          final AuthCredential twitterAuthCredential =
              TwitterAuthProvider.credential(
                  accessToken: authResult.authToken!,
                  secret: authResult.authTokenSecret!);

          await FirebaseAuth.instance
              .signInWithCredential(twitterAuthCredential);

          _hasLoggedWithEmailPassword = false;
          checkLoggedUser();

          closure(isUserLogged);
          break;
        case TwitterLoginStatus.cancelledByUser:
        case TwitterLoginStatus.error:
        default:
          closure(false);
          break;
      }
    } catch (e) {
      closure(false);
      debugPrint(e.toString());
    }
  }

  @override
  Future<bool> performBiometricAuthentication() async {
    if (!hasBiometricSupport) {
      // throw Exception('Biometric authentication is not supported');
      return false;
    }

    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to login',
        authMessages: [
          const AndroidAuthMessages(
            biometricHint: '',
            signInTitle: 'Login',
          )
        ],
      );

      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> performBiometricLogin() async {
    final didAuthenticate = await performBiometricAuthentication();
    if (didAuthenticate) {
      final username = await _storage.read(key: _emailKey);
      final password = await _storage.read(key: _passwordKey);
      if (password != null &&
          password.isNotEmpty &&
          username != null &&
          username.isNotEmpty) {
        await performLoginWithEmailPassword(
          username,
          password,
          (success) => {
            if (!success) {throw Exception("Error when login with credentials")}
          },
        );
      } else {
        await deleteStoredCredentials();
        throw Exception("Error when login with biometric and credentials");
      }
    } else {
      throw Exception("Error when login with biometric");
    }
  }

  @override
  Future<Person> register(String email, String password, String fullname) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveCredentials(
      {required String email, required String password}) async {
    _storage.write(key: _emailKey, value: email);
    _storage.write(key: _passwordKey, value: password);
  }

  @override
  Future<void> performLogout() async {
    await _firebaseAuth.signOut();
    checkLoggedUser();
    didLoggedOutOrFailedBiometricAuth = true;
  }
}

//* Extension con metodos propios de la clase
extension _FirebaseAuthDatasourceImplExtension on FirebaseAuthDatasourceImpl {
  Future<void> checkLoggedUser() async {
    try {
      _loggedUser = _firebaseAuth.currentUser;
    } catch (e) {
      _loggedUser = null;
    }
  }

  Future<void> checkBiometricSupport() async {
    _availableBiometrics = await _localAuth.getAvailableBiometrics();
    final canCheckBiometrics = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    _hasBiometricSupport = availableBiometrics.isNotEmpty &&
        canCheckBiometrics &&
        isDeviceSupported;
  }
}
