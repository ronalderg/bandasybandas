import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/customers/domain/models/customer_model.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_cubit.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_state.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/cubit/products_page_cubit.dart';
import 'package:bandasybandas/src/shared/atoms/at_textfield_text.dart';
import 'package:bandasybandas/src/shared/models/entity_metadata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Un diálogo para registrar el traslado de un [ProductModel] a un cliente.
class TransferProductDialog extends StatefulWidget {
  const TransferProductDialog({
    required this.product,
    super.key,
  });

  static Future<void> show(BuildContext context, ProductModel product) {
    return showDialog(
      context: context,
      builder: (_) => TransferProductDialog(product: product),
    );
  }

  final ProductModel product;

  @override
  State<TransferProductDialog> createState() => _TransferProductDialogState();
}

class _TransferProductDialogState extends State<TransferProductDialog> {
  final _formKey = GlobalKey<FormState>();
  CustomerModel? _selectedCustomer;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, seleccione un cliente.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Necesitamos el itemId para crear el inventario del cliente
    // El itemId se obtiene buscando el item que tiene el mismo SKU que este producto
    // Por ahora, vamos a usar el SKU como itemId temporal
    // TODO(Ronder): Buscar el itemId real basado en el SKU del producto
    final itemId = widget.product.sku; // Temporal: usar SKU como itemId

    // Actualizamos el estado del producto a 'sold' (vendido/trasladado)
    final updatedProduct = widget.product.copyWith(status: EntityStatus.sold);

    // Llamar al método transferProduct que maneja todo el flujo
    context.read<ProductsPageCubit>().transferProduct(
          updatedProduct: updatedProduct,
          customerId: _selectedCustomer!.id,
          itemId: itemId,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Producto trasladado a ${_selectedCustomer!.name}.',
        ),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      scrollable: true, // Permite que el contenido haga scroll si es muy grande
      title: Text('Trasladar ${widget.product.name}'), // Título del diálogo
      // Envuelve el contenido con un BlocProvider para el CustomersManagementCubit
      content: BlocProvider<CustomersManagementCubit>(
        create: (context) => sl<CustomersManagementCubit>()..loadCustomers(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5, // Ancho del diálogo
          child:
              BlocBuilder<CustomersManagementCubit, CustomersManagementState>(
            builder: (context, customerState) {
              final customers = customerState is CustomersPageLoaded
                  ? customerState.customers
                  : <CustomerModel>[];
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Serial: ${widget.product.serial}'),
                    AppSpacing.verticalGapMd,
                    Autocomplete<CustomerModel>(
                      optionsBuilder: (textEditingValue) =>
                          textEditingValue.text.isEmpty
                              ? const Iterable.empty()
                              : customers.where(
                                  (c) => c.name.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase(),
                                      ),
                                ),
                      displayStringForOption: (customer) => customer.name,
                      onSelected: (customer) =>
                          setState(() => _selectedCustomer = customer),
                      fieldViewBuilder:
                          (context, controller, focusNode, onEditingComplete) {
                        return AtTextfieldText(
                          controller: controller,
                          focusNode: focusNode,
                          onEditingComplete: onEditingComplete,
                          label: l10n?.search ?? 'Buscar cliente...',
                          prefixIcon: const Icon(Icons.search),
                          validator: (value) => _selectedCustomer == null
                              ? 'Debe seleccionar un cliente de la lista'
                              : null,
                        );
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            color: Theme.of(context).colorScheme.surface,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  final customer = options.elementAt(index);
                                  return ListTile(
                                    title: Text(customer.name),
                                    onTap: () => onSelected(customer),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n?.cancel ?? 'Cancelar'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Confirmar')),
      ],
    );
  }
}
