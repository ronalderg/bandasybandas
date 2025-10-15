import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({required this.products, super.key});

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const l10n = 'Productos'; // Placeholder

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
                l10n,
                style: theme.textTheme.headlineSmall,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO(Ronder): Implementar diálogo para crear producto.
                },
                icon: const Icon(Icons.add),
                label: const Text('Nuevo Producto'),
              ),
            ],
          ),
          AppSpacing.verticalGapLg,

          // Mensaje si la lista está vacía
          if (products.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text('No hay productos registrados.'),
              ),
            )
          else
            // Lista de productos
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                      product.description ?? 'Sin descripción'), //TODO: SKU
                  trailing: const Icon(Icons.more_vert),
                );
              },
            ),
        ],
      ),
    );
  }
}
