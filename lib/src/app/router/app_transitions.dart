// lib/src/app/router/app_transitions.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Define transiciones de página personalizadas para la aplicación.
///
/// Esta clase contiene métodos estáticos que devuelven objetos [CustomTransitionPage].
/// Estos objetos se utilizan comúnmente con paquetes de enrutamiento como
/// `go_router` para aplicar animaciones específicas al navegar entre pantallas,
/// proporcionando una experiencia de usuario más pulida y única.
class AppTransitions {
  // Constructor privado para evitar la instanciación de esta clase de
  //utilidades estáticas.
  AppTransitions._();

  /// Crea una transición de difuminado (fade)
  static CustomTransitionPage<T> fadeTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: curve,
          ),
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// Crea una transición de difuminado con zoom
  static CustomTransitionPage<T> fadeScaleTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1).animate(curvedAnimation),
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }

  /// Crea un GoRoute con transición de difuminado
  static GoRoute fadeRoute({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
    FutureOr<String?> Function(BuildContext, GoRouterState)? redirect,
    List<GoRoute> routes = const <GoRoute>[],
    String? name,
  }) {
    return GoRoute(
      path: path,
      name: name,
      redirect: redirect,
      routes: routes,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return fadeTransition(
          context: context,
          state: state,
          child: builder(context, state),
        );
      },
    );
  }
}
