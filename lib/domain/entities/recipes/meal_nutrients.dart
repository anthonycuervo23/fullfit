import 'package:isar/isar.dart';
part 'meal_nutrients.g.dart';

@embedded
class MealNutrients {
  final double? calories;
  final double? protein;
  final double? fat;
  final double? carbohydrates;

  MealNutrients({
    this.calories,
    this.protein,
    this.fat,
    this.carbohydrates,
  });
}
