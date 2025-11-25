import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/app/router/app_transitions.dart';
import 'package:bandasybandas/src/features/orders_management/ui/pages/orders_requests_detail/orders_request_detail_page.dart';

class OrdersManagementRoutes {
  static final routes = [
    // --- ORDERS MANAGEMENT FEATURE ROUTES ---
    AppTransitions.fadeRoute(
      path: AppRoutes.ordersRequests,
      builder: (_, __) => const OrdersRequestDetailPage(),
    ),
  ];
}
