import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/domain/entities/entities.dart';

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
        return _recipeTile(recipe, context);
      },
      // ),
    );
  }

  Widget _recipeTile(Recipe recipe, BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    return FadeInUp(
      delay: const Duration(microseconds: 600),
      child: GestureDetector(
        onTap: () {
          //TODO: navegar a la pantalla de receta
        },
        child: Padding(
          padding: EdgeInsets.all(8.0.w),
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
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              height: 100.h,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 100.h,
                      width: 170,
                      decoration: BoxDecoration(
                        color: Colors.grey,
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
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.network(
                            recipe.image,
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
                          ).image,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 18.h, vertical: 8.0.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textStyles.titleSmall!.copyWith(
                                fontWeight: FontWeight.w700, fontSize: 16.sp),
                          ),
                          const Spacer(),
                          Row(
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
