import 'package:fullfit_app/domain/datasources/local_storage_datasource.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';

class IsarDataSourceImpl extends LocalStorageDataSource {
  late Future<Isar> db;

  IsarDataSourceImpl() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open([MealPlannerSchema],
          directory: dir.path, inspector: true);
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<List<Recipe>> getFavorites({int limit = 10, offset = 0}) {
    throw UnimplementedError();
  }

  @override
  Future<MealPlanner?> getWeeklyMealPlan() async {
    final isar = await db;

    final mealPlan = await isar.mealPlanners.get(1);
    return mealPlan;
  }

  @override
  Future<bool> isFavorite(int recipeId) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveWeekPlan(MealPlanner weekPlan) async {
    final isar = await db;

    //verificar si ya existe un meal plan pen la base de datos y lo eliminamos
    final oldPlan = await isar.mealPlanners.count();

    if (oldPlan > 0) {
      // isar.mealPlanners.clearSync();
      await isar.writeTxnSync(() => isar.mealPlanners.clear());
    }

    isar.writeTxnSync(() => isar.mealPlanners.putSync(weekPlan));
  }

  @override
  Future<void> toggleFavorite(Recipe recipe) {
    throw UnimplementedError();
  }
}
