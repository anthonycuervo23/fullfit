import 'package:fullfit_app/config/extensions/string_extensions.dart';

class Person {
  final String id;
  final String name;
  final String lastname;
  final int weight;
  final int height;
  final String gender;
  final String email;
  final String profilePic;
  final String trainingSpot;
  final String ageRange;
  final String fitnessLevel;
  final List<String> fitnessGoal;

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
  });

  get fullName => '${name.capitalize()} ${lastname.capitalize()}';
}
