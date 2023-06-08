import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

final mealPlannerProvider =
    StateNotifierProvider<MealPlannerNotifier, MealPlannerState>((ref) {
  final recipesRespository = ref.watch(recipesRepositoryProvider);
  return MealPlannerNotifier(
      fetchTodaysMealPlan: recipesRespository.getTodayMealPlan);
});

typedef MealPlannerCallback = Future<void> Function(
    Future Function(DailyMeal? mealPlanner) closure,
    {int targetCalories});

class MealPlannerNotifier extends StateNotifier<MealPlannerState> {
  final MealPlannerCallback _fetchTodaysMealPlan;
  MealPlannerNotifier({required fetchTodaysMealPlan})
      : _fetchTodaysMealPlan = fetchTodaysMealPlan,
        super(MealPlannerState());

  Future<void> loadTodaysMealPlan() async {
    state = state.copyWith(isLoading: true);

    await _fetchTodaysMealPlan(targetCalories: state.targetCalories,
        (mealPlanner) async {
      if (mealPlanner != null) {
        state = state.copyWith(
          isLoading: false,
          errorLoading: false,
          mealPlanner: mealPlanner,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorLoading: true,
        );
      }
    });
  }
}

class MealPlannerState {
  final bool isLoading;
  final DailyMeal? mealPlanner;
  final String diet;
  final int targetCalories;
  final bool? errorLoading;

  MealPlannerState({
    this.isLoading = false,
    this.mealPlanner,
    this.diet = 'paleo',
    this.targetCalories = 2000,
    this.errorLoading = false,
  });

  MealPlannerState copyWith({
    bool? isLoading,
    DailyMeal? mealPlanner,
    String? diet,
    int? targetCalories,
    bool? errorLoading,
  }) {
    return MealPlannerState(
      isLoading: isLoading ?? this.isLoading,
      mealPlanner: mealPlanner ?? this.mealPlanner,
      diet: diet ?? this.diet,
      targetCalories: targetCalories ?? this.targetCalories,
      errorLoading: errorLoading ?? this.errorLoading,
    );
  }
}
