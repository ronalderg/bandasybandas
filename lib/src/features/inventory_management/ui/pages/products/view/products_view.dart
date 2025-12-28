import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/recipe_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/cubit/products_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/view/create_product_dialog.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/view/edit_product_dialog.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/view/qr_display_dialog.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/view/transfer_product_dialog.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/cubit/recipe_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/cubit/recipe_page_state.dart';
import 'package:bandasybandas/src/shared/models/vm_popup_menu_item_data.dart';
import 'package:bandasybandas/src/shared/molecules/mol_list_tile_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Enum para definir las acciones del menú de un producto.
enum ProductMenuAction { delete, transfer, qr }

class ProductsView extends StatelessWidget {
  const ProductsView({
    required this.products,
    this.isReadOnly = false,
    super.key,
  });

  final List<ProductModel> products;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Define los items del menú que se mostrarán para cada producto.
    // En modo de solo lectura, solo mostrar QR
    final menuItems = isReadOnly
        ? [
            const VmPopupMenuItemData<ProductMenuAction>(
              value: ProductMenuAction.qr,
              label: 'Generar QR',
              icon: Icons.qr_code,
            ),
          ]
        : [
            const VmPopupMenuItemData<ProductMenuAction>(
              value: ProductMenuAction.transfer,
              label: 'Trasladar a Cliente',
              icon: Icons.local_shipping,
            ),
            const VmPopupMenuItemData<ProductMenuAction>(
              value: ProductMenuAction.qr,
              label: 'Generar QR',
              icon: Icons.qr_code,
            ),
            const VmPopupMenuItemData<ProductMenuAction>(
              value: ProductMenuAction.delete,
              label: 'Eliminar',
              icon: Icons.delete_outline,
            ),
          ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado con título y botón
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.products,
                style: theme.textTheme.headlineSmall,
              ),
              // Solo mostrar botón de crear si NO es modo de solo lectura
              if (!isReadOnly)
                ElevatedButton.icon(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (dialogContext) => MultiBlocProvider(
                      providers: [
                        // Pasamos el cubit de productos para poder crear uno nuevo.
                        BlocProvider.value(
                          value: context.read<ProductsPageCubit>(),
                        ),
                        // Proveemos el RecipesPageCubit para que el BlocBuilder funcione.
                        BlocProvider.value(
                          value: context.read<RecipesPageCubit>(),
                        ),
                        // Proveemos el ItemsCubit, ya que el diálogo lo necesita.
                        BlocProvider.value(value: context.read<ItemsCubit>()),
                      ],
                      // Usamos un BlocBuilder para reaccionar a los cambios de estado
                      // del RecipesPageCubit y pasar la lista actualizada al diálogo.
                      child: BlocBuilder<RecipesPageCubit, RecipesPageState>(
                        builder: (context, recipesState) {
                          final availableRecipes =
                              recipesState is RecipesPageLoaded
                                  ? recipesState.recipes
                                  : <RecipeModel>[];
                          return CreateProductDialog(
                            availableRecipes: availableRecipes,
                          );
                        },
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.new_product),
                ),
            ],
          ),
          AppSpacing.verticalGapLg,

          // Mensaje si la lista está vacía
          if (products.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text('No hay productos registrados.'),
              ),
            )
          else
            // Lista de productos
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return MolListTileItem<ProductMenuAction>(
                  // Solo mostrar botón de editar si NO es modo de solo lectura
                  onEditTap: isReadOnly
                      ? null
                      : () {
                          // Obtener las recetas disponibles
                          final recipesState =
                              context.read<RecipesPageCubit>().state;
                          final availableRecipes =
                              recipesState is RecipesPageLoaded
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
                  onViewTap: () => GoRouter.of(context).go(
                    AppRoutes.productDetails.replaceFirst(':id', product.id),
                  ),
                  menuItems: menuItems,
                  onMenuItemSelected: (action) {
                    // Lógica para manejar la acción seleccionada.
                    switch (action) {
                      case ProductMenuAction.delete:
                        // Mostrar diálogo de confirmación
                        showDialog<bool>(
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
                                onPressed: () {
                                  Navigator.of(dialogContext).pop(true);
                                  context
                                      .read<ProductsPageCubit>()
                                      .deleteExistingProduct(product.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.error,
                                  foregroundColor: theme.colorScheme.onError,
                                ),
                                child: Text(l10n.delete),
                              ),
                            ],
                          ),
                        );
                      case ProductMenuAction.transfer:
                        showDialog<void>(
                          context: context,
                          builder: (dialogContext) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: context.read<ProductsPageCubit>(),
                              ),
                              BlocProvider.value(
                                value: context.read<CustomersManagementCubit>(),
                              ),
                            ],
                            child: TransferProductDialog(product: product),
                          ),
                        );
                      case ProductMenuAction.qr:
                        showDialog<void>(
                          context: context,
                          builder: (_) => QrDisplayDialog(
                            data: product.id,
                            title: product.name,
                          ),
                        );
                    }
                  },
                  price: product.quantity,
                  quantity: product.quantity,
                  subtitle: product.description ?? '',
                  title: product.name,
                );
              },
            ),
        ],
      ),
    );
  }
}
