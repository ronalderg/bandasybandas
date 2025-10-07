import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: AppSpacing.horizontalPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ooops!',
                style: textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.error,
                ),
              ),
              AppSpacing.verticalGapMd,
              Text(
                '404 - Página no encontrada',
                style: textTheme.headlineSmall
                    ?.copyWith(color: colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalGapSm,
              Text(
                'La página que buscas no existe o ha sido movida.',
                // Usamos un color secundario para menor énfasis
                style: textTheme.bodyLarge
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalGapLg,
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                ),
                child: const Text('VOLVER AL INICIO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
