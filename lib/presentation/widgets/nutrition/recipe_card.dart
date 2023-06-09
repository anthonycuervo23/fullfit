import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:go_router/go_router.dart';

class RecipeCard extends StatelessWidget {
  final Recipe? recipe;
  final Meal? meal;
  const RecipeCard({
    super.key,
    this.recipe,
    this.meal,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return FadeInRight(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (recipe != null) {
                context.push('/nutrition/recipe/${recipe!.id}');
              } else {
                context.push('/nutrition/recipe/${meal!.id}');
              }
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
                          recipe != null ? recipe!.image : meal!.image!,
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
                    Padding(
                      padding: EdgeInsets.all(12.0.w),
                      child: Text(
                        recipe != null ? recipe!.title : meal!.name!,
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
                            recipe != null
                                ? 'Ready in ${recipe!.cookingTime} Min'
                                : 'Ready in ${meal!.cookingTime} Min',
                            style: textStyles.bodyMedium?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.access_time_rounded,
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
