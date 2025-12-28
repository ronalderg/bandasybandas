import 'package:bandasybandas/src/core/theme/app_colors.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/categories/cubit/categories_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/categories/cubit/categories_state.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardChart extends StatelessWidget {
  const DashboardChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventario por Categoría',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            AppSpacing.verticalGapMd,
            SizedBox(
              height: 200,
              child: BlocBuilder<ItemsCubit, ItemsPageState>(
                builder: (context, itemsState) {
                  return BlocBuilder<CategoriesCubit, CategoriesState>(
                    builder: (context, categoriesState) {
                      if (itemsState is ItemsPageLoaded &&
                          categoriesState is CategoriesLoaded) {
                        final items = itemsState.items;
                        final categories = categoriesState.categories;

                        if (items.isEmpty) {
                          return const Center(
                            child: Text('No hay datos de inventario'),
                          );
                        }

                        // Agrupar items por categoryId
                        final Map<String, int> categoryCounts = {};
                        for (final item in items) {
                          final catId = item.categoryId ?? 'unknown';
                          categoryCounts[catId] =
                              (categoryCounts[catId] ?? 0) + 1;
                        }

                        // Crear secciones del gráfico
                        final List<PieChartSectionData> sections = [];
                        int index = 0;
                        final colors = [
                          AppColors.dashboardBlue,
                          AppColors.dashboardRed,
                          AppColors.dashboardGreen,
                          AppColors.dashboardOrange,
                          AppColors.dashboardPurple,
                          AppColors.dashboardTeal,
                          AppColors.dashboardPink,
                        ];

                        categoryCounts.forEach((catId, count) {
                          // Si no encontramos la categoría y no es 'unknown', usamos el ID o 'Desconocido'
                          /* final displayName = (catId != 'unknown' &&
                                  categoryName == categories.first.name &&
                                  categories.first.id != catId)
                              ? 'Desconocido'
                              : categoryName; */

                          final isLarge = count / items.length > 0.1;
                          sections.add(
                            PieChartSectionData(
                              color: colors[index % colors.length],
                              value: count.toDouble(),
                              title: '$count',
                              radius: isLarge ? 60 : 50,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          );
                          index++;
                        });

                        return Row(
                          children: [
                            Expanded(
                              child: PieChart(
                                PieChartData(
                                  sections: sections,
                                  centerSpaceRadius: 30,
                                  sectionsSpace: 2,
                                ),
                              ),
                            ),
                            // Leyenda simple
                            Expanded(
                              child: ListView.builder(
                                itemCount: categoryCounts.length,
                                itemBuilder: (context, i) {
                                  final catId =
                                      categoryCounts.keys.elementAt(i);
                                  final count = categoryCounts[catId];
                                  final categoryName = catId == 'unknown'
                                      ? 'Sin Categoría'
                                      : categories
                                          .firstWhere(
                                            (c) => c.id == catId,
                                            orElse: () => categories.first,
                                          )
                                          .name;

                                  // Corrección visual para nombres
                                  final displayName = (catId != 'unknown' &&
                                          categoryName ==
                                              categories.first.name &&
                                          categories.first.id != catId)
                                      ? 'Desconocido'
                                      : categoryName;

                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: colors[i % colors.length],
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            '$displayName ($count)',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else if (itemsState is ItemsPageLoading ||
                          categoriesState is CategoriesLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return const Center(child: Text('Cargando datos...'));
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
