import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

final recipeInfoLoadingProvider = Provider<bool>((ref) {
  final isLoading = ref.watch(recipeInfoProvider).isEmpty ||
      ref.watch(similarRecipesInfoProvider).isEmpty ||
      ref.watch(equipmentProvider).isEmpty;
  return isLoading; //true = still loading / false = all loaded
});
