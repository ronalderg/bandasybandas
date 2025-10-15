import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/shared/models/user.dart';
import 'package:bandasybandas/src/shared/models/vm_drawer_item_data.dart';
import 'package:flutter/material.dart';

/// Items del drawer para el rol [UserType.gerente].
List<VmDrawerItemData> getGerenteDrawerItems(AppLocalizations l10n) {
  return [
    VmDrawerItemData(
      icon: Icons.dashboard,
      label: l10n.dashboard,
      route: AppRoutes.home,
    ),
    VmDrawerItemData(
      icon: Icons.person,
      label: l10n.users,
      route: AppRoutes.home,
    ),
    VmDrawerItemData(
      icon: Icons
          .playlist_add_check, // Icono para una lista de solicitud/aprobación.
      label: l10n
          .purchase_requests, // Asegúrate de tener esta key en tus archivos de localización.
      route: AppRoutes.home,
    ),
    // VmDrawerItemData(
    //   icon:
    //       Icons.shopping_bag_outlined, // Icono más representativo para Compras
    //   label: l10n.purchases,
    //   children: [
    //     VmDrawerItemData(
    //       icon: Icons.receipt_long, // Icono más claro para órdenes/facturas.
    //       label: l10n.purchase_orders,
    //       route: AppRoutes.inventory,
    //     ),
    //     VmDrawerItemData(
    //       icon: Icons
    //           .playlist_add_check, // Icono para una lista de solicitud/aprobación.
    //       label: l10n
    //           .purchase_requests, // Asegúrate de tener esta key en tus archivos de localización.
    //       route: AppRoutes.home,
    //     ),
    //   ],
    // ),
    VmDrawerItemData(
      icon: Icons.inventory_2, // Icono más representativo para Inventario
      label: l10n.inventory,
      children: [
        VmDrawerItemData(
          icon: Icons.inventory_2_outlined,
          label: l10n.items,
          route: AppRoutes.inventory,
        ),
        VmDrawerItemData(
          icon: Icons.design_services,
          label: l10n.recipes,
          route: AppRoutes.recipes,
        ),
        VmDrawerItemData(
          icon: Icons.precision_manufacturing,
          label: l10n.machines,
          route: AppRoutes.home,
        ),
      ],
    ),
    VmDrawerItemData(
      icon: Icons.business,
      label: l10n.customers,
      route: AppRoutes.home,
    ),
    VmDrawerItemData(
      icon: Icons.insights,
      label: l10n.indicators,
      route: AppRoutes.home,
    ),
  ];
}

/// Items del drawer para el rol [UserType.tecnico].
List<VmDrawerItemData> getTecnicoDrawerItems(AppLocalizations l10n) {
  return [
    VmDrawerItemData(
      icon: Icons.build,
      label: 'Órdenes de Trabajo',
      route: AppRoutes.home, // TODO(Ronder): Cambiar a la ruta correcta
    ),
  ];
}
