// lib/src/app/router/app_router.dart

import 'package:bandasybandas/src/app/bloc/auth/auth_bloc.dart';
import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/app/router/app_transitions.dart';
import 'package:bandasybandas/src/app/router/go_router_refresh_stream.dart';
import 'package:bandasybandas/src/features/authentication/presentation/pages/login/login_page.dart';
import 'package:bandasybandas/src/presentation/home/home_page.dart';
import 'package:bandasybandas/src/presentation/not_found/not_found_page.dart';
import 'package:bandasybandas/src/presentation/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (BuildContext context, GoRouterState state) {
        // Accede al estado de autenticación desde AuthBloc
        final authState = authBloc.state;
        final isAuthenticated = authState.status == AuthStatus.authenticated;

        // Lista de rutas públicas que no requieren autenticación
        final publicRoutes = [
          AppRoutes.splash,
          AppRoutes.login,
        ];

        final isGoingToPublicRoute =
            publicRoutes.contains(state.matchedLocation);

        // Si el usuario está autenticado y va a una ruta pública (como login),
        // redirigir a home. Excepto si va a la splash, que es el punto de entrada.
        if (isAuthenticated &&
            isGoingToPublicRoute &&
            state.matchedLocation != AppRoutes.splash) {
          return AppRoutes.home;
        }

        // Si el usuario NO está autenticado y está intentando acceder a una
        // ruta protegida, redirigir a login.
        if (!isAuthenticated && !isGoingToPublicRoute) {
          return AppRoutes.login;
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
  }
}
