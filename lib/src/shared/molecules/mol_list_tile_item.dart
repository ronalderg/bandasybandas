import 'package:bandasybandas/src/shared/models/vm_popup_menu_item_data.dart';
import 'package:bandasybandas/src/shared/molecules/mol_popup_menu.dart';
import 'package:flutter/material.dart';

class MolListtileItem<T> extends StatelessWidget {
  const MolListtileItem({
    required this.onEditTap,
    required this.onViewTap,
    required this.price,
    required this.quantity,
    required this.subtitle,
    required this.title,
    this.menuItems,
    this.onMenuItemSelected,
    super.key,
  });
  final VoidCallback? onViewTap;
  final VoidCallback? onEditTap;
  final List<VmPopupMenuItemData<T>>? menuItems;
  final void Function(T)? onMenuItemSelected;
  final String title;
  final String subtitle;
  final double price;
  final double quantity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Wrap(
        children: [
          IconButton(
            onPressed: onViewTap,
            icon: const Icon(Icons.remove_red_eye),
          ),
          IconButton(onPressed: onEditTap, icon: const Icon(Icons.edit)),
          if (menuItems != null && onMenuItemSelected != null)
            MolPopupMenu<T>(
              items: menuItems!,
              onSelected: onMenuItemSelected!,
            )
          else
            const IconButton(
              onPressed: null,
              icon: Icon(Icons.more_vert),
            ),
        ],
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text('Stock: ${quantity.toStringAsFixed(2)}'),
    );
  }
}
