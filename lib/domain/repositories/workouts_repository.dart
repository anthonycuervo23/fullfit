import 'package:fullfit_app/domain/entities/entities.dart';

abstract class WorkoutsRepository {
  Stream<Workout?> getWorkoutStream(String workoutId);
}
