import 'package:bandasybandas/src/shared/organisms/org_app_drawer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Modelo de datos para representar un item en el [OrgAppDrawer].
///
/// Es inmutable y se utiliza para desacoplar la configuración de los items
/// de la implementación del widget.
class VmDrawerItemData extends Equatable {
  const VmDrawerItemData({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;

  @override
  List<Object?> get props => [icon, label, route];
}
