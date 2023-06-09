import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:go_router/go_router.dart';

class RecipeTile extends StatelessWidget {
  final Recipe? recipe;
  final Meal? meal;
  const RecipeTile({super.key, this.recipe, this.meal});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    return FadeInUp(
      delay: const Duration(microseconds: 600),
      child: GestureDetector(
        onTap: () {
          if (recipe != null) {
            context.push('/nutrition/recipe/${recipe!.id}');
          } else {
            context.push('/nutrition/recipe/${meal!.id}');
          }
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
              height: recipe != null ? 100.h : 110.h,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 100.h,
                      width: 170,
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
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.network(
                            recipe != null ? recipe!.image : meal!.image!,
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
                          meal != null
                              ? Text(
                                  meal!.type!,
                                  style: textStyles.bodySmall?.copyWith(
                                      color: colors.primary.withOpacity(0.5),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700),
                                )
                              : Container(),
                          Text(
                            recipe != null ? recipe!.title : meal!.name!,
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
                                recipe != null
                                    ? 'Ready in ${recipe!.cookingTime} Min'
                                    : 'Ready in ${meal!.cookingTime} Min',
                                style: textStyles.bodyMedium?.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.access_time,
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
