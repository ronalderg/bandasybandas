import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_cubit.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_state.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/categories/cubit/categories_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/categories/cubit/categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Un diálogo para visualizar los detalles de un [ItemModel] existente.
class ViewItemDialog extends StatelessWidget {
  const ViewItemDialog({required this.item, super.key});

  /// El item que se va a visualizar.
  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<CustomersManagementCubit>()..loadCustomers(),
        ),
        BlocProvider(
          create: (_) => sl<CategoriesCubit>()..loadCategories(),
        ),
      ],
      child: AlertDialog(
        title: Text(item.name),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Información básica del item
                _buildDetailRow(context, label: 'SKU', value: item.sku),
                if (item.description != null && item.description!.isNotEmpty)
                  _buildDetailRow(
                    context,
                    label: l10n?.description ?? 'Descripción',
                    value: item.description!,
                  ),
                _buildDetailRow(
                  context,
                  label: l10n?.quantity ?? 'Cantidad',
                  value: item.quantity.toString(),
                ),
                //Precio no se maneja
                // _buildDetailRow(
                //   context,
                //   label: l10n?.price ?? 'Precio',
                //   value: '\$${item.price.toStringAsFixed(2)}',
                // ),
                if (item.observations != null && item.observations!.isNotEmpty)
                  _buildDetailRow(
                    context,
                    label: 'Observaciones',
                    value: item.observations!,
                  ),

                // Mostrar categoría si existe
                if (item.categoryId != null)
                  BlocBuilder<CategoriesCubit, CategoriesState>(
                    builder: (context, state) {
                      if (state is CategoriesLoaded) {
                        final category = state.categories.firstWhere(
                          (cat) => cat.id == item.categoryId,
                          orElse: () => state.categories.first,
                        );
                        if (category.id == item.categoryId) {
                          return _buildDetailRow(
                            context,
                            label: 'Categoría',
                            value: category.name,
                          );
                        }
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                // Sección de Referencias de Cliente
                if (item.customerReferences != null &&
                    item.customerReferences!.isNotEmpty) ...[
                  AppSpacing.verticalGapLg,
                  const Divider(),
                  AppSpacing.verticalGapMd,
                  Text(
                    'Referencias de Cliente',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  AppSpacing.verticalGapSm,
                  BlocBuilder<CustomersManagementCubit,
                      CustomersManagementState>(
                    builder: (context, state) {
                      if (state is CustomersPageLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (state is CustomersPageLoaded) {
                        final customersMap = {
                          for (var c in state.customers) c.id: c.name
                        };

                        return Column(
                          children:
                              item.customerReferences!.entries.map((entry) {
                            final customerName = customersMap[entry.key] ??
                                'Cliente desconocido (${entry.key})';

                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              elevation: 1,
                              child: ListTile(
                                dense: true,
                                leading: const Icon(
                                  Icons.business,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  customerName,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                subtitle: Text(
                                  entry.value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n?.close ?? 'Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Text.rich(
        TextSpan(
          style: Theme.of(context).textTheme.bodyLarge,
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
