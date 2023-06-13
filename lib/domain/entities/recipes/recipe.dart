import 'package:fullfit_app/domain/entities/entities.dart';

class Recipe {
  final int id;
  final String title;
  final int cookingTime;
  final String image;
  final int servings;
  final double pricePerServing;
  final List<Ingredient> ingredients;
  final String instructions;
  final String summary;
  final List<Nutrient> nutrients;

  Recipe({
    required this.id,
    required this.title,
    required this.cookingTime,
    required this.image,
    required this.servings,
    required this.pricePerServing,
    required this.ingredients,
    required this.instructions,
    required this.summary,
    required this.nutrients,
  });
}

//extenden ingredients, instructions, summary y equipment pueden venir vacios