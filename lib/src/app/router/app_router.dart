import 'package:bandasybandas/src/app/bloc/auth/auth_bloc.dart';
import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/app/router/app_transitions.dart';
import 'package:bandasybandas/src/app/router/go_router_refresh_stream.dart';
import 'package:bandasybandas/src/features/authentication/ui/pages/login/login_page.dart';
import 'package:bandasybandas/src/features/customer_profile/customer_profile_routes.dart';
import 'package:bandasybandas/src/features/customers/customers_routes.dart';
import 'package:bandasybandas/src/features/inventory_management/inventory_management_routes.dart';
import 'package:bandasybandas/src/features/orders_management/orders_management_routes.dart';
import 'package:bandasybandas/src/features/technical_service/technical_service_routes.dart';
import 'package:bandasybandas/src/features/users/users_routes.dart';
import 'package:bandasybandas/src/ui/home/home_page.dart';

import 'package:bandasybandas/src/ui/not_found/not_found_page.dart';
import 'package:bandasybandas/src/ui/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static late final GoRouter router;

  static void initialize(AuthBloc authBloc) {
    router = GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (BuildContext context, GoRouterState state) {
        final authStatus = authBloc.state.status;
        final isAuthenticated = authStatus == AuthStatus.authenticated;
        final isCheckingAuth = authStatus == AuthStatus.unknown;
        final location = state.uri.toString();

        final publicRoutes = [AppRoutes.login, AppRoutes.splash];
        final isGoingToPublicRoute = publicRoutes.any(location.startsWith);

        debugPrint('Current location: $location | '
            'authStatus: $authStatus | '
            'isAuthenticated: $isAuthenticated | '
            'isCheckingAuth: $isCheckingAuth | '
            'isGoingToPublicRoute: $isGoingToPublicRoute');

        // Si aún estamos verificando el estado de autenticación,
        // mostramos el splash/loading screen
        if (isCheckingAuth) {
          if (location != AppRoutes.splash) {
            debugPrint('Auth status unknown, showing splash screen');
            return AppRoutes.splash;
          }
          return null; // Ya estamos en splash, no redirigir
        }

        // Si el usuario no está autenticado y no va a una ruta pública,
        // lo redirigimos a login, pero guardando la ruta original.
        if (!isAuthenticated) {
          if (!isGoingToPublicRoute) {
            debugPrint(
                'Not authenticated, redirecting to login from $location');
            return '${AppRoutes.login}?from=$location';
          }
          // Si estamos en splash y no estamos autenticados (y ya no estamos verificando),
          // debemos ir al login.
          if (location == AppRoutes.splash) {
            debugPrint('Not authenticated and in splash, redirecting to login');
            return AppRoutes.login;
          }
        }

        // Si el usuario está autenticado y está en una página pública (login o splash),
        // lo redirigimos a la ruta original (si existe) o a home.
        if (isAuthenticated && isGoingToPublicRoute) {
          final from = state.uri.queryParameters['from'] ?? AppRoutes.home;
          debugPrint('Authenticated, redirecting from $location to $from');
          return from;
        }

        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.splash,
          builder: (BuildContext context, GoRouterState state) =>
              const SplashPage(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (BuildContext context, GoRouterState state) =>
              const LoginPage(),
        ),
        AppTransitions.fadeRoute(
          path: AppRoutes.home,
          builder: (BuildContext context, GoRouterState state) =>
              const HomePage(),
        ),
        ...UsersRoutes.routes,
        ...InventoryRoutes.routes,
        ...CustomersRoutes.routes,
        ...OrdersManagementRoutes.routes,
        ...TechnicalServiceRoutes.routes,
        ...CustomerProfileRoutes.routes,
      ],
      errorBuilder: (context, state) => const NotFoundPage(),
    );
  }
}
