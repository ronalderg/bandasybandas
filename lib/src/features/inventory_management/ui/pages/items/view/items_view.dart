import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/view/create_item_dialog.dart';
import 'package:bandasybandas/src/shared/molecules/mol_list_tile_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsView extends StatelessWidget {
  const ItemsView({required this.items, super.key});

  final List<ItemModel> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                'Ítems de venta',
                style: theme.textTheme.headlineSmall,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      // Envolvemos el diálogo con BlocProvider.value para pasarle
                      // la instancia existente de ItemsCubit.
                      return BlocProvider.value(
                        value: context.read<ItemsCubit>(),
                        child: const CreateItemDialog(),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Nuevo Item'),
              ),
            ],
          ),
          AppSpacing.verticalGapLg,

          // Mensaje si la lista está vacía
          if (items.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text('No hay ítems en el inventario.'),
              ),
            )
          else
            // Lista de ítems
            ListView.builder(
              shrinkWrap:
                  true, // Para que el ListView no ocupe espacio infinito
              physics:
                  const NeverScrollableScrollPhysics(), // Para que el scroll lo maneje el SingleChildScrollView
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return MolListtileItem(
                  onEditTap: () {},
                  menuItems: const [],
                  onViewTap: () {},
                  price: item.price,
                  quantity: item.quantity,
                  subtitle: item.description ?? '',
                  title: item.name,
                );
              },
            ),
        ],
      ),
    );
  }
}
