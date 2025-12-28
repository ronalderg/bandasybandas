import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/core/theme/app_colors.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_cubit.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_state.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/categories/cubit/categories_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_state.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/cubit/products_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/cubit/products_page_state.dart';
import 'package:bandasybandas/src/features/technical_service/ui/pages/technical_services/cubit/technical_services_page_cubit.dart';
import 'package:bandasybandas/src/features/technical_service/ui/pages/technical_services/cubit/technical_services_page_state.dart';
import 'package:bandasybandas/src/shared/templates/tp_app_scaffold.dart';
import 'package:bandasybandas/src/ui/home/widgets/dashboard_chart.dart';
import 'package:bandasybandas/src/ui/home/widgets/quick_actions.dart';
import 'package:bandasybandas/src/ui/home/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ItemsCubit>()..loadItems()),
        BlocProvider(create: (_) => sl<CategoriesCubit>()..loadCategories()),
        BlocProvider(
            create: (_) => sl<CustomersManagementCubit>()..loadCustomers()),
        BlocProvider(
            create: (_) =>
                sl<TechnicalServicesPageCubit>()..loadTechnicalServices()),
        BlocProvider(create: (_) => sl<ProductsPageCubit>()..loadProducts()),
      ],
      child: TpAppScaffold(
        pageTitle: 'Inicio',
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resumen General',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              AppSpacing.verticalGapMd,
              // Grid de Tarjetas de Estadísticas
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<ItemsCubit, ItemsPageState>(
                      builder: (context, state) {
                        final count =
                            state is ItemsPageLoaded ? state.items.length : 0;
                        return StatCard(
                          title: 'Total Items',
                          value: '$count',
                          icon: Icons.inventory_2_outlined,
                          color: AppColors.dashboardBlue,
                        );
                      },
                    ),
                  ),
                  AppSpacing.horizontalGapSm,
                  Expanded(
                    child: BlocBuilder<ProductsPageCubit, ProductsPageState>(
                      builder: (context, state) {
                        final count = state is ProductsPageLoaded
                            ? state.products.length
                            : 0;
                        return StatCard(
                          title: 'Productos',
                          value: '$count',
                          icon: Icons.shopping_bag_outlined,
                          color: AppColors.dashboardPurple,
                        );
                      },
                    ),
                  ),
                ],
              ),
              AppSpacing.verticalGapSm,
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<CustomersManagementCubit,
                        CustomersManagementState>(
                      builder: (context, state) {
                        final count = state is CustomersPageLoaded
                            ? state.customers.length
                            : 0;
                        return StatCard(
                          title: 'Clientes',
                          value: '$count',
                          icon: Icons.people_outline,
                          color: AppColors.dashboardGreen,
                        );
                      },
                    ),
                  ),
                  AppSpacing.horizontalGapSm,
                  Expanded(
                    child: BlocBuilder<TechnicalServicesPageCubit,
                        TechnicalServicesPageState>(
                      builder: (context, state) {
                        final count = state is TechnicalServicesPageLoaded
                            ? state.services.length
                            : 0;
                        return StatCard(
                          title: 'Servicios',
                          value: '$count',
                          icon: Icons.build_circle_outlined,
                          color: AppColors.dashboardOrange,
                        );
                      },
                    ),
                  ),
                ],
              ),
              AppSpacing.verticalGapLg,
              // Gráfico y Accesos Rápidos
              const DashboardChart(),
              AppSpacing.verticalGapLg,
              const QuickActions(),
            ],
          ),
        ),
      ),
    );
  }
}
