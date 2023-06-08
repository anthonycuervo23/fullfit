import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/infrastructure/models/models.dart';

class MealPlannerMapper {
  static MealPlanner mealPlannerJsonToEntity(Map<String, dynamic> json) {
    final mealPlannerResponse = MealPlannerResponse.fromJson(json);
    final mealTypes = ['Breakfast', 'Lunch', 'Dinner']; // Orden de las comidas.

    return MealPlanner(
      meals: mealPlannerResponse.meals!
          .asMap()
          .entries
          .map(
            (entry) => Meal(
              id: entry.value.id,
              name: entry.value.title ?? '--',
              image: entry.value.imageType != null
                  ? 'https://spoonacular.com/recipeImages/${entry.value.id}-556x370.${entry.value.imageType}'
                  : 'https://www.warnersstellian.com/Content/images/product_image_not_available.png',
              cookingTime: entry.value.readyInMinutes ?? 0,
              servings: entry.value.servings ?? 0,
              type: mealTypes[entry.key], // Añade el tipo de comida.
            ),
          )
          .toList(),
      calories: mealPlannerResponse.nutrients?.calories ?? 0.0,
      carbohydrates: mealPlannerResponse.nutrients?.carbohydrates ?? 0.0,
      fat: mealPlannerResponse.nutrients?.fat ?? 0.0,
      protein: mealPlannerResponse.nutrients?.protein ?? 0.0,
    );
  }
}
