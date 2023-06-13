import 'package:fullfit_app/domain/enums/enums.dart';

enum AgeRange { range18_24, range25_34, range35_54, range55 }

extension AgeRangeExtension on AgeRange {
  String get range {
    switch (this) {
      case AgeRange.range18_24:
        return '18-24';
      case AgeRange.range25_34:
        return '25-34';
      case AgeRange.range35_54:
        return '35-54';
      case AgeRange.range55:
        return '55+';
      default:
        return '';
    }
  }

  String get imageFemale {
    switch (this) {
      case AgeRange.range18_24:
        return 'assets/images/female_18.png';
      case AgeRange.range25_34:
        return 'assets/images/female_25.png';
      case AgeRange.range35_54:
        return 'assets/images/female_35.png';
      case AgeRange.range55:
        return 'assets/images/female_55.png';
      default:
        return '';
    }
  }

  String get imageMale {
    switch (this) {
      case AgeRange.range18_24:
        return 'assets/images/male_18.png';
      case AgeRange.range25_34:
        return 'assets/images/male_25.png';
      case AgeRange.range35_54:
        return 'assets/images/male_35.png';
      case AgeRange.range55:
        return 'assets/images/male_55.png';
      default:
        return '';
    }
  }

  String getAssethPath(Gender gender) {
    switch (gender) {
      case Gender.male:
        return imageMale;
      case Gender.female:
        return imageFemale;
      default:
        return imageMale;
    }
  }
}

AgeRange stringToAgeRange(String input) => AgeRange.values.firstWhere(
      (element) => element.name == input,
      orElse: () => AgeRange.range18_24,
    );
