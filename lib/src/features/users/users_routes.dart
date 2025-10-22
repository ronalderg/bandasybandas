import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/app/router/app_transitions.dart';
import 'package:bandasybandas/src/features/users/ui/pages/users/users_page.dart';

class UsersRoutes {
  static final routes = [
    // --- USERS FEATURE ROUTES ---
    AppTransitions.fadeRoute(
      path: AppRoutes.users,
      builder: (_, __) => const UsersPage(),
    ),
  ];
}
