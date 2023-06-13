import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/nutrition/search_recipes_provider.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/shared/search_bar.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class NutritionScreen extends ConsumerStatefulWidget {
  const NutritionScreen({Key? key}) : super(key: key);

  @override
  NutritionScreenState createState() => NutritionScreenState();
}

class NutritionScreenState extends ConsumerState<NutritionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mealPlannerProvider.notifier).loadTodaysMealPlan();
      ref.read(breakfastRecipesProvider.notifier).loadRecipes();
      ref.read(lunchRecipesProvider.notifier).loadRecipes();
      ref.read(drinksRecipesProvider.notifier).loadRecipes();
      ref.read(veganRecipesProvider.notifier).loadRecipes();
      ref.read(dessertsRecipesProvider.notifier).loadRecipes();
      ref.read(pastaRecipesProvider.notifier).loadRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(nutritionLoadingProvider);
    if (initialLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    final breakfastRecipes = ref.watch(breakfastRecipesProvider);
    final drinksRecipes = ref.watch(drinksRecipesProvider);
    final pastaRecipes = ref.watch(pastaRecipesProvider);
    final lunchRecipes = ref.watch(lunchRecipesProvider);
    final dessertRecipes = ref.watch(dessertsRecipesProvider);
    final vegaRecipes = ref.watch(veganRecipesProvider);
    final todaysMealPlan = ref.watch(mealPlannerProvider).mealPlanner;

    final textStyles = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.0.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: SizedBox(
                  width: 240.w,
                  child: Text(
                    'Food Recipes Made For You',
                    style: textStyles.titleMedium,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 20.0.h, horizontal: 16.0.w),
                child: SearchRecipes(
                  searchRecipes:
                      ref.read(recipesRepositoryProvider).searchRecipes,
                  initialRecipes:
                      ref.read(searchedRecipesProvider).searchedRecipes,
                  onRecipeSelected: (recipe) {
                    context.push('/nutrition/recipe/${recipe.id}');
                  },
                ),
              ),
              CustomHeader(
                title: 'Your Meal Plan for Today',
                onPressed: () {
                  context.push('/nutrition/mealplan');
                },
              ),
              MealPlanSwiper(meals: todaysMealPlan?.meals ?? []),
              SizedBox(height: 20.h),
              const CustomHeader(
                  title: 'Popular Breakfast Recipes', name: 'breakfast'),
              RecipesHorizontalListview(recipes: breakfastRecipes),
              const CustomHeader(title: 'Best Lunch Recipes', name: 'lunch'),
              RecipesVerticalListview(recipes: lunchRecipes),
              const CustomHeader(title: 'Popular Drinks', name: 'drinks'),
              RecipesHorizontalListview(recipes: drinksRecipes),
              const CustomHeader(title: 'Best Vegan Recipes', name: 'vegan'),
              RecipesVerticalListview(recipes: vegaRecipes),
              const CustomHeader(
                  title: 'Delicious Desserts Recipes', name: 'desserts'),
              RecipesHorizontalListview(recipes: dessertRecipes),
              const CustomHeader(title: 'Popular Pasta Recipes', name: 'pasta'),
              RecipesVerticalListview(recipes: pastaRecipes),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
