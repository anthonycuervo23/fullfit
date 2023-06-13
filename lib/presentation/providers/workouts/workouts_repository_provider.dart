import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/repositories/repositories.dart';
import 'package:fullfit_app/infrastructure/datasources/datasources.dart';
import 'package:fullfit_app/infrastructure/repositories/repositories.dart';

final workoutsRepositoryProvider = Provider<WorkoutsRepository>((ref) {
  final workoutsDatasource =
      FirebaseWorkoutsDataSource(firestore: FirebaseFirestore.instance);
  return WorkoutsRepositoryImpl(workoutsDataSource: workoutsDatasource);
});
