import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:fullfit_app/config/extensions/string_extensions.dart';
import 'package:fullfit_app/domain/repositories/repositories.dart';
import 'package:fullfit_app/presentation/inputs/inputs.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

//PROVIDER
final onBoardingNotifierProvider =
    StateNotifierProvider.autoDispose<OnBoardingNotifier, OnBoardingState>(
        (ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return OnBoardingNotifier(authRepository: authRepository);
});

//NOTIFIER
class OnBoardingNotifier extends StateNotifier<OnBoardingState> {
  final AuthRepository _authRepository;
  OnBoardingNotifier({required authRepository})
      : _authRepository = authRepository,
        super(OnBoardingState());

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);

    state = state.copyWith(
      email: newEmail,
      isEmailValid: Formz.validate([newEmail]),
    );
  }

  Future<bool> emailAlreadyExists() async {
    state = state.copyWith(checkingEmail: true, errorMessage: '');
    bool exists = await _authRepository.checkAccountExists(state.email.value);
    if (exists) {
      state = state.copyWith(
          errorMessage: 'La cuenta ya existe!', checkingEmail: false);
      return true;
    }
    state = state.copyWith(checkingEmail: false);
    return false;
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);

    state = state.copyWith(
      password: newPassword,
      isPasswordValid: Formz.validate([newPassword]),
    );
  }

  onFirstNameChanged(String value) {
    final newName = Name.dirty(value);

    state = state.copyWith(
      firstName: newName,
      isFirstNameValid: Formz.validate([newName]),
    );
  }

  onLastNameChanged(String value) {
    final newLastName = Name.dirty(value);

    state = state.copyWith(
      lastName: newLastName,
      isLastNameValid: Formz.validate([newLastName]),
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
    state = state.copyWith(
        gender: gender,
        ageRanges: gender == 'Mujer'
            ? const [
                AgeRange('18-24', 'assets/images/female_18.png'),
                AgeRange('25-34', 'assets/images/female_25.png'),
                AgeRange('35-54', 'assets/images/female_35.png'),
                AgeRange('55+', 'assets/images/female_55.png'),
              ]
            : const [
                AgeRange('18-24', 'assets/images/male_18.png'),
                AgeRange('25-34', 'assets/images/male_25.png'),
                AgeRange('35-54', 'assets/images/male_35.png'),
                AgeRange('55+', 'assets/images/male_55.png'),
              ]);

    // state = state.copyWith(gender: gender);
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

  onHeightChanged(int value) {
    state = state.copyWith(height: value);
  }

  onWeightChanged(int value) {
    state = state.copyWith(weight: value);
  }

  onTrainingSpotChanged(String value) {
    state = state.copyWith(selectedSpot: value);
  }

  onAgeRangeChanged(String value) {
    state = state.copyWith(ageRange: value);
  }
}

//STATE
class OnBoardingState {
  final bool checkingEmail;
  final bool isPosting;
  final bool isFormValid;
  final bool isEmailValid;
  final bool isPasswordValid;
  final String errorMessage;
  final Email email;
  final Password password;
  final Name firstName;
  final Name lastName;
  final bool isFirstNameValid;
  final bool isLastNameValid;
  final String profilePic;
  final FitnessLevel fitnessLevel;
  final Map<String, bool> fitnessGoals;
  final String gender;
  final List<Gender> genders;
  final String ageRange;
  final List<AgeRange> ageRanges;
  final int genderSelected;
  final int height;
  final int weight;
  final List<String> trainingSpots;
  final String selectedSpot;

  OnBoardingState({
    this.checkingEmail = false,
    this.isPosting = false,
    this.isFormValid = false,
    this.isEmailValid = false,
    this.isPasswordValid = false,
    this.isFirstNameValid = false,
    this.isLastNameValid = false,
    this.errorMessage = '',
    this.firstName = const Name.pure(),
    this.lastName = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.gender = 'Masculino',
    this.ageRange = '',
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
    this.height = 170,
    this.weight = 70,
    this.genderSelected = 0,
    this.ageRanges = const [
      AgeRange('18-24', 'assets/images/male_18.png'),
      AgeRange('25-34', 'assets/images/male_25.png'),
      AgeRange('35-54', 'assets/images/male_35.png'),
      AgeRange('55+', 'assets/images/male_55.png'),
    ],
    this.genders = const [
      Gender('Male', 'assets/images/male.png'),
      Gender('Female', 'assets/images/female.png'),
    ],
    this.trainingSpots = const [
      'Gimnasio',
      'Casa',
      'Parque',
    ],
    this.selectedSpot = 'Gimnasio',
  });

  OnBoardingState copyWith({
    bool? isPosting,
    bool? checkingEmail,
    bool? isFormValid,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isFirstNameValid,
    bool? isLastNameValid,
    Name? firstName,
    Name? lastName,
    Email? email,
    Password? password,
    String? errorMessage,
    String? profilePic,
    FitnessLevel? fitnessLevel,
    Map<String, bool>? fitnessGoals,
    String? gender,
    List<Gender>? genders,
    String? ageRange,
    List<AgeRange>? ageRanges,
    int? genderSelected,
    int? height,
    int? weight,
    List<String>? trainingSpots,
    String? selectedSpot,
  }) {
    return OnBoardingState(
      checkingEmail: checkingEmail ?? this.checkingEmail,
      isPosting: isPosting ?? this.isPosting,
      isFormValid: isFormValid ?? this.isFormValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isFirstNameValid: isFirstNameValid ?? this.isFirstNameValid,
      isLastNameValid: isLastNameValid ?? this.isLastNameValid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
      profilePic: profilePic ?? this.profilePic,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      fitnessGoals: fitnessGoals ?? this.fitnessGoals,
      gender: gender ?? this.gender,
      genders: genders ?? this.genders,
      ageRange: ageRange ?? this.ageRange,
      ageRanges: ageRanges ?? this.ageRanges,
      genderSelected: genderSelected ?? this.genderSelected,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      trainingSpots: trainingSpots ?? this.trainingSpots,
      selectedSpot: selectedSpot ?? this.selectedSpot,
    );
  }
}

//* Modelos personalizados
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

class AgeRange {
  final String range;
  final String image;

  const AgeRange(this.range, this.image);
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
