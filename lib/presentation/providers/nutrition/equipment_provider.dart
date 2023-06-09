import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

final equipmentProvider =
    StateNotifierProvider<EquipmentMapNotifier, Map<int, List<Equipment>>>(
        (ref) {
  final recipesRepository = ref.watch(recipesRepositoryProvider);

  return EquipmentMapNotifier(getEquipment: recipesRepository.getEquipmentInfo);
});

typedef GetEquipmentCallback = Future<void> Function(
    int id, Future Function(List<Equipment>? equipment) closure);

class EquipmentMapNotifier extends StateNotifier<Map<int, List<Equipment>>> {
  final GetEquipmentCallback _getEquipment;
  EquipmentMapNotifier({required getEquipment})
      : _getEquipment = getEquipment,
        super({});

  Future<void> loadEquipment(int recipeId) async {
    if (state[recipeId] != null) {
      debugPrint(' 🤖 Equipment loaded from cache');
      return;
    }

    await _getEquipment(recipeId, (equipments) async {
      if (equipments != null && equipments.isNotEmpty) {
        state = {...state, recipeId: equipments};
      }
    });
  }
}
