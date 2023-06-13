import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:intl/intl.dart';

final workoutProvider = StreamProvider.autoDispose<Workout?>((ref) {
  final workoutsRepository = ref.watch(workoutsRepositoryProvider);
  final person = ref.watch(personProvider.notifier).user;
  final date = DateTime.now();
  final workoutDate = DateFormat('yyyy.M.d').format(date);
  final workoutId = '${person?.id}-$workoutDate-workout';
  return workoutsRepository.getWorkoutStream(workoutId);
});
