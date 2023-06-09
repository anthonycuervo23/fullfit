import 'package:fullfit_app/domain/entities/entities.dart';

abstract class RecipesRespository {
  Future<void> getRecipes(Future Function(List<Recipe>? recipes) closure,
      {String type = 'main course', int limit = 10});
  Future<void> getRecipeInfo(int id, Future Function(Recipe? recipe) closure);
  Future<void> getEquipmentInfo(
      int id, Future Function(List<Equipment>? equipment) closure);
  Future<void> getSimilarRecipes(
      int id, Future Function(List<Meal>? recipes) closure);
  Future<List<RecipeResult>?> searchRecipes(
      {required String query, int limit = 10});
  Future<List<ComplexSearchRecipe>> getListRecipes(
      {required String query, int limit = 100, int offset = 0});
  Future<void> getTodayMealPlan(Future Function(DailyMeal? mealPlanner) closure,
      {int targetCalories = 2000});
  Future<MealPlanner?> getWeekMealPlan();

  Stream<ConsumptionData?> getNutrients(
      {required String userId,
      required double dailyCalories,
      required double dailyProtein,
      required double dailyFat,
      required double dailyCarbs});

  Future<void> addMealToDB(Future Function(bool success) closure,
      {required String userId, required Recipe recipe});
}
