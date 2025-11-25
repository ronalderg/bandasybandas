import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/features/customer_profile/ui/bloc/customer_machines/customer_machines_cubit.dart';
import 'package:bandasybandas/src/features/customer_profile/ui/bloc/customer_machines/customer_machines_state.dart';
import 'package:bandasybandas/src/features/customer_profile/ui/pages/customer_machines/view/customer_machines_view.dart';
import 'package:bandasybandas/src/shared/templates/tp_app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Página principal para mostrar las máquinas del cliente.
class CustomerMachinesPage extends StatelessWidget {
  const CustomerMachinesPage({
    required this.customerId,
    super.key,
  });

  final String customerId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) =>
          sl<CustomerMachinesCubit>()..loadCustomerMachines(customerId),
      child: TpAppScaffold(
        pageTitle: l10n?.machines ?? 'Mis Máquinas',
        body: SafeArea(
          child: BlocBuilder<CustomerMachinesCubit, CustomerMachinesState>(
            builder: (context, state) {
              if (state is CustomerMachinesInitial ||
                  state is CustomerMachinesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CustomerMachinesLoaded) {
                return CustomerMachinesView(
                  customerProducts: state.customerProducts,
                  products: state.products,
                );
              } else if (state is CustomerMachinesError) {
                debugPrint('CustomerMachinesError: ${state.message}');
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
