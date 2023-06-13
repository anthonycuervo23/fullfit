import 'package:fullfit_app/domain/entities/entities.dart';

abstract class WorkoutsDataSource {
  Stream<Workout?> getWorkoutStream(String workoutId);
}
