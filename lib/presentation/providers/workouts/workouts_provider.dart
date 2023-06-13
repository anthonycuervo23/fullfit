import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/domain/repositories/repositories.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:intl/intl.dart';

final workoutStreamProvider = StreamProvider.autoDispose<Workout?>((ref) {
  final workoutsRepository = ref.watch(workoutsRepositoryProvider);
  final person = ref.watch(personProvider.notifier).user;
  final date = DateTime.now();
  final workoutDate = DateFormat('yyyy.M.d').format(date);
  final workoutId = '${person?.id}-$workoutDate-workout';
  return workoutsRepository.getWorkoutStream(workoutId);
});

//PROVIDER
final workoutsProvider =
    StateNotifierProvider<WorkoutNotifier, WorkoutState>((ref) {
  final String userId = ref.watch(personProvider.notifier).user!.id;
  final workoutsRepository = ref.watch(workoutsRepositoryProvider);

  return WorkoutNotifier(
      workoutsRepository: workoutsRepository, userId: userId);
});

typedef WorkoutCallback = Future<Workout?> Function(String workoutId);

//NOTIFIER
class WorkoutNotifier extends StateNotifier<WorkoutState> {
  final WorkoutsRepository _workoutsRepository;
  final String _userId;
  WorkoutNotifier({required workoutsRepository, required userId})
      : _workoutsRepository = workoutsRepository,
        _userId = userId,
        super(WorkoutState());

  Future<void> getWorkout(String workoutId, DateTime date) async {
    try {
      final workoutDate = DateFormat('yyyy.M.d').format(date);
      final workoutId = '$_userId-$workoutDate-workout';

      state = state.copyWith(isLoading: true, isFailure: false);
      final workout = await _workoutsRepository.getWorkout(workoutId);
      state =
          state.copyWith(workout: workout, isLoading: false, isFailure: false);
    } catch (e) {
      state = state.copyWith(isFailure: true, isLoading: false);
    }
  }
}

//STATE
class WorkoutState {
  final Workout? workout;
  final bool isLoading;
  final bool isFailure;

  WorkoutState({
    this.workout,
    this.isLoading = true,
    this.isFailure = false,
  });

  WorkoutState copyWith({
    Workout? workout,
    bool? isLoading,
    bool? isFailure,
  }) {
    return WorkoutState(
      workout: workout ?? this.workout,
      isLoading: isLoading ?? this.isLoading,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}
