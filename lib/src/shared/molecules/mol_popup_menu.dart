import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/shared/models/vm_popup_menu_item_data.dart';
import 'package:flutter/material.dart';

/// Un widget que muestra un [PopupMenuButton] genérico.
///
/// [T] es el tipo de valor que se pasará al callback [onSelected].
class MolPopupMenu<T> extends StatelessWidget {
  const MolPopupMenu({
    required this.items,
    required this.onSelected,
    this.icon = Icons.more_vert,
    super.key,
  });

  final List<VmPopupMenuItemData<T>> items;
  final void Function(T) onSelected;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return items.map((item) {
          return PopupMenuItem<T>(
            value: item.value,
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Icon(item.icon, size: 20),
                  AppSpacing.horizontalGapSm,
                ],
                Text(item.label),
              ],
            ),
          );
        }).toList();
      },
      icon: Icon(icon),
    );
  }
}
