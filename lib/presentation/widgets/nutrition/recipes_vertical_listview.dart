import 'package:flutter/material.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class RecipesVerticalListview extends StatelessWidget {
  final List<Recipe> recipes;
  const RecipesVerticalListview({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return RecipeTile(recipe: recipe);
      },
      // ),
    );
  }
}
