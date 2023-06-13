import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fullfit_app/domain/datasources/datasources.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/infrastructure/mappers/mappers.dart';

class FirebaseWorkoutsDataSource implements WorkoutsDataSource {
  final FirebaseFirestore _firestore;

  FirebaseWorkoutsDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Stream<Workout?> getWorkoutStream(String workoutId) {
    return _firestore
        .collection('userWorkouts')
        .doc(workoutId)
        .snapshots()
        .map((snapshot) {
      return snapshot.data() != null
          ? WorkoutMapper.jsonWorkoutToEntity(snapshot.data()!)
          : null;
    });
  }
}
