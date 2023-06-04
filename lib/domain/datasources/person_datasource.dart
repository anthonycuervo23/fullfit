import 'package:fullfit_app/domain/entities/entities.dart';

abstract class PersonDatasource {
  bool get isUserLogged;
  Person? get person;
  Future<void> getUserData({String? userId});
  Future<void> saveUserData(Map<String, dynamic> personLike);
  Future<bool> checkUserDocumentExists();
}
