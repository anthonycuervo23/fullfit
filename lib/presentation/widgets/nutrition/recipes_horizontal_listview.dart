import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class RecipesHorizontalListview extends StatelessWidget {
  final List<Recipe> recipes;
  const RecipesHorizontalListview({
    super.key,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeCard(recipe: recipe);
        },
      ),
    );
  }
}
