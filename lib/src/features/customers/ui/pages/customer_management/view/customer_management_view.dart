import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/customers/domain/models/customer_model.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_cubit.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/view/create_customer_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomersManagementView extends StatelessWidget {
  const CustomersManagementView({required this.customers, super.key});

  final List<CustomerModel> customers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado con título y botón
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n?.customers ?? 'Clientes',
                style: theme.textTheme.headlineSmall,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      // Pasamos la instancia del Cubit al diálogo para que
                      // pueda llamar al método `addCustomer`.
                      return BlocProvider.value(
                        value: context.read<CustomersManagementCubit>(),
                        child: const CreateCustomerDialog(),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add),
                label: Text(l10n?.create_new_customer ?? 'Nuevo Cliente'),
              ),
            ],
          ),
          AppSpacing.verticalGapLg,

          // Mensaje si la lista está vacía
          if (customers.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text(
                  l10n?.no_customers_found ?? 'No hay clientes registrados.',
                ),
              ),
            )
          else
            // Lista de clientes
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return ListTile(
                  leading: const Icon(Icons.business),
                  title: Text(customer.name),
                  subtitle: Text(customer.nit ?? customer.email ?? ''),
                  trailing: const Icon(Icons.more_vert),
                );
              },
            ),
        ],
      ),
    );
  }
}
