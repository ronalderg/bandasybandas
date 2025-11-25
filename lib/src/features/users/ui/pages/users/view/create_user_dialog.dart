import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/customers/domain/models/customer_model.dart';
import 'package:bandasybandas/src/features/customers/domain/usecases/customers_usecases.dart';
import 'package:bandasybandas/src/features/users/ui/pages/users/cubit/users_page_cubit.dart';
import 'package:bandasybandas/src/shared/models/user_model.dart';
import 'package:flutter/material.dart';

class CreateUserDialog extends StatefulWidget {
  const CreateUserDialog({required this.cubit, super.key});

  final UsersPageCubit cubit;

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _documentIdController = TextEditingController();
  final _cityController = TextEditingController();
  final _branchController = TextEditingController();
  final _passwordController = TextEditingController();
  UserType? _selectedUserType;
  List<CustomerModel> _customers = [];
  List<String> _selectedCompanyIds = [];

  // Usamos los valores del enum UserType, excluyendo 'none'.
  final List<UserType> _userTypes =
      UserType.values.where((type) => type != UserType.none).toList();

  @override
  void initState() {
    super.initState();
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
    _passwordController.dispose();
    super.dispose();
  }

  void _createUser() {
    if (_formKey.currentState!.validate()) {
      final newUser = AppUser(
        id: '', // El ID será asignado por Firebase Auth
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        userType: _selectedUserType?.name,
        documentId: _documentIdController.text,
        city: _cityController.text,
        branch: _branchController.text,
        allowedCompanies: _selectedCompanyIds,
      );

      // Llamar al cubit para crear el usuario
      widget.cubit.addUser(
        newUser,
        _passwordController.text,
      );

      Navigator.of(context).pop(); // Cierra el diálogo
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mapa para mostrar nombres legibles en el dropdown
    return AlertDialog(
      title: const Text('Crear Nuevo Usuario'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                // Campo para el Nombre
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value!.isEmpty ? 'El nombre no puede estar vacío' : null,
              ),
              AppSpacing.verticalGapMd,
              TextFormField(
                // Campo para el Apellido
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
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  helperText: 'Mínimo 6 caracteres',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contraseña no puede estar vacía';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              AppSpacing.verticalGapMd,
              TextFormField(
                controller: _branchController,
                decoration: const InputDecoration(labelText: 'Sede/Sucursal'),
              ),
              AppSpacing.verticalGapMd,
              DropdownButtonFormField<UserType>(
                initialValue: _selectedUserType,
                hint: Text(
                  'Tipo de Usuario',
                  style: Theme.of(context).popupMenuTheme.textStyle,
                ),
                onChanged: (UserType? newValue) {
                  setState(() {
                    _selectedUserType = newValue;
                  });
                },
                items: _userTypes.map<DropdownMenuItem<UserType>>((type) {
                  return DropdownMenuItem<UserType>(
                    value: type,
                    // Usamos el método de extensión para obtener un nombre legible
                    child: Text(type.toDisplayName()),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Selecciona un tipo de usuario' : null,
                dropdownColor: Theme.of(context).popupMenuTheme.color,
                style: Theme.of(context).popupMenuTheme.textStyle,
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
                              if (value == true) {
                                // Si es cliente, solo permitir una empresa
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
          onPressed: _createUser,
          child: const Text('Crear'),
        ),
      ],
    );
  }
}
