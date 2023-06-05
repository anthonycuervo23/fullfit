import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fullfit_app/domain/entities/entities.dart';

class PersonMapper {
  static Person firestoreUserToEntity(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Person(
      id: doc.id,
      name: data?['name'] ?? '--',
      lastname: data?['last_name'] ?? '--',
      ageRange: data?['age_range'] ?? '--',
      height: int.tryParse(data?['height'].toString() ?? '0') ?? 0,
      weight: int.tryParse(data?['weight'].toString() ?? '0') ?? 0,
      email: data?['email'] ?? '--',
      gender: data?['gender'] ?? '--',
      profilePic: data?['photo_URL'] ?? '--',
      trainingSpot: data?['training_ spot'] ?? '--',
      fitnessLevel: data?['fitness_level'] ?? '--',
      fitnessGoal: (data?['fitness_goal'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
    );
  }
}
