import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class NutritionScreen extends ConsumerStatefulWidget {
  const NutritionScreen({Key? key}) : super(key: key);

  @override
  NutritionScreenState createState() => NutritionScreenState();
}

class NutritionScreenState extends ConsumerState<NutritionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(breakfastRecipesProvider.notifier).loadRecipes();
      // ref.read(drinksRecipesProvider.notifier).loadRecipes();
      // ref.read(lunchRecipesProvider.notifier).loadRecipes();
      // ref.read(dessertsRecipesProvider.notifier).loadRecipes();
      // ref.read(veganRecipesProvider.notifier).loadRecipes();
      // ref.read(mealPlannerProvider.notifier).loadTodaysMealPlan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(nutritionLoadingProvider);
    if (initialLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    final breakfastRecipes = ref.watch(breakfastRecipesProvider);
    // final drinksRecipes = ref.watch(drinksRecipesProvider);
    // final lunchRecipes = ref.watch(lunchRecipesProvider);
    // final dessertRecipes = ref.watch(dessertsRecipesProvider);
    // final vegaRecipes = ref.watch(veganRecipesProvider);
    // final todaysMealPlan = ref.watch(mealPlannerProvider);

    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 24.0.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: Text(
                  'what would you like to cook today?',
                  style: textStyles.titleMedium,
                ),
              ),
              //TODO: cambiar esto por un search bar de verdad
              //* Search bar
              Container(
                margin:
                    EdgeInsets.symmetric(vertical: 6.0.h, horizontal: 16.0.w),
                padding:
                    EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 16.0.w),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: colors.tertiary,
                      size: 34.0.w,
                    ),
                    hintText: 'Search for recipes',
                    hintStyle: textStyles.bodyMedium?.copyWith(
                      color: colors.tertiary,
                      fontSize: 20.0.sp,
                    ),
                  ),
                ),
              ),
              //* FIN search bar
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomHeader(
                        title: 'Popular Breakfast Recipes', name: 'breakfast'),
                    RecipeHorizontalListview(recipes: breakfastRecipes),
                  ],
                ),
              ),
              // todayPlan(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _todayPlan() {
    final state = ref.watch(mealPlannerProvider);

    final textStyles = Theme.of(context).textTheme;
    Locale myLocale = Localizations.localeOf(context);
    List<Map<String, dynamic>> eatZone = [
      {
        'image': 'assets/temp/Breakfast.png',
        'title': 'Breakfast',
        'time': '8:00AM - 8.30AM',
      },
      {
        'image': 'assets/temp/Lunch.png',
        'title': 'Lunch',
        'time': '12.30PM - 1.00PM',
      },
      {
        'image': 'assets/temp/Snacks.png',
        'title': 'Snacks',
        'time': '5.00PM - 5.30PM',
      },
      {
        'image': 'assets/temp/Dinner.png',
        'title': 'Dinner',
        'time': '7:00PM - 7.30PM',
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Today\'s Plan',
            style: textStyles.titleMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          alignment: Alignment.center,
          height: 195,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.mealPlanner?.meals.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: myLocale == const Locale('ar')
                      ? index == 0
                          ? const EdgeInsets.only(left: 20, right: 20)
                          : const EdgeInsets.only(left: 20)
                      : index == eatZone.length - 1
                          ? const EdgeInsets.only(left: 20, right: 20)
                          : const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 187,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, '/breakFastScreen'),
                              child: Container(
                                height: 155,
                                width: 263,
                                decoration: BoxDecoration(
                                  color: Color(0xff005662),
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: NetworkImage(
                                      state.mealPlanner!.meals[index].image,
                                    ),
                                    // image: AssetImage(
                                    //   eatZone[index]['image'],
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 50,
                              child: GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, '/breakFastScreen'),
                                child: Container(
                                  height: 64,
                                  width: 162,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: const [
                                        BoxShadow(
                                            blurRadius: 5,
                                            spreadRadius: 0,
                                            offset: Offset(0, 0),
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.25)),
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(state.mealPlanner!.meals[index].name,
                                          // Text(eatZone[index]['title'],
                                          style: textStyles.subtitle1?.copyWith(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          )),
                                      Text(
                                        state.mealPlanner!.meals[index]
                                            .cookingTime
                                            .toString(),
                                        // eatZone[index]['time'],
                                        style: textStyles.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}
