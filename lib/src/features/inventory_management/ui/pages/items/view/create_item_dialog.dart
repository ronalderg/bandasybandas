import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_cubit.dart';
import 'package:bandasybandas/src/shared/atoms/at_textfield_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronalderg_util/ronalderg_util.dart'; // Asumiendo que FormValidators está aquí

class CreateItemDialog extends StatefulWidget {
  const CreateItemDialog({super.key});

  @override
  State<CreateItemDialog> createState() => _CreateItemDialogState();
}

class _CreateItemDialogState extends State<CreateItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _observationsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // 1. Se crea el modelo a partir de los controladores.
      final newItem = ItemModel(
        // El ID se genera en Firestore, así que podemos usar un valor temporal.
        id: '',
        name: _nameController.text,
        sku: _skuController.text,
        description: _descriptionController.text,
        quantity: double.tryParse(_quantityController.text) ?? 0.0,
        // El precio no se pide en este formulario, se usa un valor por defecto.
        price: 0,
        observations: _observationsController.text,
      );

      // 2. Se llama al método del Cubit para añadir el item.
      // El Cubit se encargará de llamar al caso de uso y al repositorio.
      context.read<ItemsCubit>().addItem(newItem);

      // 3. Se cierra el diálogo.
      Navigator.of(context).pop(); // Cierra el diálogo
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crear Nuevo Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AtTextfieldText(
                label: 'Nombre',
                controller: _nameController,
                validator: FormValidators.notEmpty(
                  message: 'Por favor, ingrese un nombre.',
                ),
              ),
              AppSpacing.verticalGapSm,
              AtTextfieldText(
                label: 'SKU',
                controller: _skuController,
                validator: FormValidators.notEmpty(
                  message: 'Por favor, ingrese un SKU.',
                ),
              ),
              AppSpacing.verticalGapSm,
              AtTextfieldText(
                label: 'Descripción (Opcional)',
                controller: _descriptionController,
                maxLines: 3,
              ),
              AppSpacing.verticalGapSm,
              AtTextfieldText(
                label: 'Cantidad',
                controller: _quantityController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: FormValidators.notEmpty(
                  message: 'Por favor, ingrese una cantidad.',
                ),
              ),
              AppSpacing.verticalGapSm,
              AtTextfieldText(
                label: 'Observaciones (Opcional)',
                controller: _observationsController,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Guardar')),
      ],
    );
  }
}
