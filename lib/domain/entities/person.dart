import 'package:fullfit_app/config/extensions/string_extensions.dart';
import 'package:fullfit_app/domain/enums/enums.dart';

class Person {
  final String id;
  final String name;
  final String lastname;
  final int weight;
  final int height;
  final Gender gender;
  final String email;
  final String profilePic;
  final TrainingSpot trainingSpot;
  final AgeRange ageRange;
  final FitnessLevel fitnessLevel;
  final List<FitnessGoal> fitnessGoal;
  final double targetCalories;
  final double targetProtein;
  final double targetFat;
  final double targetCarbs;

  Person({
    required this.trainingSpot,
    required this.ageRange,
    required this.fitnessLevel,
    required this.fitnessGoal,
    required this.id,
    required this.gender,
    required this.email,
    required this.profilePic,
    required this.name,
    required this.lastname,
    required this.weight,
    required this.height,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetFat,
    required this.targetCarbs,
  });

  get fullName => '${name.capitalize()} ${lastname.capitalize()}';
}
