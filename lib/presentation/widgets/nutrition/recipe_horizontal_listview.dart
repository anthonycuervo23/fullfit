import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/domain/entities/entities.dart';

class RecipeHorizontalListview extends StatelessWidget {
  final List<Recipe> recipes;
  const RecipeHorizontalListview({
    super.key,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      // child: Column(
      //   children: [
      //     Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return _recipeSlide(recipe, context);
        },
      ),
      // )
      //   ],
      // ),
    );
  }

  Widget _recipeSlide(Recipe recipe, BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return FadeInRight(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              //TODO: mostrar informacion de receta
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
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
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(8),
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child: Container(
                        width: 200,
                        foregroundDecoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Image.network(
                          recipe.image,
                          fit: BoxFit.cover,
                          height: 150.h,
                          loadingBuilder: (context, child, progress) =>
                              progress == null
                                  ? FadeIn(child: child)
                                  : Padding(
                                      padding: EdgeInsets.all(8.0.w),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2.0),
                                      ),
                                    ),
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Padding(
                      padding: EdgeInsets.all(12.0.w),
                      child: Text(
                        recipe.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textStyles.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          // fontSize:
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.all(12.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ready in ${recipe.cookingTime} Min',
                            style: textStyles.bodyMedium?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.timer_outlined,
                            color: colors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
