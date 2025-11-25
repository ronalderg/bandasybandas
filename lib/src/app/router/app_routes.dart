// lib/src/app/router/app_routes.dart

/// Define los nombres de las rutas de la aplicación como constantes.
///
/// Usar constantes para los nombres de las rutas ayuda a evitar errores
/// tipográficos, facilita la refactorización y mejora la legibilidad del código
/// de navegación.
class AppRoutes {
  AppRoutes._(); // Constructor privado para evitar la creación de instancias

  // --- Rutas de Nivel Superior ---
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';

  // --- Rutas de Características (Features) ---
  static const String users = '/users';
  static const String customers = '/customers';
  static const String settings = '/settings';

  // --- Rutas de Inventarios (Features) ---
  static const String inventory = '/inventory';
  static const String items = '/items';
  static const String recipes = '/recipes';
  static const String products = '/products';
  static const String productDetails = '/product/:id';

  // --- Rutas de Clientes (Features) ---
  static const String customerManagement = '/customers/management';

  // --- Rutas de Compras (Features) ---
  static const String purchases = '/purchases';
  static const String purchaseOrder = '/purchase-order';
  static const String purchaseRequests = '/purchase-requests';

  // --- Rutas de Órdenes (Features) ---
  static const String ordersRequests = '/order-requests';
  static const String ordersRequestsDetails = '/order-requests/:id';

  // --- Rutas de servicio técnico (Features) ---
  static const String technicalServices = '/technical-services';
  static const String technicalServicesDetails = '/technical-services/:id';

  // --- Rutas de perfil de cliente (Features) ---
  static const String customerMachines = '/customer/machines';
  static const String customerInventory = '/customer/inventory';
}
