import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:isar/isar.dart';
part 'daily_meal.g.dart';

@embedded
class DailyMeal {
  final List<Meal>? meals;
  final MealNutrients? nutrients;

  DailyMeal({
    this.meals,
    this.nutrients,
  });
}
