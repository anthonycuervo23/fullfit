import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/infrastructure/models/models.dart';

class ComplexResultsMapper {
  static List<ComplexSearchRecipe> searchComplexResultsJsonToEntity(
      Map<String, dynamic> json) {
    final List<Result> complexSearchRecipeResponse =
        List<Result>.from(json['results'].map((x) {
      return Result.fromJson(x);
    }));

    return complexSearchRecipeResponse
        .map(
          (item) => ComplexSearchRecipe(
            id: item.id,
            title: item.title ?? '--',
            image: item.image ??
                'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-image-available-icon-flat-vector.jpg',
          ),
        )
        .toList();
  }
}
