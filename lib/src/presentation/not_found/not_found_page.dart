// lib/src/presentation/not_found/not_found_page.dart
import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: AppSpacing.horizontalPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Oops!',
                style: textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              AppSpacing.verticalGapMd,
              Text(
                '404 - Página no encontrada',
                style: textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalGapSm,
              Text(
                'La página que buscas no existe o ha sido movida.',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalGapLg,
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('VOLVER AL INICIO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
