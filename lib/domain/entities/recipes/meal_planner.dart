import 'package:fullfit_app/domain/entities/recipes/meal.dart';

class MealPlanner {
  final List<Meal> meals;
  final double calories;
  final double carbohydrates;
  final double fat;
  final double protein;

  const MealPlanner({
    required this.meals,
    required this.calories,
    required this.carbohydrates,
    required this.fat,
    required this.protein,
  });
}
