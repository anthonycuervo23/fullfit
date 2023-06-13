import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

final recipeInfoProvider =
    StateNotifierProvider<RecipeMapNotifier, Map<int, Recipe>>((ref) {
  final recipesRepository = ref.watch(recipesRepositoryProvider);

  return RecipeMapNotifier(getRecipe: recipesRepository.getRecipeInfo);
});

typedef GetRecipeCallback = Future<void> Function(
    int id, Future<dynamic> Function(Recipe?) closure);

class RecipeMapNotifier extends StateNotifier<Map<int, Recipe>> {
  final GetRecipeCallback _getRecipe;
  RecipeMapNotifier({required getRecipe})
      : _getRecipe = getRecipe,
        super({});

  Future<void> loadRecipe(int recipeId) async {
    if (state[recipeId] != null) {
      debugPrint(' 🤖 Recipe loaded from cache');
      return;
    }

    await _getRecipe(recipeId, (recipe) async {
      if (recipe != null) {
        state = {...state, recipeId: recipe};
      }
    });
  }
}
