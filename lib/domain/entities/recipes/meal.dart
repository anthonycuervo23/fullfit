import 'package:isar/isar.dart';
part 'meal.g.dart';

@embedded
class Meal {
  final int? id;
  final String? name;
  final String? image;
  final int? cookingTime;
  final int? servings;
  final String? type;

  Meal({
    this.id,
    this.name,
    this.image,
    this.cookingTime,
    this.servings,
    this.type,
  });
}
