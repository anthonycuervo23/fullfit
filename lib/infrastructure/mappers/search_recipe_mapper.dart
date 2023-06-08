import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/infrastructure/models/models.dart';

class SearchRecipeMapper {
  static List<RecipeResult> fromJsonListToEntityList(
      Map<String, dynamic> json) {
    final List<SearchRecipeResponse> searchRecipeResponse =
        List<SearchRecipeResponse>.from(json['results'].map((x) {
      return SearchRecipeResponse.fromJson(x);
    }));

    return searchRecipeResponse
        .map(
          (item) => RecipeResult(
            id: item.id,
            title: item.title ?? '--',
            image: item.imageType != null
                ? 'https://spoonacular.com/recipeImages/${item.id}-240x150.${item.imageType}'
                : 'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-image-available-icon-flat-vector.jpg',
          ),
        )
        .toList();
  }

  static RecipeResult fromJsonToEntity(Map<String, dynamic> json) {
    final SearchRecipeResponse recipeResponse =
        SearchRecipeResponse.fromJson(json);
    return RecipeResult(
      id: recipeResponse.id,
      title: recipeResponse.title ?? '--',
      image: recipeResponse.imageType != null
          ? 'https://spoonacular.com/recipeImages/${recipeResponse.id}-240x150.${recipeResponse.imageType}'
          : 'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-image-available-icon-flat-vector.jpg',
    );
  }
}
