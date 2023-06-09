import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/config/extensions/string_extensions.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class MealPlanScreen extends ConsumerStatefulWidget {
  const MealPlanScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MealPlanScreen> createState() => MealPlanScreenState();
}

class MealPlanScreenState extends ConsumerState<MealPlanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mealPlannerProvider.notifier).getWeekMealPlan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekMealPlan = ref.watch(mealPlannerProvider).weekMealPlan;
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    if (weekMealPlan == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    final Map<String, DailyMeal> dailyMeals = {
      'monday': weekMealPlan.monday,
      'tuesday': weekMealPlan.tuesday,
      'wednesday': weekMealPlan.wednesday,
      'thursday': weekMealPlan.thursday,
      'friday': weekMealPlan.friday,
      'saturday': weekMealPlan.saturday,
      'sunday': weekMealPlan.sunday,
    };

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 24.0.h),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/nutrition');
                        }
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  Text(
                    'Weekly Meal Plan',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              SizedBox(height: 24.0.h),
              for (final day in dailyMeals.entries)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeIn(
                        delay: const Duration(milliseconds: 500),
                        child: Text(
                          day.key.toUpperCase(),
                          style: textStyles.titleMedium?.copyWith(
                              color: colors.primary, fontSize: 18.sp),
                        ),
                      ),
                      for (final meal in day.value.meals!)
                        RecipeTile(meal: meal),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
