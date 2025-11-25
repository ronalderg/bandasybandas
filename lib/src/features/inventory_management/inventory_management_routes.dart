import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/app/router/app_transitions.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/items_page.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/product_detail/product_detail_page.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/products_page.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/recipes_page.dart';

class InventoryRoutes {
  static final routes = [
    // --- INVENTORY FEATURE ROUTES ---
    AppTransitions.fadeRoute(
      path: AppRoutes.inventory,
      builder: (_, __) => const ItemsPage(),
    ),

    AppTransitions.fadeRoute(
      path: AppRoutes.recipes,
      builder: (_, __) => const RecipesPage(),
    ),

    AppTransitions.fadeRoute(
      path: AppRoutes.products,
      builder: (_, __) => const ProductsPage(),
    ),

    AppTransitions.fadeRoute(
      path: AppRoutes.productDetails,
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetailPage(productId: productId);
      },
    ),
  ];
}
