import 'package:formz/formz.dart';

enum NameValidationError { invalid, tooShort, tooLong }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty(String value) : super.dirty(value);

  static final _firstNameRegExp = RegExp(r'^[a-zA-Z]+$');

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == NameValidationError.invalid) {
      return 'No tiene un formato correcto';
    }
    if (displayError == NameValidationError.tooLong) {
      return 'Debe tener menos de 20 caracteres';
    }
    if (displayError == NameValidationError.tooShort) {
      return 'Debe tener más de 3 caracteres';
    }

    return null;
  }

  @override
  NameValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return NameValidationError.tooShort;
    }
    if (value.length > 20) {
      return NameValidationError.tooLong;
    }
    if (value.length < 3) {
      return NameValidationError.tooShort;
    }
    return _firstNameRegExp.hasMatch(value)
        ? null
        : NameValidationError.invalid;
  }
}
