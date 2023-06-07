import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/domain/entities/entities.dart';

class IngredientsInfo extends StatelessWidget {
  final Recipe recipe;
  const IngredientsInfo({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    return SizedBox(
      height: 150.h,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          ...recipe.ingredients.map((ingredient) {
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 250.h,
                          width: 250.w,
                          child: Image.network(
                            ingredient.image,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            ingredient.name,
                            style: textStyles.titleMedium?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (ingredient.name != ingredient.nameClean)
                          Container(
                              alignment: Alignment.center,
                              child: Text("(${ingredient.nameClean})")),
                        SizedBox(height: 20.h),
                        const SizedBox(height: 10),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: textStyles.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            children: [
                              TextSpan(
                                  text: "Amount: ",
                                  style: textStyles.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                              TextSpan(
                                text: ingredient.amount,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h)
                      ],
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(ingredient.image,
                            height: 100.h,
                            width: 100.w,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) =>
                                loadingProgress == null
                                    ? FadeIn(child: child)
                                    : const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                        ),
                                      )),
                      ),
                    ),
                    Container(
                      width: 100.w,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        ingredient.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: textStyles.bodyMedium?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
