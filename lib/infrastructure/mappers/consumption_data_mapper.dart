import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fullfit_app/domain/entities/entities.dart';

class ConsumptionDataMapper {
  static ConsumptionData snapshotDataToEntity(
    DocumentSnapshot<Object?> snapshot, {
    required double dailyCalories,
    required double dailyProtein,
    required double dailyFat,
    required double dailyCarbs,
  }) {
    return ConsumptionData(
      caloriesConsumed: snapshot.get('calories_consumed'),
      proteinConsumed: snapshot.get('proteins_consumed'),
      carbsConsumed: snapshot.get('carbs_consumed'),
      fatConsumed: snapshot.get('fats_consumed'),
      remainingCalories: dailyCalories - snapshot.get('calories_consumed'),
      remainingProtein: dailyProtein - snapshot.get('proteins_consumed'),
      remainingCarbs: dailyCarbs - snapshot.get('carbs_consumed'),
      remainingFat: dailyFat - snapshot.get('fats_consumed'),
    );
  }
}
