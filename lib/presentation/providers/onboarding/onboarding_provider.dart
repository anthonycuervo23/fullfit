import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:fullfit_app/config/extensions/string_extensions.dart';
import 'package:fullfit_app/presentation/inputs/inputs.dart';

//PROVIDER
final onBoardingNotifierProvider =
    StateNotifierProvider.autoDispose<OnBoardingNotifier, OnBoardingState>(
        (ref) {
  return OnBoardingNotifier();
});

//NOTIFIER
class OnBoardingNotifier extends StateNotifier<OnBoardingState> {
  OnBoardingNotifier() : super(OnBoardingState());

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);

    state = state.copyWith(
      email: newEmail,
      isEmailValid: Formz.validate([newEmail]),
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);

    state = state.copyWith(
      password: newPassword,
      isPasswordValid: Formz.validate([newPassword]),
    );
  }

  onProfilePicChanged(String value) {
    state = state.copyWith(
      profilePic: value,
    );
  }

  onFitnessLevelChanged(double position) {
    final fitnessLevel = _getFitnessLevel(position);
    state = state.copyWith(
      fitnessLevel: fitnessLevel,
    );
  }

  onFitnessGoalChanged(String goal, bool value) {
    // Crear un nuevo mapa y reemplazar el mapa anterior
    final newFitnessGoals = Map<String, bool>.from(state.fitnessGoals);
    newFitnessGoals[goal] = value;
    state = state.copyWith(fitnessGoals: newFitnessGoals);
  }

  _onGenderChanged(String value) {
    final gender = value.translate();
    state = state.copyWith(gender: gender);
  }

  onGenderSelected(String gender) {
    if (gender == 'Male') {
      state.genderSelected != 1
          ? state = state.copyWith(genderSelected: 1)
          : state = state.copyWith(genderSelected: 0);
    } else {
      state.genderSelected != 2
          ? state = state.copyWith(genderSelected: 2)
          : state = state.copyWith(genderSelected: 0);
    }

    _onGenderChanged(gender);
  }
}

//STATE
class OnBoardingState {
  final bool isPosting;
  final bool isFormValid;
  final bool isEmailValid;
  final bool isPasswordValid;
  final Email email;
  final Password password;
  final String profilePic;
  final FitnessLevel fitnessLevel;
  final Map<String, bool> fitnessGoals;
  final String gender;
  final List<Gender> genders;
  final int genderSelected;
  //TODO: missing inputs (name, lastname, age, weight, height, trainingSpot)

  OnBoardingState(
      {this.isPosting = false,
      this.isFormValid = false,
      this.isEmailValid = false,
      this.isPasswordValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.gender = 'Masculino',
      this.profilePic = 'assets/avatars/avatar1.png',
      this.fitnessLevel = const FitnessLevel(
          level: 'Average',
          title: 'Intensidad Media',
          description: 'Realizo alguna forma de ejercicio regularmente.'),
      this.fitnessGoals = const {
        'Perder peso': false,
        'Mejorar la composición corporal': false,
        'Ganar músculo': false,
        'Aumentar la definición muscular': false
      },
      this.genderSelected = 0,
      this.genders = const [
        Gender('Male', 'assets/images/male.png'),
        Gender('Female', 'assets/images/female.png'),
      ]});

  OnBoardingState copyWith({
    bool? isPosting,
    bool? isFormValid,
    bool? isEmailValid,
    bool? isPasswordValid,
    Email? email,
    Password? password,
    String? profilePic,
    FitnessLevel? fitnessLevel,
    Map<String, bool>? fitnessGoals,
    String? gender,
    List<Gender>? genders,
    int? genderSelected,
  }) {
    return OnBoardingState(
      isPosting: isPosting ?? this.isPosting,
      isFormValid: isFormValid ?? this.isFormValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      email: email ?? this.email,
      password: password ?? this.password,
      profilePic: profilePic ?? this.profilePic,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      fitnessGoals: fitnessGoals ?? this.fitnessGoals,
      gender: gender ?? this.gender,
      genders: genders ?? this.genders,
      genderSelected: genderSelected ?? this.genderSelected,
    );
  }
}

class FitnessLevel {
  final String level;
  final String title;
  final String description;

  const FitnessLevel(
      {required this.level, required this.title, required this.description});
}

class Gender {
  final String title;
  final String image;

  const Gender(this.title, this.image);
}

//* Metodos helpers
extension OnBoardingNotifierExtension on OnBoardingNotifier {
// muy baja, baja, moderada, buena, muy buena, excelente
  FitnessLevel _getFitnessLevel(double position) {
    if (position >= 40 && position < 93) {
      return const FitnessLevel(
          level: 'Muy Baja',
          title: 'Intensidad Muy Baja',
          description: 'Raramente hago ejercicio o actividad física.');
    } else if (position >= 93 && position < 146) {
      return const FitnessLevel(
          level: 'Baja',
          title: 'Intensidad Baja',
          description: 'Ocasionalmente hago ejercicios ligeros.');
    } else if (position >= 146 && position < 199) {
      return const FitnessLevel(
          level: 'Moderada',
          title: 'Intensidad Media',
          description: 'Realizo alguna forma de ejercicio regularmente.');
    } else if (position >= 199 && position < 252) {
      return const FitnessLevel(
          level: 'Buena',
          title: 'Buena Intensidad',
          description: 'Hago ejercicio frecuentemente e intensivamente.');
    } else if (position >= 252 && position < 305) {
      return const FitnessLevel(
          level: 'Muy Buena',
          title: 'Muy Buena Intensidad',
          description:
              'Participo en ejercicios o deportes de alta intensidad.');
    } else if (position >= 305 && position <= 360) {
      return const FitnessLevel(
          level: 'Excelente',
          title: 'Excelente Intensidad',
          description:
              'Participo regularmente en deportes competitivos y ejercicios de alta intensidad.');
    } else {
      return const FitnessLevel(
          level: 'N/A',
          title: 'Intensidad Desconocida',
          description: 'Nivel fitness desconocido.');
    }
  }
}
