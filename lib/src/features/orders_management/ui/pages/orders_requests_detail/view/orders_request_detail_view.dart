import 'package:bandasybandas/src/features/orders_management/domain/models/order_request_model.dart';
import 'package:flutter/material.dart';

class OrdersRequestDetailView extends StatelessWidget {
  const OrdersRequestDetailView({required this.orders, super.key});

  final List<OrderRequestModel> orders;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return ListTile(
          title: Text('Order ${order.id}'),
          subtitle: Text('Status: ${order.status}'),
        );
      },
    );
  }
}
