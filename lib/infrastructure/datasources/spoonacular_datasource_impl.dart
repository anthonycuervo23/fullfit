import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:fullfit_app/config/api/api_client.dart';
import 'package:fullfit_app/config/config.dart';
import 'package:fullfit_app/domain/datasources/datasources.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/infrastructure/mappers/mappers.dart';
import 'package:fullfit_app/infrastructure/services/services.dart';

class SpoonacularDataSourceImpl extends RecipesDataSource {
  final KeyValueStorageService _storageService;
  final LocalStorageDataSource _localStorageDataSource;
  SpoonacularDataSourceImpl({
    KeyValueStorageService storageService =
        const KeyValueStorageServiceImplementation(),
    required LocalStorageDataSource localStorageDataSource,
  })  : _storageService = storageService,
        _localStorageDataSource = localStorageDataSource,
        super('https://api.spoonacular.com',
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
      } else {
        throw Exception('Unexpected response type');
      }
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
  Future<void> getTodayMealPlan(Future Function(DailyMeal? mealPlanner) closure,
      {int targetCalories = 2000}) async {
    if (await _hasWeekPassed()) {
      debugPrint('👨🏻‍💻 Generando un nuevo Plan Semanal');
      //si ha pasado una semana desde el último plan de comidas, obtenemos uno nuevo plan de comidas
      var request = build(
          endpoint: '/mealplanner/generate',
          requestType: RequestType.get,
          queryParameters: {
            'timeFrame': 'week',
            'targetCalories': targetCalories,
          });

      await execute(request, MealPlannerMapper.mealPlannerJsonToEntity,
          (result) async {
        if (result != null) {
          final date = DateTime.now().toIso8601String();
          //guardamos la fecha de cuando se generó el plan de comidas
          _storageService.setKeyValue<String>(mealPlanDateKey, date);
          //guardamos el plan de comidas en el almacenamiento local
          await _localStorageDataSource.saveWeekPlan(result);

          final DailyMeal todaysMealPlan = _getTodayMealPlan(result);

          await closure(todaysMealPlan);
        } else {
          debugPrint('👨🏻‍💻 Error generando nuevo Plan Semanal');
          await closure(null);
        }
      });
    } else {
      debugPrint('👨🏻‍💻 Obteniendo plan semanal desde la BD');
      //si no ha pasado una semana, obtenemos el plan de comidas guardado en el almacenamiento local
      final mealPlan = await _localStorageDataSource.getWeeklyMealPlan();

      if (mealPlan != null) {
        final DailyMeal todaysMealPlan = _getTodayMealPlan(mealPlan);
        await closure(todaysMealPlan);
      } else {
        debugPrint('👨🏻‍💻 Error obteniendo plan desde la BD');
        await closure(null);
      }
    }
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

  @override
  Future<MealPlanner?> getWeekMealPlan() {
    //obtenemos el plan de comidas guardado en el almacenamiento local
    return _localStorageDataSource.getWeeklyMealPlan();
  }

  @override
  Future<void> getEquipmentInfo(
      int id, Future Function(List<Equipment>? equipment) closure) async {
    var request = build(
        endpoint: '/recipes/$id/equipmentWidget.json',
        requestType: RequestType.get);

    await execute(request, EquipmentMapper.equipmentJsonToEntityList,
        (result) async {
      if (result != null) {
        closure(result);
      } else {
        closure([]);
      }
    });
  }

  @override
  Future<void> getSimilarRecipes(
      int id, Future Function(List<Meal>? recipes) closure) async {
    var request =
        build(endpoint: '/recipes/$id/similar', requestType: RequestType.get);

    await execute(request, RecipeMapper.similarRecipesToEntityList,
        (result) async {
      if (result != null) {
        closure(result);
      } else {
        closure([]);
      }
    });
  }

  @override
  Future<void> addMealToDB(Future Function(bool success) closure,
      {required String userId, required Recipe recipe}) async {
    final DateTime now = DateTime.now();
    final String date = '${now.year}-${now.month}-${now.day}';

    try {
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('DailyConsumption')
          .doc(date);

      double calories = 0.0;
      double protein = 0.0;
      double fat = 0.0;
      double carbs = 0.0;

      for (final nutrient in recipe.nutrients) {
        switch (nutrient.name) {
          case 'Calories':
            calories = nutrient.amount;
            break;
          case 'Protein':
            protein = nutrient.amount;
            break;
          case 'Fat':
            fat = nutrient.amount;
            break;
          case 'Carbohydrates':
            carbs = nutrient.amount;
            break;
          default:
            break;
        }
      }

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          debugPrint("👨🏻‍💻 Document does not exist, creating new one...");
          transaction.set(docRef, {
            'calories_consumed': calories,
            'proteins_consumed': protein,
            'fats_consumed': fat,
            'carbs_consumed': carbs,
            'meals': [
              {
                'name': recipe.title,
                'calories': calories,
                'protein': protein,
                'fat': fat,
                'carbs': carbs
              }
            ]
          });
        } else {
          debugPrint("👨🏻‍💻 Document exists, checking for duplicates...");
          List meals = snapshot.get('meals');
          for (var meal in meals) {
            if (meal['name'] == recipe.title) {
              debugPrint('Meal already exists, not updating');
              closure(false);
              return;
            }
          }
          debugPrint('Meal does not exist, updating');
          transaction.update(docRef, {
            'calories_consumed': snapshot.get('calories_consumed') + calories,
            'proteins_consumed': snapshot.get('proteins_consumed') + protein,
            'fats_consumed': snapshot.get('fats_consumed') + fat,
            'carbs_consumed': snapshot.get('carbs_consumed') + carbs,
            'meals': FieldValue.arrayUnion([
              {
                'name': recipe.title,
                'calories': calories,
                'protein': protein,
                'fat': fat,
                'carbs': carbs
              }
            ])
          });
        }
      });

      closure(true);
    } catch (e) {
      debugPrint(e.toString());
      closure(false);
    }
  }

  @override
  Stream<ConsumptionData?> getNutrients(
      {required String userId,
      required double dailyCalories,
      required double dailyProtein,
      required double dailyFat,
      required double dailyCarbs}) {
    final DateTime now = DateTime.now();
    final String date = '${now.year}-${now.month}-${now.day}';

    try {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('DailyConsumption')
          .doc(date)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          return ConsumptionDataMapper.snapshotDataToEntity(
            snapshot,
            dailyCalories: dailyCalories,
            dailyProtein: dailyProtein,
            dailyFat: dailyFat,
            dailyCarbs: dailyCarbs,
          );
        } else {
          return ConsumptionData(
            caloriesConsumed: 0,
            proteinConsumed: 0,
            carbsConsumed: 0,
            fatConsumed: 0,
            remainingCalories: dailyCalories,
            remainingProtein: dailyProtein,
            remainingCarbs: dailyCarbs,
            remainingFat: dailyFat,
          );
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      return const Stream.empty();
    }
  }
}

extension SpoonacularDataSourceImplExtension on SpoonacularDataSourceImpl {
  // Esta función verifica si ha pasado una semana desde el último plan de comidas.
  Future<bool> _hasWeekPassed() async {
    final lastMealPlanDateString =
        _storageService.getValue<String>(mealPlanDateKey);

    if (lastMealPlanDateString == null) {
      debugPrint('👨🏻‍💻 No meal plan date found');
      return true; // no hay un plan de comidas guardado, por lo que asumimos que ha pasado una semana
    }

    final lastMealPlanDate = DateTime.parse(lastMealPlanDateString);
    final now = DateTime.now();
    final difference = now.difference(lastMealPlanDate);
    debugPrint(
        '👨🏻‍💻 ha pasado mas de una semana: ${difference.inDays >= 7}');
    return difference.inDays >= 7;
  }

  DailyMeal _getTodayMealPlan(MealPlanner mealPlanner) {
    var weekday = DateTime.now().weekday;
    switch (weekday) {
      case 1:
        debugPrint('👨🏻‍💻 Obteniendo plan para el LUNES');
        return mealPlanner.monday;
      case 2:
        debugPrint('👨🏻‍💻 Obteniendo plan para el MARTES');
        return mealPlanner.tuesday;
      case 3:
        debugPrint('👨🏻‍💻 Obteniendo plan para el MIERCOLES');
        return mealPlanner.wednesday;
      case 4:
        debugPrint('👨🏻‍💻 Obteniendo plan para el JUEVES');
        return mealPlanner.thursday;
      case 5:
        debugPrint('👨🏻‍💻 Obteniendo plan para el VIERNES');
        return mealPlanner.friday;
      case 6:
        debugPrint('👨🏻‍💻 Obteniendo plan para el SABADO');
        return mealPlanner.saturday;
      case 7:
        debugPrint('👨🏻‍💻 Obteniendo plan para el DOMINGO');
        return mealPlanner.sunday;
      default:
        throw Exception("Invalid weekday");
    }
  }
}
