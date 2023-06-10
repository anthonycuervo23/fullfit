import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/domain/repositories/repositories.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

//PROVIDER
final nutritionTrackingProvider =
    StateNotifierProvider<NutritionTrackingNotifier, NutritionTrackingState>(
        (ref) {
  final recipeRepository = ref.watch(recipesRepositoryProvider);

  return NutritionTrackingNotifier(
    recipeRepository: recipeRepository,
    ref: ref,
  );
});

//NOTIFIER
class NutritionTrackingNotifier extends StateNotifier<NutritionTrackingState> {
  final RecipesRespository _recipesRespository;
  final Ref _ref;
  StreamSubscription? _nutrientsStreamSub;

  NutritionTrackingNotifier({required recipeRepository, required ref})
      : _recipesRespository = recipeRepository,
        _ref = ref,
        super(NutritionTrackingState()) {
    _subscribeToNutrientsStream();
  }

  @override
  void dispose() {
    _nutrientsStreamSub?.cancel();
    super.dispose();
  }

  void _subscribeToNutrientsStream() {
    final person = _ref.watch(personProvider.notifier).user;

    _nutrientsStreamSub = _recipesRespository
        .getNutrients(
      userId: person!.id,
      dailyCalories: person.targetCalories,
      dailyProtein: person.targetProtein,
      dailyFat: person.targetFat,
      dailyCarbs: person.targetCarbs,
    )
        .listen((consumptionData) {
      state =
          state.copyWith(consumptionData: consumptionData, isLoading: false);
    }, onError: (error) {
      state = state.copyWith(errorMessage: error.toString(), isLoading: false);
    });
  }

  Future<void> addMealToDB(Recipe recipe) async {
    CustomLoader.show();

    final person = _ref.watch(personProvider.notifier).user;

    state = state.copyWith(isLoading: true);
    await _recipesRespository.addMealToDB((success) async {
      if (success) {
        state = state.copyWith(isLoading: false);
        CustomLoader.showSuccess();
        await Future.delayed(const Duration(seconds: 1));
        CustomLoader.dismiss();
      } else {
        debugPrint('Error adding meal to Firestore');
        state = state.copyWith(
          errorMessage: 'Error adding meal to DB',
          isLoading: false,
        );
      }
    }, userId: person!.id, recipe: recipe);
  }
}

//STATE
class NutritionTrackingState {
  final ConsumptionData? consumptionData;
  final bool isLoading;
  final String? errorMessage;

  NutritionTrackingState({
    this.consumptionData,
    this.isLoading = false,
    this.errorMessage,
  });

  NutritionTrackingState copyWith({
    ConsumptionData? consumptionData,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NutritionTrackingState(
      consumptionData: consumptionData ?? this.consumptionData,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
