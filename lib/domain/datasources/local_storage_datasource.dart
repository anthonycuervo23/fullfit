import 'package:fullfit_app/domain/entities/entities.dart';

abstract class LocalStorageDataSource {
  Future<void> toggleFavorite(Recipe recipe);
  Future<bool> isFavorite(int recipeId);
  Future<List<Recipe>> getFavorites({int limit = 10, offset = 0});
  Future<void> saveWeekPlan(MealPlanner weekPlan);
  Future<MealPlanner?> getWeeklyMealPlan();
}
