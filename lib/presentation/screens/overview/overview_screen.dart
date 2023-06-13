import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/infrastructure/services/services.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/screens/screens.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';
import 'package:intl/intl.dart';

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
      showNutritionDialog();
    });
  }

  void showNutritionDialog() {
    bool hasSeenDialog = const KeyValueStorageServiceImplementation()
            .getValue<bool>(hasSeenNutritionDialogKey) ??
        false;

    if (!hasSeenDialog) {
      final Person person = ref.read(personProvider.notifier).user!;
      final targetCalories = person.targetCalories.round();
      final targetProtein = person.targetProtein.round();
      final targetCarbs = person.targetCarbs.round();
      final targetFat = person.targetFat.round();
      Alert.info(
        context,
        'Nutrition Recomendations',
        'According to your goals, you should consume $targetCalories calories per day\n $targetProtein grams of protein\n $targetCarbs grams of carbs\n $targetFat grams of fat',
        onConfirm: () => const KeyValueStorageServiceImplementation()
            .setKeyValue<bool>(hasSeenNutritionDialogKey, true),
      );
    }
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
              const WorkoutContainer(),
            ],
          ),
        ),
      ],
    );
  }
}

class WorkoutContainer extends ConsumerWidget {
  const WorkoutContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    final streamWorkout = ref.watch(workoutStreamProvider);

    return streamWorkout.when(
        loading: () => const CustomContainer(),
        error: (error, stackTrace) {
          debugPrint(error.toString());
          return const CustomContainer(isLoading: false);
        },
        data: (workout) {
          if (workout != null) {
            return OpenContainer(
              closedElevation: 0,
              transitionType: ContainerTransitionType.fade,
              transitionDuration: const Duration(milliseconds: 1000),
              closedColor: Theme.of(context).scaffoldBackgroundColor,
              openBuilder: (context, _) {
                return const WorkoutDetailsScreen();
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
                              padding: EdgeInsets.only(
                                  top: 16.0.h, left: 16.w, bottom: 20.h),
                              child: Text(
                                'TODAY\'S WORKOUT',
                                style: textStyles.titleMedium?.copyWith(
                                    fontSize: 16.sp, color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: ListView.builder(
                                  itemCount: workout.muscleGroups.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        Text(workout.muscleGroups[index],
                                            style: textStyles.titleMedium
                                                ?.copyWith(
                                                    fontSize: 16.sp,
                                                    color: Colors.white)),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25)),
                                            color: Color(0xFF5B4D9D),
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset(
                                            "assets/icons/${workout.muscleGroups[index].replaceAll(' ', '_').toLowerCase()}.png",
                                            width: 50.w,
                                            height: 50.h,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const CustomContainer();
        });
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
        centerTitle: true,
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
                child: AspectRatio(
                  aspectRatio: 1 / 1, // This forces the child to be a square
                  child: person != null
                      ? Image.network(person.profilePic, fit: BoxFit.cover)
                      : Image.asset("assets/temp/user.jpg", fit: BoxFit.cover),
                ),
              )),
        ),
      ),
    );
  }
}
