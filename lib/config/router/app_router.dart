import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/config/router/app_router_notifier.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GlobalKey<NavigatorState> _sectionNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionNav');

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
      refreshListenable: goRouterNotifier,
      navigatorKey: rootNavigatorKey,
      initialLocation: '/splash',
      routes: [
        //* primera pantalla
        GoRoute(
          path: '/splash',
          builder: (context, state) => const CheckAuthStatusScreen(),
        ),

        //* Pantalla de introducción
        GoRoute(
          path: '/intro',
          builder: (context, state) => const IntroScreen(),
        ),
        //* Rutas de onboarding
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnBoardingScreen(),
        ),
        GoRoute(
          path: '/ready-to-go',
          builder: (context, state) => const ReadyToGoScreen(),
        ),

        //* Rutas de autenticación
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),

        //* Rutas de la app
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainScreen(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: _sectionNavigatorKey,
              routes: [
                //* Rutas del primer tab (workouts)
                GoRoute(
                  path: '/workouts',
                  builder: (context, state) => const WorkoutsScreen(),
                  // routes: [
                  // GoRoute(
                  //   path: 'recipe/:id',
                  //   builder: (context, state) {
                  //     final recipeId = state.pathParameters['id'] ?? 'no-id';
                  //     return RecipeInfoScreen(
                  //         recipeId: int.tryParse(recipeId) ?? 0);
                  //   },
                  // ),
                  // ],
                ),
              ],
            ),

            //* Rutas del segundo tab (nutrition)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/nutrition',
                  builder: (context, state) => const NutritionScreen(),
                  routes: [
                    GoRoute(
                      path: 'recipe/:id',
                      builder: (context, state) {
                        final recipeId = state.pathParameters['id'] ?? 'no-id';
                        return RecipeInfoScreen(
                            recipeId: int.tryParse(recipeId) ?? 0);
                      },
                    ),
                    GoRoute(
                      path: 'suggestions/:name',
                      builder: (context, state) {
                        final foodType =
                            state.pathParameters['name'] ?? 'no-name';
                        return SuggestedRecipesScreen(foodType: foodType);
                      },
                    ),
                    GoRoute(
                      path: 'mealplan',
                      builder: (context, state) {
                        // final foodType =
                        //     state.pathParameters['name'] ?? 'no-name';
                        return const MealPlanScreen();
                      },
                    ),
                  ],
                ),
              ],
            ),

            //* Rutas del tercer tab (profile)
            StatefulShellBranch(
              routes: [
                GoRoute(
                    path: '/profile',
                    builder: (context, state) => const ProfileScreen(),
                    routes: [
                      // GoRoute(
                      //   path: 'edit',
                      //   builder: (context, state) => const EditProfileScreen(),
                      // ),
                      GoRoute(
                        path: 'chatbot',
                        builder: (context, state) => const ChatBotScreen(),
                      ),
                    ]),
              ],
            ),
          ],
        ),

        //* Rutas que van fuera del bottom navigation bar
      ],
      //* Bloquear si no se está autenticado
      redirect: (context, state) {
        final isGoingTo = state.matchedLocation;
        final authStatus = goRouterNotifier.authStatus;

        debugPrint('route: $isGoingTo');

        if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
          return null;
        }

        if (authStatus == AuthStatus.unauthenticated) {
          if (isGoingTo == '/login' ||
              isGoingTo == '/onboarding' ||
              isGoingTo == '/intro') {
            return null;
          }
          return '/intro';
        }

        if (authStatus == AuthStatus.missingData) {
          if (isGoingTo == '/onboarding') {
            return null;
          }
          return '/onboarding';
        }

        if (authStatus == AuthStatus.readyToGo) {
          if (isGoingTo == '/ready-to-go') {
            return null;
          }
          return '/ready-to-go';
        }

        if (authStatus == AuthStatus.authenticated) {
          // check if user completed onboarding
          if (isGoingTo == '/login' ||
              isGoingTo == '/onboarding' ||
              isGoingTo == '/splash' ||
              isGoingTo == '/intro' ||
              isGoingTo == '/ready-to-go') {
            return '/workouts';
          }
        }
        return null;
      });
});
