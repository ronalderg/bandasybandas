import 'package:bandasybandas/src/app/bloc/auth/auth_bloc.dart';
import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/core/theme/app_colors.dart';
import 'package:bandasybandas/src/core/theme/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Cuando el estado de autenticación ya no sea desconocido,
        // navegamos a la ruta de login. go_router se encargará de
        // redirigir a /home si el usuario está autenticado.
        if (state.status != AuthStatus.unknown) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Center(
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(seconds: 2),
            child: Assets.images.logo.image(width: 180),
          ),
        ),
      ),
    );
  }
}
