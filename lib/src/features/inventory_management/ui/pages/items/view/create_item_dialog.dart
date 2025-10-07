import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateItemDialog extends StatefulWidget {
  const CreateItemDialog({super.key});

  @override
  State<CreateItemDialog> createState() => _CreateItemDialogState();
}

class _CreateItemDialogState extends State<CreateItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // El formulario es válido. Aquí llamarías a tu BLoC o provider para crear el ítem.
      // Por ejemplo: context.read<ItemsBloc>().add(CreateItemEvent(...));
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
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un nombre.';
                  }
                  return null;
                },
              ),
              AppSpacing.verticalGapSm,
              TextFormField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Descripción (Opcional)'),
              ),
              AppSpacing.verticalGapSm,
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  prefixText: r'$ ',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un precio.';
                  }
                  return null;
                },
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
