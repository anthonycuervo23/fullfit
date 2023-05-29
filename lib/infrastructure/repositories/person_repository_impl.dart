import 'package:fullfit_app/domain/datasources/datasources.dart';
import 'package:fullfit_app/domain/entities/person.dart';
import 'package:fullfit_app/domain/repositories/repositories.dart';

class PersonRepositoryImpl extends PersonRepository {
  final PersonDatasource _personDatasource;

  PersonRepositoryImpl(personDatasource) : _personDatasource = personDatasource;

  @override
  Future<void> getUserData({String? userId}) {
    return _personDatasource.getUserData(userId: userId);
  }

  @override
  Person? get person => _personDatasource.person;
}
