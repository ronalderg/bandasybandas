import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/app/router/app_transitions.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/items_page.dart';

class InventoryRoutes {
  static final routes = [
    // --- INVENTORY FEATURE ROUTES ---
    AppTransitions.fadeRoute(
      path: AppRoutes.inventory,
      builder: (_, __) => const ItemsPage(),
    ),
  ];
}
