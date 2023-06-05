import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

final breakfastRecipesProvider =
    StateNotifierProvider<RecipesNotifier, List<Recipe>>((ref) {
  final recipesRespository = ref.watch(recipesRepositoryProvider);
  return RecipesNotifier(
      fetchRecipes: recipesRespository.getRecipes,
      limit: 10,
      type: 'breakfast');
});

final drinksRecipesProvider =
    StateNotifierProvider<RecipesNotifier, List<Recipe>>((ref) {
  final recipesRespository = ref.watch(recipesRepositoryProvider);
  return RecipesNotifier(
      fetchRecipes: recipesRespository.getRecipes, limit: 3, type: 'drinks');
});

final lunchRecipesProvider =
    StateNotifierProvider<RecipesNotifier, List<Recipe>>((ref) {
  final recipesRespository = ref.watch(recipesRepositoryProvider);
  return RecipesNotifier(
      fetchRecipes: recipesRespository.getRecipes, limit: 10, type: 'lunch');
});

final dessertsRecipesProvider =
    StateNotifierProvider<RecipesNotifier, List<Recipe>>((ref) {
  final recipesRespository = ref.watch(recipesRepositoryProvider);
  return RecipesNotifier(
      fetchRecipes: recipesRespository.getRecipes, limit: 3, type: 'dessert');
});

final veganRecipesProvider =
    StateNotifierProvider<RecipesNotifier, List<Recipe>>((ref) {
  final recipesRespository = ref.watch(recipesRepositoryProvider);
  return RecipesNotifier(
      fetchRecipes: recipesRespository.getRecipes,
      limit: 10,
      type: 'vegetarian');
});

typedef RecipesCallback = Future<void> Function(
    Future Function(List<Recipe>? recipes) closure,
    {String type,
    int limit});

class RecipesNotifier extends StateNotifier<List<Recipe>> {
  bool isLoading = false;
  final int limit;
  final String type;
  final RecipesCallback _fetchRecipes;
  RecipesNotifier({
    required RecipesCallback fetchRecipes,
    required this.limit,
    required this.type,
  })  : _fetchRecipes = fetchRecipes,
        super([]);

  Future<void> loadRecipes() async {
    if (isLoading) return;
    isLoading = true;
    await _fetchRecipes(limit: limit, type: type, (recipes) async {
      if (recipes != null) {
        state = recipes;
      } else {
        state = [];
      }
      isLoading = false;
    });
  }
}
