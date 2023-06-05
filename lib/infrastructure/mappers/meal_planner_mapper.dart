import 'package:fullfit_app/domain/entities/entities.dart';

class MealPlannerMapper {
  static MealPlanner mealPlannerJsonToEntity(Map<String, dynamic> json) {
    final mealPlannerResponse = MealPlannerResponse.fromJson(json);

    return MealPlanner(
      meals: mealPlannerResponse.meals!
          .map(
            (meal) => Meal(
              id: meal.id,
              name: meal.title ?? '--',
              image: meal.imageType != null
                  ? 'https://spoonacular.com/recipeImages/${meal.id}-556x370.${meal.imageType}'
                  : 'https://www.warnersstellian.com/Content/images/product_image_not_available.png',
              cookingTime: meal.readyInMinutes ?? 0,
              servings: meal.servings ?? 0,
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
