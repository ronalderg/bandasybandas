import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/app/router/app_transitions.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/customers_management_page.dart';

class CustomersRoutes {
  static final routes = [
    // --- CUSTOMERS FEATURE ROUTES ---
    AppTransitions.fadeRoute(
      path: AppRoutes.customerManagement,
      builder: (_, __) => const CustomersManagementPage(),
    ),
  ];
}
