import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/features/orders_management/ui/pages/orders_requests_detail/cubit/order_requests_page_cubit.dart';
import 'package:bandasybandas/src/features/orders_management/ui/pages/orders_requests_detail/cubit/order_requests_page_state.dart';
import 'package:bandasybandas/src/features/orders_management/ui/pages/orders_requests_detail/view/orders_request_detail_view.dart';
import 'package:bandasybandas/src/shared/templates/tp_app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersRequestDetailPage extends StatelessWidget {
  const OrdersRequestDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      // La vista solo pide el Cubit al service locator.
      // No sabe (ni le importa) cómo se construye.
      create: (_) => sl<OrderRequestsPageCubit>()..loadOrdersRequests(),
      child: TpAppScaffold(
        pageTitle: l10n?.orders_requests ?? 'Solicitudes de pedidos',
        body: SafeArea(
          child: BlocBuilder<OrderRequestsPageCubit, OrderRequestsPageState>(
            builder: (context, state) {
              if (state is OrdersRequestPageInitial ||
                  state is OrdersRequestPageLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OrdersRequestPageLoaded) {
                return OrdersRequestDetailView(orders: state.ordersRequests);
              } else if (state is OrdersRequestPageError) {
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
