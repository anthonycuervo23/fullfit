import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

final nutritionLoadingProvider = Provider<bool>((ref) {
  final isLoading = ref.watch(breakfastRecipesProvider).isEmpty;
  //  ||
  //     ref.watch(drinksRecipesProvider).isEmpty ||
  //     ref.watch(lunchRecipesProvider).isEmpty ||
  //     ref.watch(dessertsRecipesProvider).isEmpty ||
  //     ref.watch(veganRecipesProvider).isEmpty ||
  //     ref.watch(mealPlannerProvider).isLoading;
  return isLoading; //true = still loading / false = all loaded
});
