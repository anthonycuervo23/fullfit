// To parse this JSON data, do
//
//     final searchRecipeResponse = searchRecipeResponseFromJson(jsonString);

import 'dart:convert';

List<SearchRecipeResponse> searchRecipeResponseFromJson(String str) =>
    List<SearchRecipeResponse>.from(
        json.decode(str).map((x) => SearchRecipeResponse.fromJson(x)));

String searchRecipeResponseToJson(List<SearchRecipeResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchRecipeResponse {
  final int id;
  final String? title;
  final String? imageType;

  SearchRecipeResponse({
    required this.id,
    required this.title,
    required this.imageType,
  });

  factory SearchRecipeResponse.fromJson(Map<String, dynamic> json) =>
      SearchRecipeResponse(
        id: json["id"],
        title: json["title"],
        imageType: json["imageType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "imageType": imageType,
      };
}
