import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:fullfit_app/config/api/api_client.dart';
import 'package:fullfit_app/config/config.dart';
import 'package:fullfit_app/domain/datasources/datasources.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/infrastructure/mappers/mappers.dart';

class SpoonacularDataSourceImpl extends RecipesDataSource {
  SpoonacularDataSourceImpl()
      : super('https://api.spoonacular.com',
            headers: {'x-api-key': Environment.scoopnacularApiKey});

  @override
  Future execute<T>(
      Future<Response> request,
      T Function(Map<String, dynamic> json) expecting,
      Future<void> Function(T? result) completion) async {
    try {
      final response = await request;

      if (response.data is List) {
        final T object = expecting({'results': response.data});
        return completion(object);
      } else if (response.data is Map<String, dynamic>) {
        final T object = expecting(response.data);
        return completion(object);
        // await completion(object);
      } else {
        throw Exception('Unexpected response type');
      }

      // final T object = expecting(response.data);

      // return completion(object);
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
  Future<void> getRecipeInfo(
      int id, Future Function(Recipe? recipe) closure) async {
    var request = build(
        endpoint: '/recipes/$id/information',
        requestType: RequestType.get,
        queryParameters: {'includeNutrition': true});

    await execute(request, RecipeMapper.recipJsonToEntity, (result) async {
      if (result != null) {
        await closure(result);
      } else {
        await closure(null);
      }
    });
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

  @override
  Future<List<RecipeResult>?> searchRecipes(
      {required String query, int limit = 10}) async {
    var request = build(
        endpoint: '/recipes/autocomplete',
        requestType: RequestType.get,
        queryParameters: {
          'query': query,
          'number': limit,
        });

    var completer = Completer<List<RecipeResult>?>();

    await execute(request, SearchRecipeMapper.fromJsonListToEntityList,
        (result) async {
      if (result != null) {
        completer.complete(result);
      } else {
        completer.complete([]);
      }
    });

    return completer.future;
  }

  @override
  Future<List<ComplexSearchRecipe>> getListRecipes(
      {required String query, int limit = 100, int offset = 0}) async {
    var request = build(
        endpoint: '/recipes/complexSearch',
        requestType: RequestType.get,
        queryParameters: {
          'query': query,
          'number': limit,
          'offset': offset,
        });

    var completer = Completer<List<ComplexSearchRecipe>>();

    await execute(
        request, ComplexResultsMapper.searchComplexResultsJsonToEntity,
        (result) async {
      if (result != null) {
        completer.complete(result);
      } else {
        completer.complete([]);
      }
    });
    return completer.future;
  }
}
