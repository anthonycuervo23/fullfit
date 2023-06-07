import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedRecipesProvider =
    StateNotifierProvider<SearchedRecipesNotifier, List<RecipeResult>>(
        (ref) => SearchedRecipesNotifier(
              searchRecipes: ref.read(recipesRepositoryProvider).searchRecipes,
              ref: ref,
            ));

typedef SearchRecipesCallback = Future<List<RecipeResult>> Function(
    {required String query, int limit});

class SearchedRecipesNotifier extends StateNotifier<List<RecipeResult>> {
  final SearchRecipesCallback _searchRecipes;
  final Ref ref;

  SearchedRecipesNotifier(
      {required SearchRecipesCallback searchRecipes, required this.ref})
      : _searchRecipes = searchRecipes,
        super([]);

  Future<List<RecipeResult>> searchRecipesByQuery(
      {required String query}) async {
    final recipes = await _searchRecipes(query: query);
    ref.read(searchQueryProvider.notifier).update((state) => query);
    state = recipes;
    return recipes;
  }
}
