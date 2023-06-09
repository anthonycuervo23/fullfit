import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

final similarRecipesInfoProvider =
    StateNotifierProvider<SimilarRecipesMapNotifier, Map<int, List<Meal>>>(
        (ref) {
  final recipesRepository = ref.watch(recipesRepositoryProvider);

  return SimilarRecipesMapNotifier(
      getSimilarRecipes: recipesRepository.getSimilarRecipes);
});

typedef GetSimilarRecipesCallback = Function(
    int id, Future Function(List<Meal>? recipes) closure);

class SimilarRecipesMapNotifier extends StateNotifier<Map<int, List<Meal>>> {
  final GetSimilarRecipesCallback _getSimilarRecipes;
  SimilarRecipesMapNotifier({required getSimilarRecipes})
      : _getSimilarRecipes = getSimilarRecipes,
        super({});

  Future<void> loadSimilarRecipes(int recipeId) async {
    if (state[recipeId] != null) {
      debugPrint(' 🤖 Similar Recipes loaded from cache');
      return;
    }

    await _getSimilarRecipes(recipeId, (recipes) async {
      if (recipes != null) {
        state = {...state, recipeId: recipes};
      }
    });
  }
}
