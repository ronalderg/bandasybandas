// lib/src/app/router/app_routes.dart

import 'package:bandasybandas/src/app/bloc/auth/auth_bloc.dart';
import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/app/router/app_transitions.dart';
import 'package:bandasybandas/src/features/authentication/ui/pages/login/login_page.dart';
import 'package:bandasybandas/src/features/inventory_management/inventory_routes.dart';
import 'package:bandasybandas/src/ui/home/home_page.dart';

import 'package:bandasybandas/src/ui/not_found/not_found_page.dart';
import 'package:bandasybandas/src/ui/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  redirect: (BuildContext context, GoRouterState state) {
    final authState = context.read<AuthBloc>().state;
    final isAuthenticated = authState.status == AuthStatus.authenticated;
    final isGoingToLogin = state.matchedLocation == AppRoutes.login;

    // Si el usuario SÍ está autenticado y está intentando ir a login o registro
    if (isAuthenticated && isGoingToLogin) {
      return AppRoutes.home;
    }

    // La protección de rutas individuales ahora se maneja en cada GoRoute.
    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.splash,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashPage();
      },
    ),
    AppTransitions.fadeRoute(
      path: AppRoutes.login,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    AppTransitions.fadeRoute(
      path: AppRoutes.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    ...InventoryRoutes.routes,
  ],
  errorBuilder: (context, state) => const NotFoundPage(),
);
