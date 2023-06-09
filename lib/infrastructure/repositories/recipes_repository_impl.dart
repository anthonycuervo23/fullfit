import 'package:fullfit_app/domain/datasources/datasources.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
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

  @override
  Future<void> getTodayMealPlan(Future Function(DailyMeal? mealPlanner) closure,
      {int targetCalories = 2000}) {
    return _dataSource.getTodayMealPlan(closure,
        targetCalories: targetCalories);
  }

  @override
  Future<MealPlanner?> getWeekMealPlan() {
    return _dataSource.getWeekMealPlan();
  }

  @override
  Future<void> getEquipmentInfo(
      int id, Future Function(List<Equipment>? equipment) closure) {
    return _dataSource.getEquipmentInfo(id, closure);
  }

  @override
  Future<void> getSimilarRecipes(
      int id, Future Function(List<Meal>? recipes) closure) {
    return _dataSource.getSimilarRecipes(id, closure);
  }

  @override
  Future<void> addMealToDB(Future Function(bool success) closure,
      {required String userId, required Recipe recipe}) {
    return _dataSource.addMealToDB(closure, userId: userId, recipe: recipe);
  }

  @override
  Stream<ConsumptionData?> getNutrients(
      {required String userId,
      required double dailyCalories,
      required double dailyProtein,
      required double dailyFat,
      required double dailyCarbs}) {
    return _dataSource.getNutrients(
        userId: userId,
        dailyCalories: dailyCalories,
        dailyProtein: dailyProtein,
        dailyFat: dailyFat,
        dailyCarbs: dailyCarbs);
  }
}
