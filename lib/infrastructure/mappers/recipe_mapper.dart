import 'package:fullfit_app/domain/entities/entities.dart';

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
                    image: item.image != null
                        ? 'https://spoonacular.com/cdn/ingredients_420x420/${item.image}.jpg'
                        : 'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-image-available-icon-flat-vector.jpg',
                    amount: item.amount ?? 0.0,
                    unit: item.unit ?? '--',
                  ))
              .toList()
          : [],
      instructions: recipeResponse.instructions ?? '--',
      summary: recipeResponse.summary ?? '--',
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
                            image: item.image != null
                                ? 'https://spoonacular.com/cdn/ingredients_420x420/${item.image}.jpg'
                                : 'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-image-available-icon-flat-vector.jpg',
                            amount: item.amount ?? 0.0,
                            unit: item.unit ?? '--',
                          ))
                      .toList()
                  : [],
              instructions: item.instructions ?? '--',
              summary: item.summary ?? '--',
            ))
        .toList();
  }
}
