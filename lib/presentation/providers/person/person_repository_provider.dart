import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/repositories/repositories.dart';
import 'package:fullfit_app/infrastructure/datasources/datasources.dart';
import 'package:fullfit_app/infrastructure/repositories/repositories.dart';

final personRepositoryProvider = Provider<PersonRepository>((ref) {
  final personDatasource = PersonDatasourceImpl();
  return PersonRepositoryImpl(personDatasource);
});
