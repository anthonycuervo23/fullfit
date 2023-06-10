import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:fullfit_app/domain/enums/enums.dart';
import 'package:fullfit_app/domain/repositories/repositories.dart';
import 'package:fullfit_app/infrastructure/services/key_value_storage_service.dart';
import 'package:fullfit_app/presentation/inputs/inputs.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

//PROVIDER
final onBoardingNotifierProvider =
    StateNotifierProvider.autoDispose<OnBoardingNotifier, OnBoardingState>(
        (ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;
  final String? email =
      ref.watch(keyValueStorageProvider).getValue<String>(emailKey);
  final String? loginType =
      ref.watch(keyValueStorageProvider).getValue<String>(loginTypeKey);
  return OnBoardingNotifier(
      authRepository: authRepository,
      registerUserCallback: registerUserCallback,
      loginType: loginType,
      loginEmail: email);
});

//NOTIFIER
class OnBoardingNotifier extends StateNotifier<OnBoardingState> {
  final AuthRepository _authRepository;
  final String? _loginEmail;
  final String? _loginType;
  final Future<void> Function(
    String email,
    String password,
    Map<String, dynamic> personLike,
  ) _registerUserCallback;
  OnBoardingNotifier({
    required authRepository,
    required registerUserCallback,
    required loginEmail,
    required loginType,
  })  : _authRepository = authRepository,
        _registerUserCallback = registerUserCallback,
        _loginEmail = loginEmail,
        _loginType = loginType,
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

  validateInitialValues(String? name, String? lastName) {
    final newName = Name.dirty(name ?? '');
    final newLastName = Name.dirty(lastName ?? '');

    state = state.copyWith(
      firstName: newName,
      isFirstNameValid: Formz.validate([newName]),
      lastName: newLastName,
      isLastNameValid: Formz.validate([newLastName]),
    );
  }

  onFitnessLevelChanged(double position) {
    final fitnessLevel = _getFitnessLevel(position);
    state = state.copyWith(
      fitnessLevel: fitnessLevel,
    );
  }

  onFitnessGoalChanged(FitnessGoal goal, bool value) {
    // Crear un nuevo mapa y reemplazar el mapa anterior
    final newFitnessGoals = Map<FitnessGoal, bool>.from(state.fitnessGoals);
    newFitnessGoals[goal] = value;
    state = state.copyWith(fitnessGoals: newFitnessGoals);
  }

  _onGenderChanged(String value) {
    Gender genderEnum = stringToGender(value);

    state = state.copyWith(gender: genderEnum, ageRanges: [
      AgeRange.range18_24,
      AgeRange.range25_34,
      AgeRange.range35_54,
      AgeRange.range55,
    ]);

    // state = state.copyWith(gender: gender);
  }

  onGenderSelected(String gender) {
    Gender genderEnum = stringToGender(gender);
    if (genderEnum == Gender.male) {
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

  onTrainingSpotChanged(TrainingSpot value) {
    state = state.copyWith(selectedSpot: value);
  }

  onAgeRangeChanged(AgeRange value) {
    state = state.copyWith(ageRange: value);
  }

//TODO: calcular los targets nutricionales.

  Future<void> onFormSubmitted() async {
    final Map<String, dynamic> personLike = {
      'name': state.firstName.value,
      'login_type': _loginType ?? 'email',
      'lastname': state.lastName.value,
      'email': state.email.value.isEmpty ? _loginEmail : state.email.value,
      'weight': state.weight,
      'height': state.height,
      'gender': state.gender.name,
      'photo_URL': state.profilePic,
      'training_spot': state.selectedSpot.spot,
      'age_range': state.ageRange.range,
      'fitness_level': state.fitnessLevel.level,
      'fitness_goal': state.fitnessGoals.entries
          .where((entry) => entry.value == true)
          .map((entry) => entry.key.goal)
          .toList(),
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
      'last_login': FieldValue.serverTimestamp(),
      'target_calories': 2000,
      'target_protein': 200,
      'target_fat': 200,
      'target_carbs': 200,
    };

    state = state.copyWith(isPosting: true);

//si no tenemos un email es porque venimos de login con google o twitter
    await _registerUserCallback(
      state.email.value.isEmpty ? _loginEmail ?? '' : state.email.value,
      state.password.value,
      personLike,
    );

    state = state.copyWith(isPosting: false);
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
  final Map<FitnessGoal, bool> fitnessGoals;
  final Gender gender;
  final List<Gender> genders;
  final AgeRange ageRange;
  final List<AgeRange> ageRanges;
  final int genderSelected;
  final int height;
  final int weight;
  final List<TrainingSpot> trainingSpots;
  final TrainingSpot selectedSpot;

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
    this.gender = Gender.male,
    this.ageRange = AgeRange.range18_24,
    this.profilePic = 'assets/avatars/avatar1.png',
    this.fitnessLevel = FitnessLevel.moderate,
    this.fitnessGoals = const {
      FitnessGoal.loseWeight: false,
      FitnessGoal.improveBodyComposition: false,
      FitnessGoal.gainMuscle: false,
      FitnessGoal.increaseDefinitionMuscle: false
    },
    this.height = 170,
    this.weight = 70,
    this.genderSelected = 0,
    this.ageRanges = const [
      AgeRange.range18_24,
      AgeRange.range25_34,
      AgeRange.range35_54,
      AgeRange.range55,
    ],
    this.genders = const [
      Gender.male,
      Gender.female,
    ],
    this.trainingSpots = const [
      TrainingSpot.gym,
      TrainingSpot.home,
      TrainingSpot.outdoor,
    ],
    this.selectedSpot = TrainingSpot.gym,
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
    Map<FitnessGoal, bool>? fitnessGoals,
    Gender? gender,
    List<Gender>? genders,
    AgeRange? ageRange,
    List<AgeRange>? ageRanges,
    int? genderSelected,
    int? height,
    int? weight,
    List<TrainingSpot>? trainingSpots,
    TrainingSpot? selectedSpot,
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

//* Metodos helpers
extension OnBoardingNotifierExtension on OnBoardingNotifier {
// muy baja, baja, moderada, buena, muy buena, excelente
  FitnessLevel _getFitnessLevel(double position) {
    if (position >= 40 && position < 93) {
      return FitnessLevel.veryLow;
    } else if (position >= 93 && position < 146) {
      return FitnessLevel.low;
    } else if (position >= 146 && position < 199) {
      return FitnessLevel.moderate;
    } else if (position >= 199 && position < 252) {
      return FitnessLevel.good;
    } else if (position >= 252 && position < 305) {
      return FitnessLevel.veryGood;
    } else if (position >= 305 && position <= 360) {
      return FitnessLevel.excellent;
    } else {
      return FitnessLevel.moderate;
    }
  }
}
