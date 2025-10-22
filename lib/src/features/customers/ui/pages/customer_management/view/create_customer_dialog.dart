import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/customers/domain/models/customer_model.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_cubit.dart';
import 'package:bandasybandas/src/shared/atoms/at_textfield_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronalderg_util/ronalderg_util.dart';

class CreateCustomerDialog extends StatefulWidget {
  const CreateCustomerDialog({super.key});

  @override
  State<CreateCustomerDialog> createState() => _CreateCustomerDialogState();
}

class _CreateCustomerDialogState extends State<CreateCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nitController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _contactPersonController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _nitController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _contactPersonController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newCustomer = CustomerModel(
        id: '', // Firestore generará el ID
        name: _nameController.text,
        nit: _nitController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        city: _cityController.text,
        contactPerson: _contactPersonController.text,
      );

      context.read<CustomersManagementCubit>().addCustomer(newCustomer);

      Navigator.of(context).pop(); // Cierra el diálogo
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      scrollable: true,
      title: Text(l10n?.create_new_customer ?? 'Crear Nuevo Cliente'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5, // Ancho del 50%
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AtTextfieldText(
                label: l10n?.name ?? 'Nombre',
                controller: _nameController,
                validator: FormValidators.notEmpty(
                  message: l10n?.error_field_required ?? 'Campo requerido',
                ),
              ),
              AppSpacing.verticalGapSm,
              AtTextfieldText(
                label: 'NIT / Cédula',
                controller: _nitController,
              ),
              AppSpacing.verticalGapSm,
              AtTextfieldText(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              AppSpacing.verticalGapSm,
              AtTextfieldText(
                label: 'Teléfono',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              AppSpacing.verticalGapSm,
              AtTextfieldText(
                label: 'Dirección',
                controller: _addressController,
              ),
              AppSpacing.verticalGapSm,
              AtTextfieldText(
                label: 'Ciudad',
                controller: _cityController,
              ),
              AppSpacing.verticalGapSm,
              AtTextfieldText(
                label: 'Persona de Contacto',
                controller: _contactPersonController,
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
