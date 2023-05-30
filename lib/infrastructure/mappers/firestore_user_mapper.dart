import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fullfit_app/domain/entities/entities.dart';

class PersonMapper {
  static Person firestoreUserToEntity(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Person(
      id: doc.id,
      name: data?['name'] ?? '--',
      lastname: data?['lastname'] ?? '--',
      age: data?['age'] ?? 0,
      height: double.tryParse(data?['height'].toString() ?? '0') ?? 0.0,
      weight: double.tryParse(data?['weight'].toString() ?? '0') ?? 0.0,
      email: data?['email'] ?? '--',
      gender: data?['gender'] ?? '--',
      profilePic: data?['photoURL'] ?? '--',
    );
  }

  // static Map<String, dynamic> toFirestore(Person person) {
  //   return {
  //     'name': person.name,
  //     'age': person.age,
  //   };
  // }
}
