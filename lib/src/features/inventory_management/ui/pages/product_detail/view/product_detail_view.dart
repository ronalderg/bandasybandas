import 'dart:async';

import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/recipe_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_state.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/cubit/products_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/view/edit_product_dialog.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/view/qr_display_dialog.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/cubit/recipe_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/cubit/recipe_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({
    required this.product,
    super.key,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Encabezado con el nombre del producto ---
          Text(
            product.name,
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppSpacing.verticalGapSm,

          // --- Descripción del producto ---
          if (product.description != null && product.description!.isNotEmpty)
            Text(
              product.description!,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          AppSpacing.verticalGapLg,

          // --- Tarjeta con detalles clave ---
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    icon: Icons.qr_code_scanner_outlined,
                    label: 'SKU',
                    value: product.sku,
                  ),
                  const Divider(),
                  _buildDetailRow(
                    context,
                    icon: Icons.numbers,
                    label: 'Serial',
                    value: product.serial,
                  ),
                  const Divider(),
                  _buildDetailRow(
                    context,
                    icon: Icons.category_outlined,
                    label: l10n.category,
                    value: product.category,
                  ),
                  const Divider(),
                  _buildDetailRow(
                    context,
                    icon: Icons.calendar_today_outlined,
                    label: l10n.creation_date,
                    value: product.createdAt != null
                        ? DateFormat.yMMMd(l10n.localeName)
                            .format(product.createdAt!.toDate())
                        : 'N/A',
                  ),
                  if (product.recipeId != null) ...[
                    const Divider(),
                    _buildDetailRow(
                      context,
                      icon: Icons.receipt_long_outlined,
                      label: '${l10n.recipe} ID',
                      value: product.recipeId!,
                    ),
                  ],
                ],
              ),
            ),
          ),
          AppSpacing.verticalGapLg,

          // --- Tarjeta con la lista de componentes (items) ---
          if (product.items.isNotEmpty)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.items, // "Componentes" o "Items"
                      style: theme.textTheme.titleLarge,
                    ),
                    const Divider(),
                    // Usamos BlocBuilder para acceder a la lista de todos los items
                    // y así poder mostrar el nombre de cada componente.
                    BlocBuilder<ItemsCubit, ItemsPageState>(
                      builder: (context, itemState) {
                        if (itemState is! ItemsPageLoaded) {
                          return const Center(child: LinearProgressIndicator());
                        }
                        // Usamos una Column en lugar de ListView para evitar
                        // conflictos de scroll dentro de SingleChildScrollView.
                        return Column(
                          children: product.items.map((recipeItem) {
                            final itemModel = itemState.items.firstWhere(
                              (it) => it.id == recipeItem.itemId,
                              orElse: () => ItemModel.empty,
                            );
                            return ListTile(
                              leading: const Icon(
                                Icons.settings_input_component_outlined,
                              ),
                              title: Text(itemModel.name),
                              trailing: Text(
                                '${l10n.quantity}: ${recipeItem.quantity}',
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          // --- Botones de Acción ---
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Obtener las recetas disponibles del cubit
                  final recipesState = context.read<RecipesPageCubit>().state;
                  final availableRecipes = recipesState is RecipesPageLoaded
                      ? recipesState.recipes
                      : <RecipeModel>[];

                  showDialog<void>(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: context.read<ProductsPageCubit>(),
                      child: EditProductDialog(
                        product: product,
                        availableRecipes: availableRecipes,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: Text(l10n.edit),
              ),
              ElevatedButton.icon(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => QrDisplayDialog(
                    data: product.id,
                    title: product.name,
                  ),
                ),
                icon: const Icon(Icons.qr_code_2_outlined),
                label: Text(l10n.generate_qr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  // Mostrar diálogo de confirmación
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext dialogContext) => AlertDialog(
                      title: Text(l10n.delete_product),
                      content: Text(
                        '¿Estás seguro de que deseas eliminar "${product.name}"? '
                        'Esta acción marcará el producto como eliminado.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          child: Text(l10n.cancel),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: theme.colorScheme.onError,
                          ),
                          child: Text(l10n.delete),
                        ),
                      ],
                    ),
                  );

                  // Si el usuario confirmó, eliminar el producto
                  if ((confirmed ?? false) && context.mounted) {
                    unawaited(
                      context
                          .read<ProductsPageCubit>()
                          .deleteExistingProduct(product.id),
                    );
                    // Navegar de regreso a la lista de productos
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                icon:
                    Icon(Icons.delete_outline, color: theme.colorScheme.error),
                label: Text(
                  l10n.delete,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          AppSpacing.horizontalGapMd,
          Text('$label:', style: theme.textTheme.titleSmall),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
