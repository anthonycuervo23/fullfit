import 'package:fullfit_app/domain/datasources/local_storage_datasource.dart';
import 'package:fullfit_app/domain/entities/recipes/meal_planner.dart';
import 'package:fullfit_app/domain/entities/recipes/recipe.dart';
import 'package:fullfit_app/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryIml extends LocalStorageRepository {
  final LocalStorageDataSource _dataSource;

  LocalStorageRepositoryIml(this._dataSource);

  @override
  Future<List<Recipe>> getFavorites({int limit = 10, offset = 0}) {
    return _dataSource.getFavorites(limit: limit, offset: offset);
  }

  @override
  Future<MealPlanner?> getWeeklyMealPlan() {
    return _dataSource.getWeeklyMealPlan();
  }

  @override
  Future<bool> isFavorite(int recipeId) {
    return _dataSource.isFavorite(recipeId);
  }

  @override
  Future<void> saveWeekPlan(MealPlanner weekPlan) {
    return _dataSource.saveWeekPlan(weekPlan);
  }

  @override
  Future<void> toggleFavorite(Recipe recipe) {
    return _dataSource.toggleFavorite(recipe);
  }
}
