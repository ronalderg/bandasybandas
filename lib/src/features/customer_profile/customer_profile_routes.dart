import 'package:bandasybandas/src/app/bloc/auth/auth_bloc.dart';
import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/app/router/app_transitions.dart';
import 'package:bandasybandas/src/features/customer_profile/ui/pages/customer_inventory/customer_inventory_page.dart';
import 'package:bandasybandas/src/features/customer_profile/ui/pages/customer_machines/customer_machines_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Configuración de rutas para el módulo de perfil de cliente.
class CustomerProfileRoutes {
  static final routes = [
    // --- CUSTOMER PROFILE FEATURE ROUTES ---
    AppTransitions.fadeRoute(
      path: AppRoutes.customerMachines,
      builder: (context, state) {
        // Obtenemos el customerId del usuario autenticado desde AuthBloc
        final user = context.read<AuthBloc>().state.user;
        // Usamos el primer allowedCompany como customerId
        final customerId = user.allowedCompanies?.first ?? '';
        return CustomerMachinesPage(customerId: customerId);
      },
    ),

    AppTransitions.fadeRoute(
      path: AppRoutes.customerInventory,
      builder: (context, state) {
        // Obtenemos el customerId del usuario autenticado desde AuthBloc
        final user = context.read<AuthBloc>().state.user;
        // Usamos el primer allowedCompany como customerId
        final customerId = user.allowedCompanies?.first ?? '';
        debugPrint('=== CUSTOMER INVENTORY PAGE ===');
        debugPrint('User ID: ${user.id}');
        debugPrint('User email: ${user.email}');
        debugPrint('Allowed companies: ${user.allowedCompanies}');
        debugPrint('Using customerId: $customerId');
        debugPrint('===============================');
        return CustomerInventoryPage(customerId: customerId);
      },
    ),
  ];
}
