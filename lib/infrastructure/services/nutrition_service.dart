import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/domain/enums/enums.dart';

class NutritionService {
  Person person;

  NutritionService({required this.person});

  double calculateAverageAge(AgeRange ageRange) {
    switch (ageRange) {
      case AgeRange.range18_24:
        return (18 + 24) / 2;
      case AgeRange.range25_34:
        return (25 + 34) / 2;
      case AgeRange.range35_54:
        return (35 + 54) / 2;
      case AgeRange.range55:
        return 60; // un estimado para 55+
      default:
        return 0;
    }
  }

  double calculateDailyCaloricIntake() {
    double bmr;
    double age = calculateAverageAge(person.ageRange);

    if (person.gender == Gender.male) {
      bmr = 66.5 +
          (13.75 * person.weight) +
          (5.003 * person.height) -
          (6.755 * age);
    } else {
      bmr = 655 +
          (9.563 * person.weight) +
          (1.850 * person.height) -
          (4.676 * age);
    }

    double tdee;

    switch (person.fitnessLevel) {
      case FitnessLevel.veryLow:
        tdee = bmr * 1.2;
        break;
      case FitnessLevel.low:
        tdee = bmr * 1.375;
        break;
      case FitnessLevel.moderate:
        tdee = bmr * 1.55;
        break;
      case FitnessLevel.good:
        tdee = bmr * 1.725;
        break;
      case FitnessLevel.veryGood:
        tdee = bmr * 1.9;
        break;
      case FitnessLevel.excellent:
        tdee = bmr * 2.0;
      default:
        tdee = bmr * 1.2;
    }

    switch (person.fitnessGoal.first) {
      case FitnessGoal.loseWeight:
        tdee -= 500;
        break;
      case FitnessGoal.gainMuscle:
        tdee += 500;
        break;
      case FitnessGoal.improveBodyComposition:
        tdee += 250;
        break;
      case FitnessGoal.increaseDefinitionMuscle:
        tdee += 250;
        break;
      default:
        break;
    }

    return tdee;
  }

  double calculateProteinIntake() {
    return person.weight *
        2.2 *
        0.8; // 0.8 grams of protein per pound of body weight
  }

  double calculateFatIntake() {
    return calculateDailyCaloricIntake() *
        0.25 /
        9; // 25% of daily calories from fat, divided by 9 to convert to grams
  }

  double calculateCarbIntake() {
    double proteinCalories = calculateProteinIntake() * 4;
    double fatCalories = calculateFatIntake() * 9;
    return (calculateDailyCaloricIntake() - proteinCalories - fatCalories) /
        4; // remaining calories should be from carbs
  }
}
