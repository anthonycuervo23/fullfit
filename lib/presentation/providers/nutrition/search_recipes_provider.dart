import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedRecipesProvider =
    StateNotifierProvider<SearchedRecipesNotifier, SearchRecipesState>(
        (ref) => SearchedRecipesNotifier(
              searchRecipes: ref.read(recipesRepositoryProvider).searchRecipes,
              getSuggestedRecipes:
                  ref.read(recipesRepositoryProvider).getListRecipes,
              ref: ref,
            ));

typedef SearchRecipesCallback = Future<List<RecipeResult>?> Function(
    {required String query, int limit});

typedef SearchSuggestedRecipesCallback = Future<List<ComplexSearchRecipe>>
    Function({required String query, int limit, int offset});

class SearchedRecipesNotifier extends StateNotifier<SearchRecipesState> {
  final SearchRecipesCallback _searchRecipes;
  final SearchSuggestedRecipesCallback _getSuggestedRecipes;
  final Ref ref;

  SearchedRecipesNotifier(
      {required SearchRecipesCallback searchRecipes,
      required SearchSuggestedRecipesCallback getSuggestedRecipes,
      required this.ref})
      : _searchRecipes = searchRecipes,
        _getSuggestedRecipes = getSuggestedRecipes,
        super(SearchRecipesState());

  Future<List<RecipeResult>> searchRecipesByQuery(
      {required String query}) async {
    final recipes = await _searchRecipes(query: query, limit: 10);
    ref.read(searchQueryProvider.notifier).update((state) => query);
    state = state.copyWith(
      searchedRecipes: recipes ?? [],
    );
    return recipes ?? [];
  }

  Future loadNextPage(String type) async {
    if (type != state.searchQuery) {
      state = state.copyWith(
        offset: 0,
        isLastPage: false,
        isLoading: false,
        searchQuery: type,
        suggestedRecipes: [],
      );
    }
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final recipes = await _getSuggestedRecipes(
      query: type,
      limit: state.limit,
      offset: state.offset,
    );

    if (recipes.isEmpty) {
      state = state.copyWith(
        isLastPage: true,
        isLoading: false,
      );
      return;
    }

    state = state.copyWith(
      offset: state.offset + state.limit,
      isLoading: false,
      isLastPage: false,
      suggestedRecipes: [...state.suggestedRecipes, ...recipes],
    );
  }
}

//STATE
class SearchRecipesState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final String searchQuery;
  final List<ComplexSearchRecipe> suggestedRecipes;
  final List<RecipeResult> searchedRecipes;

  SearchRecipesState({
    this.isLastPage = false,
    this.limit = 100,
    this.offset = 0,
    this.isLoading = false,
    this.searchQuery = '',
    this.searchedRecipes = const [],
    this.suggestedRecipes = const [],
  });

  SearchRecipesState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    String? searchQuery,
    List<RecipeResult>? searchedRecipes,
    List<ComplexSearchRecipe>? suggestedRecipes,
  }) =>
      SearchRecipesState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        searchQuery: searchQuery ?? this.searchQuery,
        searchedRecipes: searchedRecipes ?? this.searchedRecipes,
        suggestedRecipes: suggestedRecipes ?? this.suggestedRecipes,
      );
}
