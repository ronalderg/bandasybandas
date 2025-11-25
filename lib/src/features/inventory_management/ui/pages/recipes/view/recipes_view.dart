import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/recipe_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/cubit/recipe_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/view/create_recipe_dialog.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/view/edit_recipe_dialog.dart';
import 'package:bandasybandas/src/shared/models/vm_popup_menu_item_data.dart';
import 'package:bandasybandas/src/shared/molecules/mol_list_tile_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Enum para definir las acciones del menú de una receta.
enum RecipeMenuAction { edit, delete }

class RecipesView extends StatelessWidget {
  const RecipesView({required this.designs, super.key});

  final List<RecipeModel> designs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
                l10n.designs,
                style: theme.textTheme.headlineSmall,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    // Usamos el `context` del builder para asegurar que tenemos acceso
                    // a los providers que están por encima del `SingleChildScrollView`.
                    builder: (BuildContext dialogContext) {
                      // Usamos MultiBlocProvider para proveer ambos Cubits al diálogo.
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<RecipesPageCubit>(),
                          ),
                          BlocProvider.value(value: context.read<ItemsCubit>()),
                        ],
                        child: const CreateRecipeDialog(),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add),
                label: Text('Nuevo ${l10n.design}'),
              ),
            ],
          ),
          AppSpacing.verticalGapLg,

          // Mensaje si la lista está vacía
          if (designs.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child:
                    Text('No hay ${l10n.designs.toLowerCase()} registrados.'),
              ),
            )
          else
            // Lista de diseños
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: designs.length,
              itemBuilder: (context, index) {
                final design = designs[index];
                return MolListTileItem<RecipeMenuAction>(
                  onEditTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<RecipesPageCubit>(),
                          ),
                          BlocProvider.value(
                            value: context.read<ItemsCubit>(),
                          ),
                        ],
                        child: EditRecipeDialog(recipe: design),
                      ),
                    );
                  },
                  onViewTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<RecipesPageCubit>(),
                          ),
                          BlocProvider.value(
                            value: context.read<ItemsCubit>(),
                          ),
                        ],
                        child: EditRecipeDialog(recipe: design),
                      ),
                    );
                  },
                  price: design.salePrice ?? 0.0,
                  quantity: design.items.length.toDouble(),
                  subtitle: design.description ?? '',
                  title: design.name,
                  menuItems: const [
                    VmPopupMenuItemData(
                      value: RecipeMenuAction.edit,
                      label: 'Editar',
                      icon: Icons.edit,
                    ),
                    VmPopupMenuItemData(
                      value: RecipeMenuAction.delete,
                      label: 'Eliminar',
                      icon: Icons.delete_outline,
                    ),
                  ],
                  onMenuItemSelected: (action) {
                    switch (action) {
                      case RecipeMenuAction.edit:
                        showDialog<void>(
                          context: context,
                          builder: (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: context.read<RecipesPageCubit>(),
                              ),
                              BlocProvider.value(
                                value: context.read<ItemsCubit>(),
                              ),
                            ],
                            child: EditRecipeDialog(recipe: design),
                          ),
                        );
                      case RecipeMenuAction.delete:
                        // Mostrar diálogo de confirmación
                        showDialog<bool>(
                          context: context,
                          builder: (BuildContext dialogContext) => AlertDialog(
                            title: Text(l10n.delete_product),
                            content: Text(
                              '¿Estás seguro de que deseas eliminar "${design.name}"? '
                              'Esta acción marcará la receta como eliminada.',
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
                                      .read<RecipesPageCubit>()
                                      .deleteExistingRecipe(design.id);
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
                    }
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
