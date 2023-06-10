enum Gender { male, female }

extension GenderExtension on Gender {
  String get name {
    switch (this) {
      case Gender.male:
        return 'Hombre';
      case Gender.female:
        return 'Mujer';
      default:
        return 'Hombre';
    }
  }

  String get image {
    switch (this) {
      case Gender.male:
        return 'assets/images/male.png';
      case Gender.female:
        return 'assets/images/female.png';
      default:
        return 'assets/images/male.png';
    }
  }
}

Gender stringToGender(String input) => Gender.values.firstWhere(
      (element) => element.name == input,
      orElse: () => Gender.male,
    );
