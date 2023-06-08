import 'package:fullfit_app/domain/entities/entities.dart';

abstract class RecipesRespository {
  Future<void> getRecipes(Future Function(List<Recipe>? recipes) closure,
      {String type = 'main course', int limit = 10});
  Future<void> getRecipeInfo(int id, Future Function(Recipe? recipe) closure);
  Future<List<RecipeResult>?> searchRecipes(
      {required String query, int limit = 10});
  Future<List<ComplexSearchRecipe>> getListRecipes(
      {required String query, int limit = 100, int offset = 0});
  Future<void> getTodayMealPlan(
      Future Function(MealPlanner? mealPlanner) closure,
      {int targetCalories = 2000,
      String diet = 'paleo'});
}
