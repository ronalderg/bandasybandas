import 'package:bandasybandas/src/app/bloc/auth/auth_bloc.dart';
import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/app/router/app_transitions.dart';
import 'package:bandasybandas/src/app/router/go_router_refresh_stream.dart';
import 'package:bandasybandas/src/features/authentication/ui/pages/login/login_page.dart';
import 'package:bandasybandas/src/features/customers/customers_routes.dart';
import 'package:bandasybandas/src/features/inventory_management/inventory_routes.dart';
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
        final isAuthenticated =
            authBloc.state.status == AuthStatus.authenticated;
        final location = state.matchedLocation;

        final publicRoutes = [AppRoutes.login, AppRoutes.splash];

        if (!isAuthenticated && !publicRoutes.contains(location)) {
          return AppRoutes.login;
        }

        if (isAuthenticated && publicRoutes.contains(location)) {
          return AppRoutes.home;
        }

        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.splash,
          builder: (BuildContext context, GoRouterState state) =>
              const SplashPage(),
        ),
        AppTransitions.fadeRoute(
          path: AppRoutes.login,
          builder: (BuildContext context, GoRouterState state) =>
              const LoginPage(),
        ),
        AppTransitions.fadeRoute(
          path: AppRoutes.home,
          builder: (BuildContext context, GoRouterState state) =>
              const HomePage(),
        ),
        ...InventoryRoutes.routes,
        ...CustomersRoutes.routes,
        ...UsersRoutes.routes,
      ],
      errorBuilder: (context, state) => const NotFoundPage(),
    );
  }
}
