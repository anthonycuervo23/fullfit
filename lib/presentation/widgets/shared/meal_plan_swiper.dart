import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class MealPlanSwiper extends ConsumerWidget {
  final List<Meal> meals;
  const MealPlanSwiper({
    super.key,
    required this.meals,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 255.h,
      width: double.infinity,
      child: Swiper(
        index: 1,
        loop: false,
        itemCount: meals.length,
        viewportFraction: 0.65,
        scale: 0.65,
        itemBuilder: (context, index) {
          final meal = meals[index];
          return MealCard(meal: meal);
        },
      ),
    );
  }
}
