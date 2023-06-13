// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/domain/entities/entities.dart';

typedef SearchRecipesCallback = Future<List<RecipeResult>?> Function(
    {required String query, int limit});

class SearchRecipes extends StatefulWidget {
  final SearchRecipesCallback searchRecipes;
  final Function(RecipeResult) onRecipeSelected;
  List<RecipeResult> initialRecipes;
  SearchRecipes(
      {Key? key,
      required this.searchRecipes,
      required this.initialRecipes,
      required this.onRecipeSelected})
      : super(key: key);

  @override
  SearchRecipesState createState() => SearchRecipesState();
}

class SearchRecipesState extends State<SearchRecipes> {
  RecipeResult? selectedRecipe;
  List<RecipeResult> searchHistory = <RecipeResult>[];
  Timer? _debounceTimer;
  StreamController<List<RecipeResult>> debouncedRecipes =
      StreamController<List<RecipeResult>>.broadcast();
  StreamController<bool> isLoadingStream = StreamController<bool>.broadcast();

  void closeStream() {
    debouncedRecipes.close();
    isLoadingStream.close();
  }

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      //hacemos la peticion http despues de 500ms que el usuario dejo de escribir
      final recipes = await widget.searchRecipes(query: query);
      widget.initialRecipes = recipes ?? [];
      debouncedRecipes.add(recipes ?? []);
      isLoadingStream.add(false);
    });
  }

  Iterable<Widget> getHistoryList(SearchController controller) {
    return searchHistory.map((recipe) => ListTile(
          leading: const Icon(Icons.history),
          title: Text(recipe.title),
          trailing: IconButton(
            icon: const Icon(Icons.call_missed),
            onPressed: () {
              controller.text = recipe.title;
              controller.selection =
                  TextSelection.collapsed(offset: controller.text.length);
            },
          ),
          onTap: () {
            controller.closeView(recipe.title);
            handleSelection(recipe);
          },
        ));
  }

  Iterable<Widget> buildSuggestions(SearchController controller) {
    final String query = controller.value.text;

    _onQueryChanged(query);
    return _buildResultsAndSuggestions(controller);
  }

  Iterable<Widget> _buildResultsAndSuggestions(SearchController controller) {
    return [
      StreamBuilder(
        initialData: widget.initialRecipes,
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
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return _recipeItem(recipe, controller,
                  onRecipeSelected: handleSelection);
            },
          );
        },
      ),
    ];
  }

  Widget _recipeItem(RecipeResult recipe, SearchController controller,
      {required Function onRecipeSelected}) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return FadeIn(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
        child: ListTile(
          onTap: () {
            controller.closeView(recipe.title);
            handleSelection(recipe);
          },
          leading: Container(
            width: 100,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colors.surface,
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(recipe.image))),
          ),
          title: Text(
            recipe.title,
            style: textStyles.bodyMedium?.copyWith(fontSize: 20.0.sp),
          ),
        ),
      ),
    );
  }

  void handleSelection(RecipeResult recipe) {
    setState(() {
      // Comprueba si la receta ya existe en el historial
      final existingRecipe = searchHistory.firstWhere(
        (r) => r.id == recipe.id, // o r.title == recipe.title
        orElse: () => RecipeResult(
            //creamos un resultado ficticio para que no entre en el if de abajo
            id: 000,
            title: 'not-found-recipe',
            image: 'not-image'),
      );

      // Si la receta ya existe, la elimina
      if (existingRecipe.id != 000) {
        searchHistory.remove(existingRecipe);
      } else {
        // Si la lista de historial tiene más de 5 elementos, elimina el último
        if (searchHistory.length >= 5) {
          searchHistory.removeLast();
        }
      }

      // Inserta la receta al principio del historial
      searchHistory.insert(0, recipe);
    });

    // Llama al callback con la receta seleccionada
    widget.onRecipeSelected(recipe);
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return SearchAnchor.bar(
      isFullScreen: false,
      viewBackgroundColor: colors.surface,
      barHintText: 'Search for recipes',
      barTextStyle: MaterialStateProperty.all(
        textStyles.bodyMedium?.copyWith(
          fontSize: 20.0.sp,
        ),
      ),
      barHintStyle: MaterialStateProperty.all(
        textStyles.bodyMedium?.copyWith(
          fontSize: 20.0.sp,
        ),
      ),
      barElevation: MaterialStateProperty.all(0),
      barShape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
      ),
      barBackgroundColor:
          MaterialStateProperty.all(colors.primary.withOpacity(0.2)),
      viewLeading: IconButton(
        onPressed: () {
          closeStream();
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      suggestionsBuilder: (context, controller) {
        if (controller.text.isEmpty) {
          if (searchHistory.isNotEmpty) {
            return getHistoryList(controller);
          }
          return <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Text(
                  'No search history.',
                  style: textStyles.bodyMedium?.copyWith(
                    fontSize: 20.0.sp,
                  ),
                ),
              ),
            )
          ];
        }
        return buildSuggestions(controller);
      },
    );
  }
}
