import 'package:flutter/material.dart';

/// Modelo de datos para un item de un menú emergente.
///
/// [T] es el tipo del valor que se devolverá cuando se seleccione el item.
class VmPopupMenuItemData<T> {
  const VmPopupMenuItemData({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;
  final IconData? icon;
}
