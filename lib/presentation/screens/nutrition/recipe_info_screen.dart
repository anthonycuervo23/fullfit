import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';
import 'package:flutter_html/flutter_html.dart';

class RecipeInfoScreen extends ConsumerStatefulWidget {
  final int recipeId;
  const RecipeInfoScreen({
    Key? key,
    required this.recipeId,
  }) : super(key: key);

  @override
  ConsumerState<RecipeInfoScreen> createState() => RecipeInfoScreenState();
}

class RecipeInfoScreenState extends ConsumerState<RecipeInfoScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(recipeInfoProvider.notifier).loadRecipe(widget.recipeId);
    ref.read(equipmentProvider.notifier).loadEquipment(widget.recipeId);
    ref
        .read(similarRecipesInfoProvider.notifier)
        .loadSimilarRecipes(widget.recipeId);
  }

  Widget _loading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(strokeWidth: 2.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(recipeInfoLoadingProvider);
    if (initialLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    final Recipe? recipe = ref.watch(recipeInfoProvider)[widget.recipeId];
    final List<Equipment> equipment =
        ref.watch(equipmentProvider)[widget.recipeId] ?? [];
    final List<Meal> similarlist =
        ref.watch(similarRecipesInfoProvider)[widget.recipeId] ?? [];
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    if (recipe == null) return _loading();

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          RecipeAppBar(info: recipe),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeIn(
                  delay: const Duration(microseconds: 600),
                  child: Container(
                    padding: const EdgeInsets.all(26.0),
                    child: Text(
                      recipe.title,
                      style: textStyles.titleLarge!.copyWith(fontSize: 26.sp),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 26.0, vertical: 10),
                  child: FadeIn(
                    delay: const Duration(microseconds: 700),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(-2, -2),
                            blurRadius: 12,
                            color: Color.fromRGBO(0, 0, 0, 0.05),
                          ),
                          BoxShadow(
                            offset: Offset(2, 2),
                            blurRadius: 5,
                            color: Color.fromRGBO(0, 0, 0, 0.10),
                          )
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                Text("${recipe.cookingTime} Min",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                Text(
                                  "Ready in",
                                  style: textStyles.bodyMedium!
                                      .copyWith(color: colors.primary),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(recipe.servings.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                Text(
                                  "Servings",
                                  style: textStyles.bodyMedium!
                                      .copyWith(color: colors.primary),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(
                                    '${recipe.nutrients[0].amount.round()} kcal',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                Text(
                                  "Total Calories",
                                  style: textStyles.bodyMedium!
                                      .copyWith(color: colors.primary),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: FadeIn(
                    delay: const Duration(microseconds: 700),
                    child: Text(
                      "Ingredients",
                      style: textStyles.titleMedium!.copyWith(fontSize: 20.sp),
                    ),
                  ),
                ),
                if (recipe.ingredients.isNotEmpty)
                  FadeIn(
                    delay: const Duration(microseconds: 600),
                    child: IngredientsInfo(
                      recipe: recipe,
                    ),
                  ),
                if (recipe.instructions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Instructions",
                          style:
                              textStyles.titleMedium!.copyWith(fontSize: 20.sp),
                        ),
                        const SizedBox(height: 16),
                        Html(
                          data: recipe.instructions,
                          style: {
                            'p': Style(
                              fontSize: FontSize.large,
                            ),
                            'b': Style(color: colors.primary),
                          },
                        ),
                      ],
                    ),
                  ),
                if (equipment.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(26.0),
                    child: Text(
                      "Equipments",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                if (equipment.isNotEmpty)
                  EquipmentsListView(
                    equipments: equipment,
                  ),
                if (recipe.summary.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quick summary",
                          style:
                              textStyles.titleMedium!.copyWith(fontSize: 20.sp),
                        ),
                        const SizedBox(height: 16),
                        Html(
                          data: recipe.summary,
                          style: {
                            'b': Style(color: colors.primary),
                          },
                        ),
                      ],
                    ),
                  ),
                NutrientsInfo(
                  nutrients: recipe.nutrients,
                ),
                const SizedBox(
                  height: 20,
                ),
                if (similarlist.isNotEmpty)
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 26),
                    child: Text("Similar Recipes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                if (similarlist.isNotEmpty)
                  RecipesHorizontalListview(meals: similarlist),
                SizedBox(height: 40.h),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Alert.promtWithOptions(
            context,
            title: '¿Desea agregar esta receta a tu historial de consumo?',
            confirmTitle: 'Agregar',
            cancelTitle: 'Cancelar',
            onConfirm: () {
              ref.read(nutritionTrackingProvider.notifier).addMealToDB(recipe);
            },
            onCancel: () {
              debugPrint('meal not added');
            },
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
