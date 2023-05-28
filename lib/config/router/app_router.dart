import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/config/router/app_router_notifier.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GlobalKey<NavigatorState> _sectionNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionNav');

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.watch(goRouterNotifierProvider);

  return GoRouter(
      refreshListenable: goRouterNotifier,
      navigatorKey: _rootNavigatorKey,
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
              isGoingTo == '/register' ||
              isGoingTo == '/intro') {
            return null;
          }
          return '/intro';
        }

        if (authStatus == AuthStatus.authenticated) {
          if (isGoingTo == '/login' ||
              isGoingTo == '/register' ||
              isGoingTo == '/splash' ||
              isGoingTo == '/intro') {
            return '/';
          }
        }

        return null;
      });
});
