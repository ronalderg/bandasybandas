import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/customers/domain/models/customer_model.dart';
import 'package:bandasybandas/src/features/customers/domain/usecases/customers_usecases.dart';
import 'package:bandasybandas/src/features/users/ui/pages/users/cubit/users_page_cubit.dart';
import 'package:bandasybandas/src/shared/atoms/at_dropdown.dart';
import 'package:bandasybandas/src/shared/models/user_model.dart';
import 'package:flutter/material.dart';

class EditUserDialog extends StatefulWidget {
  const EditUserDialog({
    required this.user,
    required this.cubit,
    super.key,
  });

  final AppUser user;
  final UsersPageCubit cubit;

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _documentIdController;
  late final TextEditingController _cityController;
  late final TextEditingController _branchController;
  UserType? _selectedUserType;
  List<CustomerModel> _customers = [];
  List<String> _selectedCompanyIds = [];

  // Usamos los valores del enum UserType, excluyendo 'none'.
  final List<UserType> _userTypes =
      UserType.values.where((type) => type != UserType.none).toList();

  @override
  void initState() {
    super.initState();
    // Inicializamos los controladores con los datos del usuario existente.
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
    _documentIdController = TextEditingController(text: widget.user.documentId);
    _cityController = TextEditingController(text: widget.user.city);
    _branchController = TextEditingController(text: widget.user.branch);
    final userType = widget.user.getTipoUsuario();
    _selectedUserType = userType == UserType.none ? null : userType;
    _selectedCompanyIds = List.from(widget.user.allowedCompanies ?? []);
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    final result = await sl<GetCustomers>()(NoParams());
    result.fold(
      (failure) => debugPrint('Error cargando clientes: ${failure.message}'),
      (stream) {
        stream.listen((customers) {
          if (mounted) {
            setState(() {
              _customers = customers;
            });
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _documentIdController.dispose();
    _cityController.dispose();
    _branchController.dispose();
    super.dispose();
  }

  void _updateUser() {
    if (_formKey.currentState!.validate()) {
      // Usamos `copyWith` para crear una copia actualizada del usuario.
      final updatedUser = widget.user.copyWith(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        userType: _selectedUserType?.name,
        documentId: _documentIdController.text,
        city: _cityController.text,
        branch: _branchController.text,
        allowedCompanies: _selectedCompanyIds,
      );
      print('actualizar usuario ${updatedUser.toJson()}');
      // Llamamos al método del Cubit para actualizar el usuario.
      widget.cubit.updateUser(updatedUser);

      Navigator.of(context).pop(); // Cierra el diálogo
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Usuario'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value!.isEmpty ? 'El nombre no puede estar vacío' : null,
              ),
              AppSpacing.verticalGapMd,
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (value) =>
                    value!.isEmpty ? 'El apellido no puede estar vacío' : null,
              ),
              AppSpacing.verticalGapMd,
              TextFormField(
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: 'Correo Electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El correo no puede estar vacío';
                  }
                  if (!value.contains('@')) {
                    return 'Ingresa un correo válido';
                  }
                  return null;
                },
              ),
              AppSpacing.verticalGapMd,
              TextFormField(
                controller: _documentIdController,
                decoration: const InputDecoration(labelText: 'Documento ID'),
              ),
              AppSpacing.verticalGapMd,
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Ciudad'),
              ),
              AppSpacing.verticalGapMd,
              TextFormField(
                controller: _branchController,
                decoration: const InputDecoration(labelText: 'Sede/Sucursal'),
              ),
              AppSpacing.verticalGapMd,
              AtDropdown<UserType>(
                value: _selectedUserType,
                hintText: 'Tipo de Usuario',
                items: _userTypes.map<DropdownMenuItem<UserType>>((type) {
                  return DropdownMenuItem<UserType>(
                    value: type,
                    child: Text(type.toDisplayName()),
                  );
                }).toList(),
                onChanged: (UserType? newValue) {
                  print('nuevo valor es $newValue');
                  setState(() {
                    _selectedUserType = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Selecciona un tipo de usuario' : null,
              ),
              AppSpacing.verticalGapMd,
              if (_customers.isNotEmpty) ...[
                const Text('Empresas Permitidas / Pertenencia'),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  height: 150,
                  child: SingleChildScrollView(
                    child: Column(
                      children: _customers.map((customer) {
                        final isSelected =
                            _selectedCompanyIds.contains(customer.id);
                        return CheckboxListTile(
                          title: Text(customer.name),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value ?? false) {
                                // Si es cliente, solo permitir una empresa (opcional, pero recomendado por el usuario)
                                if (_selectedUserType == UserType.cliente ||
                                    _selectedUserType ==
                                        UserType.clienteAdministrador) {
                                  _selectedCompanyIds.clear();
                                }
                                _selectedCompanyIds.add(customer.id);
                              } else {
                                _selectedCompanyIds.remove(customer.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _updateUser,
          child: const Text('Guardar Cambios'),
        ),
      ],
    );
  }
}
