import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';
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
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TwitterLogin _twitterLogin = TwitterLogin(
    apiKey: Environment.twitterApiKey,
    apiSecretKey: Environment.twitterApiSecret,
    redirectURI: Environment.twitterRedirectUri,
  );

  final String _emailKey = "email_key";
  final String _passwordKey = "password_key";

  late final bool _hasBiometricSupport;
  bool _hasLoggedWithEmailPassword = true;

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
      // await FirebaseAuth.instance.signInWithProvider(_appleProvider);
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final UserCredential credentials =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      _storageService.setKeyValue<String>(
          emailKey, credentials.user?.email ?? 'no-email');

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

      final UserCredential credentials =
          await FirebaseAuth.instance.signInWithCredential(credential);
      _saveUsernameInStorage(credentials.user);
      _storageService.setKeyValue<String>(
          emailKey, credentials.user?.email ?? 'no-email');
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

          final credentials = await FirebaseAuth.instance
              .signInWithCredential(twitterAuthCredential);

          _saveUsernameInStorage(credentials.user);
          _storageService.setKeyValue<String>(
              emailKey, credentials.user?.email ?? 'no-email');
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
  Future<bool> register(String email, String password) async {
    try {
      //check if account exists
      final accountExists = await checkAccountExists(email);

      if (accountExists) {
        return true;
      }

      // Crear cuenta de usuario con Firebase Auth
      UserCredential _ = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _hasLoggedWithEmailPassword = true;
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
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

  @override
  Future<bool> checkAccountExists(String email) async {
    try {
      final methods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
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

  void _saveUsernameInStorage(User? user) {
    final String? name = user?.displayName?.split(' ')[0];
    final String? lastname = user?.displayName?.split(' ')[1];
    //guardamos el nombre y apellido en el storage
    _storageService.setKeyValue<String>(nameKey, name ?? '');
    _storageService.setKeyValue<String>(lastnameKey, lastname ?? '');
  }

  Future<void> checkBiometricSupport() async {
    _availableBiometrics = await _localAuth.getAvailableBiometrics();
    final canCheckBiometrics = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    _hasBiometricSupport = availableBiometrics.isNotEmpty &&
        canCheckBiometrics &&
        isDeviceSupported;
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
