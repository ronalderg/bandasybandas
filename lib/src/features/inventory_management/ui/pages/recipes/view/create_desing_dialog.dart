import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class CreateDesingDialog extends StatefulWidget {
  const CreateDesingDialog({super.key});

  @override
  State<CreateDesingDialog> createState() => _CreateDesingDialogState();
}

class _CreateDesingDialogState extends State<CreateDesingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Aquí llamarías a tu BLoC o provider para crear el diseño.
      Navigator.of(context).pop(); // Cierra el diálogo
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text('Crear Nuevo ${l10n.desing}'),
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(onPressed: _submit, child: Text(l10n.save)),
      ],
    );
  }
}
