import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fullfit_app/domain/entities/entities.dart';

typedef SearchRecipesCallback = Future<List<RecipeResult>> Function(
    {required String query});

class SearchMovieDelegate extends SearchDelegate<RecipeResult?> {
  final SearchRecipesCallback searchRecipes;
  List<RecipeResult> initialRecipes;
  Timer? _debounceTimer;
  StreamController<List<RecipeResult>> debouncedRecipes =
      StreamController<List<RecipeResult>>.broadcast();
  StreamController<bool> isLoadingStream = StreamController<bool>.broadcast();

  SearchMovieDelegate({
    required this.searchRecipes,
    required this.initialRecipes,
  });

  void closeStream() {
    debouncedRecipes.close();
    isLoadingStream.close();
  }

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      //hacemos la peticion http despues de 500ms que el usuario dejo de escribir
      final movies = await searchRecipes(query: query);
      initialRecipes = movies;
      debouncedRecipes.add(movies);
      isLoadingStream.add(false);
    });
  }

  @override
  String? get searchFieldLabel => 'Search a Recipe...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder<bool>(
          stream: isLoadingStream.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              return SpinPerfect(
                  duration: const Duration(seconds: 16),
                  infinite: true,
                  spins: 10,
                  child: const Icon(Icons.refresh_rounded));
            }
            return FadeIn(
              animate: query.isNotEmpty,
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.clear),
              ),
            );
          }),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        closeStream();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return _buildResultsAndSuggestions();
  }

  Widget _buildResultsAndSuggestions() {
    return StreamBuilder(
        initialData: initialRecipes,
        stream: debouncedRecipes.stream,
        builder:
            (BuildContext context, AsyncSnapshot<List<RecipeResult>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2.0),
            );
          }

          final recipes = snapshot.data ?? [];

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return _recipeItem(context, recipe, onRecipeSelected: close);
            },
          );
        });
  }

  Widget _recipeItem(BuildContext context, RecipeResult recipe,
      {required Function onRecipeSelected}) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        closeStream();
        onRecipeSelected(context, recipe);
      },
      child: FadeIn(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Row(
            children: [
              //* Poster
              SizedBox(
                width: size.width * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    height: 130,
                    fit: BoxFit.cover,
                    image: NetworkImage(recipe.image),
                    placeholder:
                        const AssetImage('assets/loaders/bottle-loader.gif'),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              //* Description
              SizedBox(
                width: size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* Title
                    Text(
                      recipe.title,
                      style: textStyles.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    //* Overview
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
