import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/infrastructure/models/models.dart';

class RecipeMapper {
  static Recipe recipJsonToEntity(Map<String, dynamic> json,
      {int? statusCode}) {
    final RecipeResponse recipeResponse = RecipeResponse.fromJson(json);
    return Recipe(
      id: recipeResponse.id,
      title: recipeResponse.title ?? '--',
      cookingTime: recipeResponse.readyInMinutes ?? 0,
      image: recipeResponse.image ??
          'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-image-available-icon-flat-vector.jpg',
      servings: recipeResponse.servings ?? 0,
      pricePerServing: recipeResponse.pricePerServing ?? 0.0,
      ingredients: recipeResponse.extendedIngredients != null
          ? recipeResponse.extendedIngredients!
              .map((item) => Ingredient(
                    id: item.id,
                    name: item.name ?? '--',
                    nameClean: item.nameClean ?? '--',
                    image: item.image != null
                        ? 'https://spoonacular.com/cdn/ingredients_500x500/${item.image}'
                        : 'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-image-available-icon-flat-vector.jpg',
                    amount: item.original ?? '--',
                    unit: item.unit ?? '--',
                  ))
              .toList()
          : [],
      instructions: recipeResponse.instructions ?? '--',
      summary: recipeResponse.summary ?? '--',
      nutrients: recipeResponse.nutrition?.nutrients != null
          ? recipeResponse.nutrition!.nutrients!
              .take(9)
              .map((item) => Nutrient(
                    name: item.name ?? '--',
                    amount: item.amount ?? 0.0,
                    unit: item.unit ?? '--',
                    percentOfDailyNeeds: item.percentOfDailyNeeds ?? 0.0,
                  ))
              .toList()
          : [],
    );
  }

  //list of recipes to entity
  static List<Recipe> recipListJsonToEntity(Map<String, dynamic> json) {
    final List<RecipeResponse> recipeResponse =
        List<RecipeResponse>.from(json['recipes'].map((x) {
      return RecipeResponse.fromJson(x);
    }));

    return recipeResponse
        .map((item) => Recipe(
              id: item.id,
              title: item.title ?? '--',
              cookingTime: item.readyInMinutes ?? 0,
              image: item.image ??
                  'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-image-available-icon-flat-vector.jpg',
              servings: item.servings ?? 0,
              pricePerServing: item.pricePerServing ?? 0.0,
              ingredients: item.extendedIngredients != null
                  ? item.extendedIngredients!
                      .map((item) => Ingredient(
                            id: item.id,
                            name: item.name ?? '--',
                            nameClean: item.nameClean ?? '--',
                            image: item.image != null
                                ? 'https://spoonacular.com/cdn/ingredients_500x500/${item.image}'
                                : 'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-image-available-icon-flat-vector.jpg',
                            amount: item.original ?? '--',
                            unit: item.unit ?? '--',
                          ))
                      .toList()
                  : [],
              instructions: item.instructions ?? '--',
              summary: item.summary ?? '--',
              nutrients: item.nutrition?.nutrients != null
                  ? item.nutrition!.nutrients!
                      .take(9)
                      .map((item) => Nutrient(
                            name: item.name ?? '--',
                            amount: item.amount ?? 0.0,
                            unit: item.unit ?? '--',
                            percentOfDailyNeeds:
                                item.percentOfDailyNeeds ?? 0.0,
                          ))
                      .toList()
                  : [],
            ))
        .toList();
  }

  static similarRecipesToEntityList(Map<String, dynamic> json) {
    final List<Meal> recipes = [];

    for (final item in json['results']) {
      recipes.add(Meal(
        id: item['id'],
        name: item['title'],
        image: item["imageType"] != null
            ? 'https://spoonacular.com/recipeImages/${item["id"]}-556x370.${item["imageType"]}'
            : 'https://www.warnersstellian.com/Content/images/product_image_not_available.png',
        cookingTime: item['readyInMinutes'],
        servings: item['servings'],
      ));
    }
    return recipes;
  }
}
