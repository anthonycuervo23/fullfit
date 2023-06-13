import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:isar/isar.dart';

part 'meal_planner.g.dart';

@Collection()
class MealPlanner {
  Id? isarId;
  final DailyMeal monday;
  final DailyMeal tuesday;
  final DailyMeal wednesday;
  final DailyMeal thursday;
  final DailyMeal friday;
  final DailyMeal saturday;
  final DailyMeal sunday;

  MealPlanner({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });
}
