import 'package:fullfit_app/domain/entities/entities.dart';

abstract class PersonDatasource {
  Person? get person;
  Future<void> getUserData({String? userId});
}
