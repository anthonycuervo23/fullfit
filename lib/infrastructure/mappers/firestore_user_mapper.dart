import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fullfit_app/domain/entities/entities.dart';

class PersonMapper {
  static Person firestoreUserToEntity(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return Person(
      id: doc.id,
      name: doc.data()?['name'] ?? '--',
      lastname: doc.data()?['age'] ?? '--',
      age: doc.data()?['age'] ?? 0,
      height: doc.data()?['age'] ?? 0.0,
      weight: doc.data()?['age'] ?? 0.0,
      email: doc.data()?['email'] ?? '--',
      gender: doc.data()?['gender'] ?? '--',
      profilePic: doc.data()?['photoURL'] ?? '--',
    );
  }

  // static Map<String, dynamic> toFirestore(Person person) {
  //   return {
  //     'name': person.name,
  //     'age': person.age,
  //   };
  // }
}
