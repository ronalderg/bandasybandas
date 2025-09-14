// lib/src/presentation/splash/splash_page.dart
import 'dart:async';

import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/core/theme/app_colors.dart';
import 'package:bandasybandas/src/core/theme/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Inicia la animación de fade-in justo después de que se construya el widget.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });

    // Después de una pausa, navega a la pantalla de login.
    // El router se encargará de redirigir al home si el usuario ya está autenticado.
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 2),
          child: Assets.images.logo.image(width: 180),
        ),
      ),
    );
  }
}
