// To parse this JSON data, do
//
//     final mealPlannerResponse = mealPlannerResponseFromJson(jsonString);

import 'dart:convert';

MealPlannerResponse mealPlannerResponseFromJson(String str) =>
    MealPlannerResponse.fromJson(json.decode(str));

class MealPlannerResponse {
  final List<MealResponse>? meals;
  final NutrientsResponse? nutrients;

  MealPlannerResponse({
    required this.meals,
    required this.nutrients,
  });

  factory MealPlannerResponse.fromJson(Map<String, dynamic> json) =>
      MealPlannerResponse(
        meals: List<MealResponse>.from(
            json["meals"].map((x) => MealResponse.fromJson(x))),
        nutrients: NutrientsResponse.fromJson(json["nutrients"]),
      );
}

class MealResponse {
  final int id;
  final String? title;
  final String? imageType;
  final int? readyInMinutes;
  final int? servings;
  final String? sourceUrl;

  MealResponse({
    required this.id,
    required this.title,
    required this.imageType,
    required this.readyInMinutes,
    required this.servings,
    required this.sourceUrl,
  });

  factory MealResponse.fromJson(Map<String, dynamic> json) => MealResponse(
        id: json["id"],
        title: json["title"],
        imageType: json["imageType"],
        readyInMinutes: json["readyInMinutes"],
        servings: json["servings"],
        sourceUrl: json["sourceUrl"],
      );
}

class NutrientsResponse {
  final double? calories;
  final double? carbohydrates;
  final double? fat;
  final double? protein;

  NutrientsResponse({
    required this.calories,
    required this.carbohydrates,
    required this.fat,
    required this.protein,
  });

  factory NutrientsResponse.fromJson(Map<String, dynamic> json) =>
      NutrientsResponse(
        calories: json["calories"]?.toDouble(),
        carbohydrates: json["carbohydrates"]?.toDouble(),
        fat: json["fat"]?.toDouble(),
        protein: json["protein"]?.toDouble(),
      );
}
