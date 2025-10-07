import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Modelo de datos para representar un item en el drawer.
///
/// Es inmutable y se utiliza para desacoplar la configuración de los items
/// de la implementación del widget.
class VmDrawerItemData extends Equatable {
  VmDrawerItemData({
    required this.icon,
    required this.label,
    this.route,
    this.children = const [],
  }) : assert(
          route != null || children.isNotEmpty,
          'Un VmDrawerItemData debe tener una `route` o una lista de `children`, pero no puede carecer de ambos.',
        );

  final IconData icon;
  final String label;
  final String? route;

  /// Lista de sub-items. Si no está vacía, este item se renderizará
  /// como un [ExpansionTile].
  final List<VmDrawerItemData> children;

  /// Retorna `true` si el item tiene hijos y debe ser expandible.
  bool get isExpandable => children.isNotEmpty;

  @override
  List<Object?> get props => [icon, label, route, children];
}
