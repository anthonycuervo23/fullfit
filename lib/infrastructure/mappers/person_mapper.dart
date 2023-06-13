import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/domain/enums/enums.dart';

class PersonMapper {
  static Person firestoreUserToEntity(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Person(
      id: doc.id,
      name: data?['name'] ?? '--',
      lastname: data?['last_name'] ?? '--',
      ageRange: stringToAgeRange(data?['age_range'] ?? '--'),
      height: int.tryParse(data?['height'].toString() ?? '0') ?? 0,
      weight: int.tryParse(data?['weight'].toString() ?? '0') ?? 0,
      email: data?['email'] ?? '--',
      gender: stringToGender(data?['gender'] ?? '--'),
      profilePic: data?['photo_URL'] ?? '--',
      trainingSpot: stringToTrainingSpot(data?['training_ spot'] ?? '--'),
      fitnessLevel: stringToFitnessLevel(data?['fitness_level'] ?? '--'),
      targetCalories:
          double.tryParse(data?['target_calories'].toString() ?? '0') ?? 0,
      targetProtein:
          double.tryParse(data?['target_protein'].toString() ?? '0') ?? 0,
      targetFat: double.tryParse(data?['target_fat'].toString() ?? '0') ?? 0,
      targetCarbs:
          double.tryParse(data?['target_carbs'].toString() ?? '0') ?? 0,
      fitnessGoal: stringListToFitnessGoalList(data?['fitness_goal'] ?? []),
    );
  }

  static Person fromMap(Map<String, dynamic> map, {required String id}) {
    return Person(
      id: id,
      name: map['name'],
      lastname: map['lastname'],
      email: map['email'],
      profilePic: map['photo_URL'],
      weight: map['weight'],
      height: map['height'],
      targetCalories: double.tryParse(map['target_calories'].toString()) ?? 0,
      targetProtein: double.tryParse(map['target_protein'].toString()) ?? 0,
      targetFat: double.tryParse(map['target_fat'].toString()) ?? 0,
      targetCarbs: double.tryParse(map['target_carbs'].toString()) ?? 0,
      gender: stringToGender(map['gender']),
      trainingSpot: stringToTrainingSpot(map['training_spot']),
      ageRange: stringToAgeRange(map['age_range']),
      fitnessLevel: stringToFitnessLevel(map['fitness_level']),
      fitnessGoal: stringListToFitnessGoalList(map['fitness_goal']),
    );
  }
}
