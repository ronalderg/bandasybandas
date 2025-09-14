// lib/src/app/router/app_routes.dart

import 'package:bandasybandas/src/app/bloc/auth/auth_bloc.dart';
import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/app/router/app_transitions.dart';
import 'package:bandasybandas/src/features/authentication/presentation/pages/login/login_page.dart';
import 'package:bandasybandas/src/presentation/home/home_page.dart';

import 'package:bandasybandas/src/presentation/not_found/not_found_page.dart';
import 'package:bandasybandas/src/presentation/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  redirect: (BuildContext context, GoRouterState state) {
    // Accede al estado de autenticación desde AuthBloc
    final authState = context.read<AuthBloc>().state;
    final isAuthenticated = authState.status == AuthStatus.authenticated;

    // Lista de rutas públicas que no requieren autenticación
    final publicRoutes = [
      AppRoutes.splash,
      AppRoutes.login,
    ];

    // Si estamos en una ruta pública, no redirigir
    if (publicRoutes.contains(state.matchedLocation)) {
      return null;
    }

    // Si el usuario NO está autenticado y está intentando
    //acceder a una ruta protegida
    if (!isAuthenticated) {
      return AppRoutes.login;
    }

    // Si el usuario SÍ está autenticado y está intentando ir a login o registro
    if (isAuthenticated && (state.matchedLocation == AppRoutes.login)) {
      return AppRoutes.home;
    }

    // En cualquier otro caso, no se necesita redirección
    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.splash,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashPage();
      },
    ),
    // AppTransitions.fadeRoute(
    //   path: AppRoutes.splash,
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const SplashPage();
    //   },
    // ),
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
  ],
  errorBuilder: (context, state) => const NotFoundPage(),
);
