import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:flutter/material.dart';

class ItemsView extends StatelessWidget {
  const ItemsView({required this.items, super.key});

  final List<ItemModel> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text('No hay ítems en el inventario.'),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: const Icon(Icons.inventory_2_outlined),
          title: Text(item.name),
          subtitle: Text('Stock: ${item.quantity}'),
          trailing: Text('\$${item.price.toStringAsFixed(2)}'),
        );
      },
    );
  }
}
