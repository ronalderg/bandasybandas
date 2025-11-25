import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/features/customer_profile/ui/bloc/customer_inventory/customer_inventory_cubit.dart';
import 'package:bandasybandas/src/features/customer_profile/ui/bloc/customer_inventory/customer_inventory_state.dart';
import 'package:bandasybandas/src/features/customer_profile/ui/pages/customer_inventory/view/customer_inventory_view.dart';
import 'package:bandasybandas/src/shared/templates/tp_app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Página principal para mostrar el inventario del cliente.
class CustomerInventoryPage extends StatelessWidget {
  const CustomerInventoryPage({
    required this.customerId,
    super.key,
  });

  final String customerId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) =>
          sl<CustomerInventoryCubit>()..loadCustomerInventory(customerId),
      child: TpAppScaffold(
        pageTitle: l10n?.inventory ?? 'Inventario',
        body: SafeArea(
          child: BlocBuilder<CustomerInventoryCubit, CustomerInventoryState>(
            builder: (context, state) {
              if (state is CustomerInventoryInitial ||
                  state is CustomerInventoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CustomerInventoryLoaded) {
                return CustomerInventoryView(
                  customerProducts: state.customerProducts,
                  products: state.products,
                );
              } else if (state is CustomerInventoryError) {
                debugPrint('Error in CustomerInventoryPage: ${state.message}');
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
