import 'package:flutter/material.dart';
import 'package:fullfit_app/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GlobalKey<NavigatorState> _sectionNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionNav');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    //* primera pantalla
    GoRoute(
      path: '/splash',
      builder: (context, state) => const CheckAuthStatusScreen(),
    ),

    //* Rutas de autenticación
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
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
              path: '/',
              builder: (context, state) => const WorkoutsScreen(),
            ),
          ],
        ),

        //* Rutas del segundo tab (nutrition)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/nutrition',
              builder: (context, state) => const NutritionScreen(),
            ),
          ],
        ),

        //* Rutas del tercer tab (profile)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    //* Rutas que van fuera del bottom navigation bar
  ],
);
