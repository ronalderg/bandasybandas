import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/category_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/categories/cubit/categories_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/categories/view/create_category_dialog.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/categories/view/edit_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Vista principal para mostrar la lista de categorías.
class CategoriesView extends StatelessWidget {
  const CategoriesView({
    required this.categories,
    this.isReadOnly = false,
    super.key,
  });

  final List<CategoryModel> categories;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categorías',
                style: theme.textTheme.headlineSmall,
              ),
              if (!isReadOnly)
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (dialogContext) => BlocProvider.value(
                        value: context.read<CategoriesCubit>(),
                        child: const CreateCategoryDialog(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva Categoría'),
                ),
            ],
          ),
          AppSpacing.verticalGapLg,

          // Lista de categorías
          if (categories.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text('No hay categorías registradas.'),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              separatorBuilder: (context, index) => AppSpacing.verticalGapSm,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    title: Text(category.name),
                    subtitle: category.description != null &&
                            category.description!.isNotEmpty
                        ? Text(
                            category.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (dialogContext) => BlocProvider.value(
                          value: context.read<CategoriesCubit>(),
                          child: EditCategoryDialog(category: category),
                        ),
                      );
                    },
                    trailing: isReadOnly
                        ? null
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (dialogContext) =>
                                        BlocProvider.value(
                                      value: context.read<CategoriesCubit>(),
                                      child: EditCategoryDialog(
                                        category: category,
                                      ),
                                    ),
                                  );
                                },
                                tooltip: 'Editar',
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    _showDeleteConfirmation(context, category),
                                tooltip: 'Eliminar',
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, CategoryModel category) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar Categoría'),
        content: Text(
          '¿Estás seguro de que deseas eliminar la categoría "${category.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CategoriesCubit>().deleteCategory(category.id);
              Navigator.of(dialogContext).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
