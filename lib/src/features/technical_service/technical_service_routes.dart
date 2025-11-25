import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/app/router/app_transitions.dart';
import 'package:bandasybandas/src/features/technical_service/ui/pages/technical_services/technical_services_page.dart';

class TechnicalServiceRoutes {
  static final routes = [
    // --- TECHNICAL SERVICE FEATURE ROUTES ---
    AppTransitions.fadeRoute(
      path: AppRoutes.technicalServices,
      builder: (_, __) => const TechnicalServicesPage(),
    ),
  ];
}
