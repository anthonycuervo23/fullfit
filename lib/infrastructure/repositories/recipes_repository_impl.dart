import 'package:fullfit_app/domain/datasources/datasources.dart';
import 'package:fullfit_app/domain/entities/recipes/meal_planner.dart';
import 'package:fullfit_app/domain/entities/recipes/recipe.dart';
import 'package:fullfit_app/domain/repositories/repositories.dart';

class RecipesRepositoryImpl extends RecipesRespository {
  final RecipesDataSource _dataSource;

  RecipesRepositoryImpl(this._dataSource);

  @override
  Future<void> getRecipeInfo(int id, Future Function(Recipe recipe) closure) {
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
}
