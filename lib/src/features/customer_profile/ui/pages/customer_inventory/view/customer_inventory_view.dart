import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/models/customer_product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Vista que muestra el inventario de items del cliente.
class CustomerInventoryView extends StatelessWidget {
  const CustomerInventoryView({
    required this.customerProducts,
    required this.products,
    super.key,
  });

  final List<CustomerProductModel> customerProducts;
  final Map<String, ProductModel> products;

  @override
  Widget build(BuildContext context) {
    print(products);
    print('CustomerInventoryView');
    print(customerProducts);
    if (customerProducts.isEmpty) {
      return const Center(
        child: Text('No tienes productos en tu inventario'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: customerProducts.length,
      itemBuilder: (context, index) {
        print('PASAMELO');
        final customerProduct = customerProducts[index];
        final product = products[customerProduct.productId];

        if (product == null) {
          print('Product null');
          return const SizedBox.shrink();
        }
        debugPrint(
            'Product in CustomerInventoryView: ${product.name} - ${product.sku} - ${product.price}');

        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: ListTile(
            leading: const Icon(Icons.inventory_2, size: 40),
            title: Text(
              product.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xs),
                Text('SKU: ${product.sku}'),
                Text('Serial: ${customerProduct.serialNumber ?? "N/A"}'),
                Text(
                    'Estado: ${customerProduct.productStatus.name}'), // TODO: Localize status
                if (product.price != null)
                  Text(
                    'Precio: \$${NumberFormat('#,##0.00').format(product.price)}',
                  ),
                Text(
                  'Instalado: ${DateFormat('dd/MM/yyyy').format(customerProduct.installedAt)}',
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // If quantity is relevant (e.g. for stock), show it.
                // For machines, maybe not needed or always 1.
                if (customerProduct.quantityRemaining != null) ...[
                  Text(
                    customerProduct.quantityRemaining!.toStringAsFixed(0),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Text('unidades'),
                ],
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
