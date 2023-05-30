import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/repositories/auth_repository.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

//PROVIDER
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userNotifier = ref.watch(userProvider.notifier);

  return AuthNotifier(
    authRepository: authRepository,
    userNotifier: userNotifier,
  );
});

//NOTIFIER
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final PersonNotifier _userNotifier;
  AuthNotifier(
      {required AuthRepository authRepository,
      required PersonNotifier userNotifier})
      : _authRepository = authRepository,
        _userNotifier = userNotifier,
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
      throw Exception('Error al obtener el usuario logueado');
    }
  }

  Future<void> loginWithEmailPassword(String email, String password) async {
    await _authRepository.performLoginWithEmailPassword(email, password,
        (success) async {
      if (success) {
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
  }

  Future<void> loginWithBiometrics(Function(bool success) closure) async {
    try {
      await _authRepository.performBiometricLogin();
      await _userNotifier.setUser();
      closure(true);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'No se ha podido iniciar sesión',
      );
      closure(false);
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
