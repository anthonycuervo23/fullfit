import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:fullfit_app/domain/datasources/datasources.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/infrastructure/mappers/mappers.dart';

class PersonDatasourceImpl extends PersonDatasource {
  static final PersonDatasourceImpl _singleton =
      PersonDatasourceImpl._internal();

  factory PersonDatasourceImpl() {
    return _singleton;
  }

  PersonDatasourceImpl._internal();

  Person? _person;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> getUserData({String? userId}) async {
    debugPrint('getUserData called');
    String? id = userId;
    try {
      if (userId == null) {
        final User? user = _firebaseAuth.currentUser;
        if (user == null) {
          throw Exception('No se ha podido obtener el usuario logueado');
        }
        id = user.uid;
      }

      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(id).get();

      _person = PersonMapper.firestoreUserToEntity(userDoc);
    } catch (e) {
      debugPrint(e.toString());
      _person = null;
      throw Exception(e);
    }
  }

  @override
  Person? get person => _person;
}
