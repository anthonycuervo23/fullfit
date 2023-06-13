import 'package:fullfit_app/domain/datasources/datasources.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/domain/repositories/repositories.dart';

class WorkoutsRepositoryImpl implements WorkoutsRepository {
  final WorkoutsDataSource _workoutsDataSource;

  WorkoutsRepositoryImpl({required workoutsDataSource})
      : _workoutsDataSource = workoutsDataSource;

  @override
  Stream<Workout?> getWorkoutStream(String workoutId) {
    return _workoutsDataSource.getWorkoutStream(workoutId);
  }
}
