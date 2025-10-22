import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_cubit.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_state.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/view/customer_management_view.dart';

import 'package:bandasybandas/src/shared/templates/tp_app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomersManagementPage extends StatelessWidget {
  const CustomersManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // La vista solo pide el Cubit al service locator.
      // No sabe (ni le importa) cómo se construye.
      create: (_) => sl<CustomersManagementCubit>()..loadCustomers(),
      child: TpAppScaffold(
        pageTitle: 'Customers',
        body: SafeArea(
          child:
              BlocBuilder<CustomersManagementCubit, CustomersManagementState>(
            builder: (context, state) {
              if (state is CustomersPageInitial ||
                  state is CustomersPageLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CustomersPageLoaded) {
                return CustomersManagementView(customers: state.customers);
              } else if (state is CustomersPageError) {
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
