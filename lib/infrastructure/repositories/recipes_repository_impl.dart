import 'package:fullfit_app/domain/datasources/datasources.dart';
import 'package:fullfit_app/domain/entities/recipes/complex_search_recipe.dart';
import 'package:fullfit_app/domain/entities/recipes/meal_planner.dart';
import 'package:fullfit_app/domain/entities/recipes/recipe.dart';
import 'package:fullfit_app/domain/entities/recipes/recipe_result.dart';
import 'package:fullfit_app/domain/repositories/repositories.dart';

class RecipesRepositoryImpl extends RecipesRespository {
  final RecipesDataSource _dataSource;

  RecipesRepositoryImpl(this._dataSource);

  @override
  Future<void> getRecipeInfo(int id, Future Function(Recipe? recipe) closure) {
    return _dataSource.getRecipeInfo(id, closure);
  }

  @override
  Future<void> getRecipes(Future Function(List<Recipe>? recipes) closure,
      {String type = 'main course', int limit = 10}) {
    return _dataSource.getRecipes(closure, type: type, limit: limit);
  }

  @override
  Future<void> getTodayMealPlan(
      Future Function(MealPlanner? mealPlanner) closure,
      {int targetCalories = 2000,
      String diet = 'paleo'}) {
    return _dataSource.getTodayMealPlan(closure,
        targetCalories: targetCalories, diet: diet);
  }

  @override
  Future<List<RecipeResult>?> searchRecipes(
      {required String query, int limit = 10}) {
    return _dataSource.searchRecipes(query: query, limit: limit);
  }

  @override
  Future<List<ComplexSearchRecipe>> getListRecipes(
      {required String query, int limit = 100, int offset = 0}) {
    return _dataSource.getListRecipes(
        query: query, limit: limit, offset: offset);
  }
}
