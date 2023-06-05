import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:fullfit_app/config/api/api_client.dart';
import 'package:fullfit_app/config/config.dart';
import 'package:fullfit_app/domain/datasources/datasources.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/infrastructure/mappers/mappers.dart';

class SpoonacularDataSourceImpl extends RecipesDataSource {
  SpoonacularDataSourceImpl() : super('https://api.spoonacular.com');

  @override
  Future execute<T>(
      Future<Response> request,
      T Function(Map<String, dynamic> json) expecting,
      Future<void> Function(T? result) completion) async {
    try {
      final response = await request;

      final T object = expecting(response.data);

      return completion(object);
    } on DioError catch (e) {
      debugPrint(e.toString());
      completion(null);
      throw DioError(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error: e.error,
          message: 'Error on SpoonacularDataSourceImpl 🥵🥵🥵');
    }
  }

  @override
  Future<void> getRecipeInfo(int id, Future Function(Recipe recipe) closure) {
    throw UnimplementedError();
  }

  @override
  Future<void> getRecipes(Future Function(List<Recipe>? recipes) closure,
      {String type = 'main course', int limit = 10}) async {
    var request = build(
        endpoint: '/recipes/random',
        requestType: RequestType.get,
        queryParameters: {
          'number': limit,
          'tags': type,
          'apiKey': Environment.scoopnacularApiKey,
        });

    await execute(request, RecipeMapper.recipListJsonToEntity, (result) async {
      if (result != null) {
        await closure(result);
      } else {
        await closure([]);
      }
    });
  }

  @override
  Future<void> getTodayMealPlan(
      Future Function(MealPlanner? mealPlanner) closure,
      {int targetCalories = 2000,
      String diet = 'paleo'}) async {
    var request = build(
        endpoint: '/mealplanner/generate',
        requestType: RequestType.get,
        queryParameters: {
          'timeFrame': 'day',
          'diet': diet,
          'targetCalories': targetCalories,
          'apiKey': Environment.scoopnacularApiKey,
        });

    await execute(request, MealPlannerMapper.mealPlannerJsonToEntity,
        (result) async {
      if (result != null) {
        await closure(result);
      } else {
        await closure(null);
      }
    });
  }
}
