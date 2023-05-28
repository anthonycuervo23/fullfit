import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/domain/repositories/auth_repository.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

//PROVIDER
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository: authRepository);
});

//NOTIFIER
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  AuthNotifier({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState()) {
    checkIfUserIsLoggedIn();
  }

  Future<void> checkIfUserIsLoggedIn() async {
    try {
      final bool isLoggedIn = _authRepository.isUserLoggedIn();
      if (isLoggedIn) {
        final Person person = await _authRepository.getLoggedInUser();
        state = state.copyWith(
          status: AuthStatus.authenticated,
          errorMessage: '',
          person: person,
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
    try {
      final Person person =
          await _authRepository.loginWithEmailPassword(email, password);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        errorMessage: '',
        person: person,
      );
    } catch (e) {
      debugPrint(e.toString());
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'No se ha podio iniciar sesión',
      );
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      errorMessage: '',
      person: null,
    );
  }
}

//STATE
enum AuthStatus { checking, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final Person? person;
  final String errorMessage;

  AuthState({
    this.status = AuthStatus.checking,
    this.person,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? status,
    Person? person,
    String? errorMessage,
  }) =>
      AuthState(
        status: status ?? this.status,
        person: person ?? this.person,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
