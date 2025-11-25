import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_cubit.dart';
import 'package:bandasybandas/src/shared/atoms/at_textfield_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronalderg_util/ronalderg_util.dart';

/// Un diálogo para editar un [ItemModel] existente.
class EditItemDialog extends StatefulWidget {
  const EditItemDialog({required this.item, super.key});

  /// El item que se va a editar.
  final ItemModel item;

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    // Inicializamos los controladores con los valores del item existente.
    _nameController = TextEditingController(text: widget.item.name);
    _skuController = TextEditingController(text: widget.item.sku);
    _descriptionController =
        TextEditingController(text: widget.item.description);
    _priceController =
        TextEditingController(text: widget.item.price.toString());
    _quantityController =
        TextEditingController(text: widget.item.quantity.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Creamos una copia del item original con los datos actualizados.
      final updatedItem = widget.item.copyWith(
        name: _nameController.text,
        sku: _skuController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text),
        quantity: double.tryParse(_quantityController.text) ?? 0,
      );

      // Llamamos al cubit para que actualice el item.
      context.read<ItemsCubit>().updateItem(updatedItem);

      Navigator.of(context).pop(); // Cierra el diálogo
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n?.edit_item ?? 'Editar Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AtTextfieldText(
                label: l10n?.name ?? 'Nombre',
                controller: _nameController,
                validator: FormValidators.notEmpty(
                  message: l10n?.error_field_required,
                ),
              ),
              AppSpacing.verticalGapSm,
              AtTextfieldText(label: 'SKU', controller: _skuController),
              AppSpacing.verticalGapSm,
              AtTextfieldText(
                label: l10n?.description ?? 'Descripción',
                controller: _descriptionController,
                maxLines: 3,
              ),
              AppSpacing.verticalGapSm,
              Row(
                children: [
                  Expanded(
                    child: AtTextfieldText(
                      label: l10n?.price ?? 'Precio',
                      controller: _priceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.horizontalGapSm,
                  Expanded(
                    child: AtTextfieldText(
                      label: l10n?.quantity ?? 'Cantidad',
                      controller: _quantityController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      validator: FormValidators.notEmpty(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n?.cancel ?? 'Cancelar'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(l10n?.save ?? 'Guardar'),
        ),
      ],
    );
  }
}
