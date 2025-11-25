import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/models/customer_product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Vista que muestra la lista de máquinas del cliente.
class CustomerMachinesView extends StatelessWidget {
  const CustomerMachinesView({
    required this.customerProducts,
    required this.products,
    super.key,
  });

  final List<CustomerProductModel> customerProducts;
  final Map<String, ProductModel> products;

  @override
  Widget build(BuildContext context) {
    if (customerProducts.isEmpty) {
      return const Center(
        child: Text('No tienes máquinas asignadas'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: customerProducts.length,
      itemBuilder: (context, index) {
        final customerProduct = customerProducts[index];
        final product = products[customerProduct.productId];

        if (product == null) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: ListTile(
            leading: const Icon(Icons.precision_manufacturing, size: 40),
            title: Text(
              product.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xs),
                Text('SKU: ${product.sku}'),
                Text('Serial: ${product.serial}'),
                if (customerProduct.location != null)
                  Text('Ubicación: ${customerProduct.location}'),
                Text(
                  'Instalada: ${DateFormat('dd/MM/yyyy').format(customerProduct.installedAt)}',
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
