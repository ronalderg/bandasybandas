import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/customers/domain/models/customer_model.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_cubit.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_state.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/inventory_movement_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/cubit/products_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/cubit/products_page_state.dart';
import 'package:bandasybandas/src/shared/atoms/at_textfield_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Un diálogo para registrar el traslado de un [ItemModel] a un cliente.
class TransferItemDialog extends StatefulWidget {
  const TransferItemDialog({required this.item, super.key});

  final ItemModel item;

  @override
  State<TransferItemDialog> createState() => _TransferItemDialogState();
}

class _TransferItemDialogState extends State<TransferItemDialog> {
  final _formKey = GlobalKey<FormState>();
  CustomerModel? _selectedCustomer;
  final List<ProductModel> _selectedProducts =
      []; // Lista para almacenar los productos seleccionados

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCustomer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, seleccione un cliente.')),
        );
        return;
      }

      if (_selectedProducts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debe seleccionar al menos un producto a trasladar.'),
          ),
        );
        return;
      }
      // Implementación de la lógica del movimiento.
      final quantityToTransfer = _selectedProducts.length.toDouble();
      final now = DateTime.now();

      // 1. Crear los movimientos
      final movements = _selectedProducts.map((product) {
        return InventoryMovementModel(
          id: '', // Firestore generará el ID
          itemId: widget.item.id,
          productId: product.id,
          productSerial: product.serial,
          customerId: _selectedCustomer!.id,
          type: InventoryMovementType.transferOut,
          quantity: 1, // Cada producto es una unidad
          date: now,
          userId:
              'system', // TODO(Ronder): Obtener ID del usuario actual si es posible
          observations: 'Traslado a cliente ${_selectedCustomer!.name}',
        );
      }).toList();

      // 2. Actualizar el item (restar cantidad)
      final updatedItem = widget.item.copyWith(
        quantity: widget.item.quantity - quantityToTransfer,
      );

      // 3. Ejecutar la transacción a través del Cubit
      context.read<ItemsCubit>().transferItem(
            updatedItem: updatedItem,
            movements: movements,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Traslado de ${quantityToTransfer.toInt()} productos a ${_selectedCustomer!.name} registrado.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      scrollable: true,
      title: Text('Trasladar ${widget.item.name}'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: BlocBuilder<CustomersManagementCubit, CustomersManagementState>(
          builder: (context, customerState) {
            final customers = customerState is CustomersPageLoaded
                ? customerState.customers
                : <CustomerModel>[];
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  AppSpacing.verticalGapMd,
                  Text(
                    'Seleccione los productos (seriales) a trasladar:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  AppSpacing.verticalGapSm,
                  // Usamos un BlocBuilder para obtener la lista de productos.
                  BlocBuilder<ProductsPageCubit, ProductsPageState>(
                    builder: (context, productState) {
                      if (productState is! ProductsPageLoaded) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      // Filtramos los productos que coinciden con el SKU del ítem de venta.
                      final availableProducts = productState.products
                          .where((p) => p.sku == widget.item.sku)
                          .toList();

                      if (availableProducts.isEmpty) {
                        return const Text(
                          'No hay productos con serial en stock para este ítem.',
                        );
                      }

                      return Column(
                        children: availableProducts.map((product) {
                          final isSelected =
                              _selectedProducts.contains(product);
                          return CheckboxListTile(
                            title: Text(product.name),
                            subtitle: Text('Serial: ${product.serial}'),
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value ?? false) {
                                  // Validar que no se pueda transferir más de la cantidad disponible del item.
                                  if (_selectedProducts.length <
                                      widget.item.quantity) {
                                    _selectedProducts.add(product);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'No se puede exceder el stock del ítem.',
                                          ),
                                        ),
                                      );
                                  }
                                } else {
                                  _selectedProducts.remove(product);
                                }
                              });
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            );
          },
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
