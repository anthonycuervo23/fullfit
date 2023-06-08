// To parse this JSON data, do
//
//     final weekMealPlannerResponse = weekMealPlannerResponseFromJson(jsonString);

import 'dart:convert';

WeekMealPlannerResponse weekMealPlannerResponseFromJson(String str) =>
    WeekMealPlannerResponse.fromJson(json.decode(str));

class WeekMealPlannerResponse {
  final Week? week;

  WeekMealPlannerResponse({
    required this.week,
  });

  factory WeekMealPlannerResponse.fromJson(Map<String, dynamic> json) =>
      WeekMealPlannerResponse(
        week: Week.fromJson(json["week"]),
      );
}

class Week {
  final Day? monday;
  final Day? tuesday;
  final Day? wednesday;
  final Day? thursday;
  final Day? friday;
  final Day? saturday;
  final Day? sunday;

  Week({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory Week.fromJson(Map<String, dynamic> json) => Week(
        monday: Day.fromJson(json["monday"]),
        tuesday: Day.fromJson(json["tuesday"]),
        wednesday: Day.fromJson(json["wednesday"]),
        thursday: Day.fromJson(json["thursday"]),
        friday: Day.fromJson(json["friday"]),
        saturday: Day.fromJson(json["saturday"]),
        sunday: Day.fromJson(json["sunday"]),
      );
}

class Day {
  final List<MealResponse>? meals;
  final NutrientsResponse? nutrients;

  Day({
    required this.meals,
    required this.nutrients,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        meals: List<MealResponse>.from(
            json["meals"].map((x) => MealResponse.fromJson(x))),
        nutrients: NutrientsResponse.fromJson(json["nutrients"]),
      );
}

class MealResponse {
  final int id;
  final String? imageType;
  final String? title;
  final int? readyInMinutes;
  final int? servings;
  final String? sourceUrl;

  MealResponse({
    required this.id,
    required this.imageType,
    required this.title,
    required this.readyInMinutes,
    required this.servings,
    required this.sourceUrl,
  });

  factory MealResponse.fromJson(Map<String, dynamic> json) => MealResponse(
        id: json["id"],
        imageType: json["imageType"],
        title: json["title"],
        readyInMinutes: json["readyInMinutes"],
        servings: json["servings"],
        sourceUrl: json["sourceUrl"],
      );
}

class NutrientsResponse {
  final double? calories;
  final double? protein;
  final double? fat;
  final double? carbohydrates;

  NutrientsResponse({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbohydrates,
  });

  factory NutrientsResponse.fromJson(Map<String, dynamic> json) =>
      NutrientsResponse(
        calories: json["calories"]?.toDouble(),
        protein: json["protein"]?.toDouble(),
        fat: json["fat"]?.toDouble(),
        carbohydrates: json["carbohydrates"]?.toDouble(),
      );
}
