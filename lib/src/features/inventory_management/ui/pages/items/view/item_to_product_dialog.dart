import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/cubit/products_page_cubit.dart';
import 'package:bandasybandas/src/shared/atoms/at_textfield_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronalderg_util/ronalderg_util.dart';

/// Un diálogo para convertir una cantidad de un [ItemModel] en [ProductModel]s serializados.
class ConvertItemToProductDialog extends StatefulWidget {
  const ConvertItemToProductDialog({required this.item, super.key});

  final ItemModel item;

  @override
  State<ConvertItemToProductDialog> createState() =>
      _ConvertItemToProductDialogState();
}

class _ConvertItemToProductDialogState
    extends State<ConvertItemToProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  int _quantityToConvert = 0;
  List<TextEditingController> _serialControllers = [];

  @override
  void dispose() {
    _quantityController.dispose();
    for (final controller in _serialControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _generateSerialFields() {
    if (!_formKey.currentState!.validate()) return;

    final quantity = int.tryParse(_quantityController.text) ?? 0;
    if (quantity <= 0 || quantity > widget.item.quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'La cantidad debe ser mayor a 0 y no exceder el stock disponible (${widget.item.quantity.toInt()}).',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _quantityToConvert = quantity;
      // Limpiamos y creamos nuevos controladores para los seriales.
      for (final controller in _serialControllers) {
        controller.dispose();
      }
      _serialControllers = List.generate(
        _quantityToConvert,
        (_) => TextEditingController(),
      );
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingrese todos los números de serie.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final productsCubit = context.read<ProductsPageCubit>();
    final itemsCubit = context.read<ItemsCubit>();

    // 1. Crear los nuevos productos serializados.
    for (final controller in _serialControllers) {
      final newProduct = ProductModel(
        id: '', // Firestore generará el ID.
        name: widget.item.name,
        sku: widget.item.sku,
        serial: controller.text,
        description: widget.item.description,
        quantity: 1, // Un producto serializado siempre tiene cantidad 1.
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        category: '',
      );
      productsCubit.addProduct(newProduct);
    }

    // 2. Actualizar la cantidad en el 'ItemModel' original.
    final updatedItem = widget.item.copyWith(
      quantity: widget.item.quantity - _quantityToConvert,
    );
    itemsCubit.updateItem(updatedItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Se crearon $_quantityToConvert productos serializados.',
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
      scrollable: true,
      title: Text('Convertir ${widget.item.name} a Productos'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_quantityToConvert == 0) ...[
                Text(
                  'Stock actual del item: ${widget.item.quantity.toInt()}. Ingrese la cantidad a convertir en productos serializados.',
                ),
                AppSpacing.verticalGapMd,
                AtTextfieldText(
                  controller: _quantityController,
                  label: l10n?.quantity ?? 'Cantidad',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: FormValidators.notEmpty(),
                ),
              ] else ...[
                Text(
                  'Ingrese los $_quantityToConvert números de serie:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                AppSpacing.verticalGapMd,
                ...List.generate(_quantityToConvert, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AtTextfieldText(
                      controller: _serialControllers[index],
                      label: 'Serial Producto ${index + 1}',
                      validator: FormValidators.notEmpty(),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
      actions: _buildActions(context, l10n),
    );
  }

  List<Widget> _buildActions(BuildContext context, AppLocalizations? l10n) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(l10n?.cancel ?? 'Cancelar'),
      ),
      if (_quantityToConvert == 0)
        ElevatedButton(
          onPressed: _generateSerialFields,
          child: const Text('Generar Campos'),
        )
      else
        ElevatedButton(
          onPressed: _submit,
          child: Text(l10n?.create ?? 'Crear Productos'),
        ),
    ];
  }
}
