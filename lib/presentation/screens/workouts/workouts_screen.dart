import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';
import 'package:intl/intl.dart';

//TODO: mostrar dialogo con la cantidad de nutrientes sugeridas, solo la primera vez que se inicia la app

class WorkoutsScreen extends ConsumerStatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  WorkoutsScreenState createState() => WorkoutsScreenState();
}

class WorkoutsScreenState extends ConsumerState<WorkoutsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mealPlannerProvider.notifier).loadTodaysMealPlan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final todaysMealPlan = ref.watch(mealPlannerProvider).mealPlanner;

    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    final today = DateTime.now();

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        HomeAppBar(colors: colors, today: today, textStyles: textStyles),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              PersonNutritionProgress(colors: colors),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 20.h),
                child: Text(
                  'MEALS FOR TODAY',
                  style: textStyles.titleMedium?.copyWith(fontSize: 16.sp),
                ),
              ),
              MealPlanSwiper(meals: todaysMealPlan?.meals ?? []),
              const SizedBox(height: 20),
              OpenContainer(
                closedElevation: 0,
                transitionType: ContainerTransitionType.fade,
                transitionDuration: const Duration(milliseconds: 1000),
                closedColor: Colors.transparent,
                openBuilder: (context, _) {
                  //TODO: open workout details
                  return Container();
                },
                closedBuilder: (context, VoidCallback openContainer) {
                  return GestureDetector(
                    onTap: openContainer,
                    child: FadeInUp(
                      child: Container(
                        margin: const EdgeInsets.only(
                            bottom: 10, left: 32, right: 32),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          color: colors.primary.withOpacity(0.8),
                        ),
                        child: SizedBox(
                          height: 180.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(width: 20),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 16.0.h, left: 16.w),
                                child: Text(
                                  'YOUR NEXT WORKOUT',
                                  style: textStyles.titleMedium
                                      ?.copyWith(fontSize: 16.sp),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4.0, left: 16),
                                child: Text(
                                  'Upper Body',
                                  style: textStyles.titleLarge
                                      ?.copyWith(fontSize: 24.sp),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(width: 20),
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        color: Color(0xFF5B4D9D),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        "assets/temp/chest.png",
                                        width: 50,
                                        height: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        color: Color(0xFF5B4D9D),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        "assets/temp/back.png",
                                        width: 50,
                                        height: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        color: Color(0xFF5B4D9D),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        "assets/temp/biceps.png",
                                        width: 50,
                                        height: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PersonNutritionProgress extends ConsumerWidget {
  const PersonNutritionProgress({
    super.key,
    required this.colors,
  });

  final ColorScheme colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ConsumptionData? consumptionData =
        ref.watch(nutritionTrackingProvider).consumptionData;

    final person = ref.watch(personProvider.notifier).user;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(40),
      ),
      child: Container(
        height: 200.w,
        color: colors.surface,
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                RadialProgress(
                  width: 140.w,
                  height: 140.w,
                  progress: (consumptionData?.caloriesConsumed ?? 0) /
                      (person?.targetCalories ?? 2000),
                  leftAmount: (consumptionData?.remainingCalories ?? 0).round(),
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    NutrientesProgressBar(
                      ingredient: 'Protein',
                      progress: (consumptionData?.proteinConsumed ?? 0) /
                          (person?.targetProtein ?? 200),
                      progressColor: Colors.green,
                      leftAmount:
                          (consumptionData?.remainingProtein ?? 0).round(),
                      width: 100.w,
                    ),
                    const SizedBox(height: 10),
                    NutrientesProgressBar(
                      ingredient: 'Carbs',
                      progress: (consumptionData?.carbsConsumed ?? 0) /
                          (person?.targetCarbs ?? 200),
                      progressColor: Colors.red,
                      leftAmount:
                          (consumptionData?.remainingCarbs ?? 0).round(),
                      width: 100.w,
                    ),
                    const SizedBox(height: 10),
                    NutrientesProgressBar(
                      ingredient: 'Fat',
                      progress: (consumptionData?.fatConsumed ?? 0) /
                          (person?.targetFat ?? 200),
                      progressColor: Colors.yellow,
                      leftAmount: (consumptionData?.remainingFat ?? 0).round(),
                      width: 100.w,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({
    super.key,
    required this.colors,
    required this.today,
    required this.textStyles,
  });

  final ColorScheme colors;
  final DateTime today;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final person = ref.watch(personProvider.notifier).user;

    return SliverAppBar(
      backgroundColor: colors.surface,
      floating: true,
      toolbarHeight: 70.h,
      expandedHeight: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: SafeArea(
          bottom: false,
          child: ListTile(
            dense: true,
            title: Text(
                '${DateFormat("EEEE").format(today)}, ${DateFormat("d MMMM").format(today)}',
                style: textStyles.bodyLarge?.copyWith(fontSize: 16.sp)),
            subtitle: Text(
              'Hello, ${person?.name ?? 'User'}',
              style: textStyles.titleMedium,
            ),
            trailing: ClipOval(
                child: person != null
                    ? Image.network(person.profilePic)
                    : Image.asset("assets/temp/user.jpg")),
          ),
        ),
      ),
    );
  }
}
