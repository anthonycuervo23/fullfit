// To parse this JSON data, do
//
//     final complexSearchRecipesResponse = complexSearchRecipesResponseFromJson(jsonString);

import 'dart:convert';

ComplexSearchRecipesResponse complexSearchRecipesResponseFromJson(String str) =>
    ComplexSearchRecipesResponse.fromJson(json.decode(str));

class ComplexSearchRecipesResponse {
  final int? offset;
  final int? number;
  final List<Result>? results;
  final int? totalResults;

  ComplexSearchRecipesResponse({
    required this.offset,
    required this.number,
    required this.results,
    required this.totalResults,
  });

  factory ComplexSearchRecipesResponse.fromJson(Map<String, dynamic> json) =>
      ComplexSearchRecipesResponse(
        offset: json["offset"],
        number: json["number"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalResults: json["totalResults"],
      );
}

class Result {
  final int id;
  final String? title;
  final String? image;
  final String? imageType;

  Result({
    required this.id,
    required this.title,
    required this.image,
    required this.imageType,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        imageType: json["imageType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "imageType": imageType,
      };
}
