import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class RecipesHorizontalListview extends StatelessWidget {
  final List<Recipe>? recipes;
  final List<Meal>? meals;
  const RecipesHorizontalListview({
    super.key,
    this.recipes,
    this.meals,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: recipes?.length ?? meals!.length,
        itemBuilder: (context, index) {
          final recipe = recipes?[index];
          final meal = meals?[index];
          return RecipeCard(recipe: recipe, meal: meal);
        },
      ),
    );
  }
}
