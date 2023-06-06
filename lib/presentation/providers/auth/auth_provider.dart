import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/config/extensions/string_extensions.dart';
import 'package:fullfit_app/domain/repositories/repositories.dart';
import 'package:fullfit_app/infrastructure/services/services.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

//PROVIDER
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userNotifier = ref.watch(personProvider.notifier);
  final storageService = ref.watch(keyValueStorageProvider);
  final personRepository = ref.watch(personRepositoryProvider);
  return AuthNotifier(
    authRepository: authRepository,
    userNotifier: userNotifier,
    storageService: storageService,
    personRepository: personRepository,
  );
});

//NOTIFIER
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final PersonNotifier _userNotifier;
  final KeyValueStorageService _storageService;
  final PersonRepository _personRepository;
  AuthNotifier(
      {required AuthRepository authRepository,
      required PersonNotifier userNotifier,
      required PersonRepository personRepository,
      required KeyValueStorageService storageService})
      : _authRepository = authRepository,
        _userNotifier = userNotifier,
        _personRepository = personRepository,
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
        try {
          _storageService.setKeyValue(loginTypeKey, 'email');
          await _userNotifier.setUser();
          state = state.copyWith(
            status: AuthStatus.checkBiometric,
            errorMessage: '',
          );
        } catch (e) {
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            errorMessage:
                'No se ha podido iniciar sesión con email y contraseña',
          );
        }
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
      //si el usuario se logea correctamente, debemos verificar si existe docuemnto en la coleccion de usuarios
      //si no existe, debemos dirigirlo a la pantalla de onboarding para que complete su registro y luego autenticarlo
      bool exists = await _personRepository.checkUserDocumentExists();

      //si existe seteamos el usuario y lo autenticamos
      if (exists) {
        await _userNotifier.setUser();
        state = state.copyWith(
          status: AuthStatus.authenticated,
          errorMessage: '',
        );
        return;
      }

      //si no existe lo redirigimos a la pantalla de onboarding y creamos el documento
      state = state.copyWith(
        status: AuthStatus.missingData,
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

  Future<void> registerUser(
      String email, String password, Map<String, dynamic> personLike) async {
    CustomLoader.show();

    bool success = await _authRepository.register(email, password);

    if (success) {
      //guardar data en firestore
      try {
        await _personRepository.saveUserData(personLike);
        await _userNotifier.setUser();
        CustomLoader.dismiss();
        state = state.copyWith(
          status: AuthStatus.readyToGo,
          errorMessage: '',
        );
      } catch (e) {
        CustomLoader.dismiss();
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'No se ha podido conpletar el proceso de registro',
        );
      }
    } else {
      CustomLoader.dismiss();
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'No se ha podido conpletar el proceso de registro',
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
enum AuthStatus {
  checking,
  authenticated,
  unauthenticated,
  checkBiometric,
  missingData,
  readyToGo,
}

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
