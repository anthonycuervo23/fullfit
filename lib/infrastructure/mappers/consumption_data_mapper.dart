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
      caloriesConsumed: snapshot.get('caloriesConsumed'),
      proteinConsumed: snapshot.get('proteinsConsumed'),
      carbsConsumed: snapshot.get('carbsConsumed'),
      fatConsumed: snapshot.get('fatsConsumed'),
      remainingCalories: dailyCalories - snapshot.get('caloriesConsumed'),
      remainingProtein: dailyProtein - snapshot.get('proteinsConsumed'),
      remainingCarbs: dailyCarbs - snapshot.get('carbsConsumed'),
      remainingFat: dailyFat - snapshot.get('fatsConsumed'),
    );
  }
}
