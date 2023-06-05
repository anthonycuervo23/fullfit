import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/infrastructure/datasources/datasources.dart';
import 'package:fullfit_app/infrastructure/repositories/repositories.dart';

final recipesRepositoryProvider = Provider(
  (ref) => RecipesRepositoryImpl(SpoonacularDataSourceImpl()),
);
