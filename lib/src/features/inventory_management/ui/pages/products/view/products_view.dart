import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/desing_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/cubit/products_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/view/create_product_dialog.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/view/qr_display_dialog.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/cubit/recipe_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/cubit/recipe_page_state.dart';
import 'package:bandasybandas/src/shared/models/vm_popup_menu_item_data.dart';
import 'package:bandasybandas/src/shared/molecules/mol_list_tile_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Enum para definir las acciones del menú de un producto.
enum ProductMenuAction { delete, archive, qr }

class ProductsView extends StatelessWidget {
  const ProductsView({required this.products, super.key});

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Define los items del menú que se mostrarán para cada producto.
    final menuItems = [
      const VmPopupMenuItemData<ProductMenuAction>(
        value: ProductMenuAction.archive,
        label: 'Enviar a Cliente',
        icon: Icons.archive,
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
              ElevatedButton.icon(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (dialogContext) {
                    // Obtenemos la lista de recetas disponibles del estado de RecipesPageCubit.
                    final recipesState = context.read<RecipesPageCubit>().state;
                    final availableRecipes = recipesState is RecipesPageLoaded
                        ? recipesState.recipes
                        : <RecipeModel>[];

                    return MultiBlocProvider(
                      providers: [
                        // Pasamos el cubit de productos para poder crear uno nuevo.
                        BlocProvider.value(
                          value: context.read<ProductsPageCubit>(),
                        ),
                      ],
                      child: CreateProductDialog(
                        availableRecipes: availableRecipes,
                      ),
                    );
                  },
                ),
                icon: const Icon(Icons.add),
                label: const Text('Nuevo Producto'),
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
                return MolListtileItem<ProductMenuAction>(
                  onEditTap: () {},
                  onViewTap: () {},
                  menuItems: menuItems,
                  onMenuItemSelected: (action) {
                    // Lógica para manejar la acción seleccionada.
                    switch (action) {
                      case ProductMenuAction.delete:
                        // TODO(Ronder): Implementar lógica de eliminación.
                        break;
                      case ProductMenuAction.archive:
                        // TODO(Ronder): Implementar lógica de archivo.
                        break;
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
