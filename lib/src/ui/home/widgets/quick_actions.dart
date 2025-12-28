import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/core/theme/app_colors.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/view/create_item_dialog.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accesos Rápidos',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        AppSpacing.verticalGapMd,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _QuickActionButton(
              icon: Icons.add_box_outlined,
              label: 'Nuevo Item',
              color: AppColors.dashboardBlue,
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<ItemsCubit>(),
                    child: const CreateItemDialog(),
                  ),
                );
              },
            ),
            _QuickActionButton(
              icon: Icons.person_add_outlined,
              label: 'Nuevo Cliente',
              color: AppColors.dashboardGreen,
              onTap: () {
                // Navegar a la página de clientes o abrir diálogo
                // Por ahora, navegamos a la ruta de clientes
                context.go(AppRoutes.customers);
              },
            ),
            _QuickActionButton(
              icon: Icons.build_outlined,
              label: 'Servicio Téc.',
              color: AppColors.dashboardOrange,
              onTap: () {
                context.go(AppRoutes.technicalServices);
              },
            ),
            _QuickActionButton(
              icon: Icons.design_services_outlined,
              label: 'Diseños',
              color: AppColors.dashboardPink,
              onTap: () {
                context.go(AppRoutes.recipes);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // En dark mode, usamos el color con menos opacidad para el fondo, o un color surface
    final bgColor = isDark ? color.withOpacity(0.2) : color.withOpacity(0.1);
    final iconColor = isDark ? color.withOpacity(0.9) : color;
    final textColor = isDark ? Colors.white70 : color;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
