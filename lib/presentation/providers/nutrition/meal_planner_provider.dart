import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/domain/repositories/repositories.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

final mealPlannerProvider =
    StateNotifierProvider<MealPlannerNotifier, MealPlannerState>((ref) {
  final recipesRepository = ref.watch(recipesRepositoryProvider);
  return MealPlannerNotifier(recipesRepository: recipesRepository);
});

// typedef MealPlannerCallback = Future<void> Function(
//     Future Function(DailyMeal? mealPlanner) closure,
//     {int targetCalories});

class MealPlannerNotifier extends StateNotifier<MealPlannerState> {
  final RecipesRespository _recipesRepository;
  MealPlannerNotifier({required recipesRepository})
      : _recipesRepository = recipesRepository,
        super(MealPlannerState());

  Future<void> loadTodaysMealPlan() async {
    state = state.copyWith(isLoading: true);

    await _recipesRepository.getTodayMealPlan(
        targetCalories: state.targetCalories, (mealPlanner) async {
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

  void setTargetCalories(int targetCalories) {
    state = state.copyWith(targetCalories: targetCalories);
  }

  void getWeekMealPlan() async {
    state = state.copyWith(isLoading: true);
    final weekMealPlan = await _recipesRepository.getWeekMealPlan();
    if (weekMealPlan != null) {
      state = state.copyWith(
        isLoading: false,
        errorLoading: false,
        weekMealPlan: weekMealPlan,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        errorLoading: true,
      );
    }
  }
}

class MealPlannerState {
  final bool isLoading;
  final DailyMeal? mealPlanner;
  final MealPlanner? weekMealPlan;
  final int targetCalories;
  final bool? errorLoading;

  MealPlannerState({
    this.isLoading = false,
    this.mealPlanner,
    this.weekMealPlan,
    this.targetCalories = 2000,
    this.errorLoading = false,
  });

  MealPlannerState copyWith({
    bool? isLoading,
    DailyMeal? mealPlanner,
    MealPlanner? weekMealPlan,
    int? targetCalories,
    bool? errorLoading,
  }) {
    return MealPlannerState(
      isLoading: isLoading ?? this.isLoading,
      mealPlanner: mealPlanner ?? this.mealPlanner,
      weekMealPlan: weekMealPlan ?? this.weekMealPlan,
      targetCalories: targetCalories ?? this.targetCalories,
      errorLoading: errorLoading ?? this.errorLoading,
    );
  }
}
