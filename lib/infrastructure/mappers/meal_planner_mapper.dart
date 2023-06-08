import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/infrastructure/models/models.dart';

class MealPlannerMapper {
  static final List<String> mealTypes = [
    'Breakfast',
    'Lunch',
    'Dinner'
  ]; // Orden de las comidas.

  static MealPlanner mealPlannerJsonToEntity(Map<String, dynamic> json) {
    final mealPlannerResponse = WeekMealPlannerResponse.fromJson(json);
    return MealPlanner(
      monday: _dayToDailyMeal(mealPlannerResponse.week!.monday!),
      tuesday: _dayToDailyMeal(mealPlannerResponse.week!.tuesday!),
      wednesday: _dayToDailyMeal(mealPlannerResponse.week!.wednesday!),
      thursday: _dayToDailyMeal(mealPlannerResponse.week!.thursday!),
      friday: _dayToDailyMeal(mealPlannerResponse.week!.friday!),
      saturday: _dayToDailyMeal(mealPlannerResponse.week!.saturday!),
      sunday: _dayToDailyMeal(mealPlannerResponse.week!.sunday!),
    );
  }

  static DailyMeal _dayToDailyMeal(Day day) {
    return DailyMeal(
        meals: day.meals!
            .asMap()
            .entries
            .map((entry) => _mealResponseToMeal(entry.value, entry.key))
            .toList(),
        nutrients: _nutrientsResponseToMealNutrients(day.nutrients!));
  }

  static Meal _mealResponseToMeal(MealResponse mealResponse, int index) {
    return Meal(
      id: mealResponse.id,
      name: mealResponse.title ?? '--',
      image: mealResponse.imageType != null
          ? 'https://spoonacular.com/recipeImages/${mealResponse.id}-556x370.${mealResponse.imageType}'
          : 'https://www.warnersstellian.com/Content/images/product_image_not_available.png',
      cookingTime: mealResponse.readyInMinutes ?? 0,
      servings: mealResponse.servings ?? 0,
      type: mealTypes[index % mealTypes.length],
    );
  }

  static MealNutrients _nutrientsResponseToMealNutrients(
      NutrientsResponse nutrientsResponse) {
    return MealNutrients(
        calories: nutrientsResponse.calories!,
        protein: nutrientsResponse.protein!,
        fat: nutrientsResponse.fat!,
        carbohydrates: nutrientsResponse.carbohydrates!);
  }
}
