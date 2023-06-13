import 'package:fullfit_app/domain/entities/entities.dart';

class WorkoutMapper {
  static jsonWorkoutToEntity(Map<String, dynamic> json) => Workout(
      muscleGroups: (json['muscle_groups'] as List<dynamic>)
          .map((item) => item.toString())
          .toList(),
      workout: json['workout']);
}
