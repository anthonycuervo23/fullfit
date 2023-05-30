import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/config/extensions/string_extensions.dart';
import 'package:fullfit_app/domain/repositories/auth_repository.dart';
import 'package:fullfit_app/infrastructure/services/services.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

//PROVIDER
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userNotifier = ref.watch(userProvider.notifier);
  final storageService = ref.watch(keyValueStorageProvider);
  return AuthNotifier(
    authRepository: authRepository,
    userNotifier: userNotifier,
    storageService: storageService,
  );
});

//NOTIFIER
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final PersonNotifier _userNotifier;
  final KeyValueStorageService _storageService;
  AuthNotifier(
      {required AuthRepository authRepository,
      required PersonNotifier userNotifier,
      required KeyValueStorageService storageService})
      : _authRepository = authRepository,
        _userNotifier = userNotifier,
        _storageService = storageService,
        super(AuthState()) {
    Future.microtask(() => checkIfUserIsLoggedIn());
  }

  Future<void> checkIfUserIsLoggedIn() async {
    try {
      if (_authRepository.isUserLogged) {
        await _userNotifier.setUser();
        state = state.copyWith(
          status: AuthStatus.authenticated,
          errorMessage: '',
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'No se ha podio iniciar sesión',
        );
      }
    } catch (e) {
      await _authRepository.performLogout();
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Error al obtener el usuario logueado',
      );
    }
  }

  Future<void> loginWithEmailPassword(String email, String password) async {
    CustomLoader.show();
    await _authRepository.performLoginWithEmailPassword(email, password,
        (success) async {
      if (success) {
        _storageService.setKeyValue(loginTypeKey, 'email');
        await _userNotifier.setUser();
        state = state.copyWith(
          status: AuthStatus.checkBiometric,
          errorMessage: '',
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Email o contraseña incorrectos',
        );
      }
    });
    CustomLoader.dismiss();
  }

  Future<void> loginWithBiometrics(Function(bool success) closure) async {
    try {
      CustomLoader.show();

      await _authRepository.performBiometricLogin();
      await _userNotifier.setUser();
      closure(true);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'No se ha podido iniciar sesión con biometría',
      );
      closure(false);
    }

    CustomLoader.dismiss();
  }

  Future<void> loginWithProvider(LoginType provider) async {
    CustomLoader.show();
    switch (provider) {
      case LoginType.google:
        await _authRepository.performLoginWithGoogle((success) async {
          await _handleLoginWithProvider(success, provider);
        });
        break;
      case LoginType.twitter:
        await _authRepository.performLoginWithTwitter((success) async {
          await _handleLoginWithProvider(success, provider);
        });
        break;
      case LoginType.apple:
        await _authRepository.performLoginWithApple((success) async {
          await _handleLoginWithProvider(success, provider);
        });
        break;
      default:
        break;
    }
    CustomLoader.dismiss();
  }

  Future<void> _handleLoginWithProvider(
      bool success, LoginType provider) async {
    if (success) {
      _storageService.setKeyValue<String>(loginTypeKey, provider.name);
      await _userNotifier.setUser();
      state = state.copyWith(
        status: AuthStatus.authenticated,
        errorMessage: '',
      );
    } else {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage:
            'No se ha podido iniciar sesión con ${provider.name.capitalize()}',
      );
    }
  }

  Future<void> authenticateUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      status: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout() async {
    await _authRepository.performLogout();
    _userNotifier.clearUser();
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      errorMessage: '',
    );
  }
}

//STATE
enum AuthStatus { checking, authenticated, unauthenticated, checkBiometric }

enum LoginType { apple, twitter, google }

class AuthState {
  final AuthStatus status;
  final String errorMessage;

  AuthState({
    this.status = AuthStatus.checking,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
  }) =>
      AuthState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
