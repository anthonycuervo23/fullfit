import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
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
  //TODO: add more inputs (name, lastname, age, weight, height, etc)

  OnBoardingState({
    this.isPosting = false,
    this.isFormValid = false,
    this.isEmailValid = false,
    this.isPasswordValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.profilePic = 'assets/avatars/avatar1.png',
  });

  OnBoardingState copyWith({
    bool? isPosting,
    bool? isFormValid,
    bool? isEmailValid,
    bool? isPasswordValid,
    Email? email,
    Password? password,
    String? profilePic,
  }) {
    return OnBoardingState(
      isPosting: isPosting ?? this.isPosting,
      isFormValid: isFormValid ?? this.isFormValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      email: email ?? this.email,
      password: password ?? this.password,
      profilePic: profilePic ?? this.profilePic,
    );
  }
}
