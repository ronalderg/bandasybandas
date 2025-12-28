import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/customers/domain/models/customer_model.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_cubit.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_state.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/categories/cubit/categories_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/categories/cubit/categories_state.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_cubit.dart';
import 'package:bandasybandas/src/shared/atoms/at_textfield_text.dart';
import 'package:bandasybandas/src/shared/atoms/at_dropdown.dart';
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

  // Para gestionar las referencias de cliente
  late Map<String, String> _customerReferences;

  // Para gestionar la categoría seleccionada
  String? _selectedCategoryId;

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

    // Inicializar referencias de cliente (crear copia mutable)
    _customerReferences = Map<String, String>.from(
      widget.item.customerReferences ?? {},
    );

    // Inicializar categoría seleccionada
    _selectedCategoryId = widget.item.categoryId;
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
        customerReferences:
            _customerReferences.isEmpty ? null : _customerReferences,
        categoryId: _selectedCategoryId,
      );

      // Llamamos al cubit para que actualice el item.
      context.read<ItemsCubit>().updateItem(updatedItem);

      Navigator.of(context).pop(); // Cierra el diálogo
    }
  }

  void _showAddReferenceDialog(List<CustomerModel> customers) {
    CustomerModel? selectedCustomer;
    final referenceController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Agregar Referencia de Cliente'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AtDropdown<CustomerModel>(
              value: selectedCustomer,
              label: 'Cliente',
              items: customers
                  .where((c) => !_customerReferences.containsKey(c.id))
                  .map((customer) => DropdownMenuItem(
                        value: customer,
                        child: Text(customer.name),
                      ))
                  .toList(),
              onChanged: (value) => selectedCustomer = value,
              validator: (value) =>
                  value == null ? 'Seleccione un cliente' : null,
            ),
            AppSpacing.verticalGapMd,
            TextField(
              controller: referenceController,
              decoration: const InputDecoration(
                labelText: 'Código/Referencia del Cliente',
                hintText: 'Ej: REF-ABC-123',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedCustomer != null &&
                  referenceController.text.isNotEmpty) {
                setState(() {
                  _customerReferences[selectedCustomer!.id] =
                      referenceController.text.trim();
                });
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _editReference(
      String customerId, String customerName, String currentRef) {
    final referenceController = TextEditingController(text: currentRef);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Editar Referencia - $customerName'),
        content: TextField(
          controller: referenceController,
          decoration: const InputDecoration(
            labelText: 'Código/Referencia del Cliente',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (referenceController.text.isNotEmpty) {
                setState(() {
                  _customerReferences[customerId] =
                      referenceController.text.trim();
                });
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _removeReference(String customerId) {
    setState(() {
      _customerReferences.remove(customerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<CustomersManagementCubit>()..loadCustomers(),
        ),
        BlocProvider(
          create: (_) => sl<CategoriesCubit>()..loadCategories(),
        ),
      ],
      child: AlertDialog(
        title: Text(l10n?.edit_item ?? 'Editar Item'),
        content: SizedBox(
          width: 600,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campos básicos del item
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
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
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
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
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

                  // Campo de Categoría
                  AppSpacing.verticalGapSm,
                  BlocBuilder<CategoriesCubit, CategoriesState>(
                    builder: (context, state) {
                      if (state is CategoriesLoaded) {
                        return AtDropdown<String>(
                          value: _selectedCategoryId,
                          label: l10n?.category ?? 'Categoría',
                          hintText: l10n?.select_category ??
                              'Seleccione una categoría',
                          items: [
                            DropdownMenuItem<String>(
                              value: '',
                              child: Text(l10n?.no_category ?? 'Sin categoría'),
                            ),
                            ...state.categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category.id,
                                child: Text(category.name),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                          },
                        );
                      } else if (state is CategoriesLoading) {
                        return const LinearProgressIndicator();
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  // Sección de Referencias de Cliente
                  AppSpacing.verticalGapLg,
                  const Divider(),
                  AppSpacing.verticalGapMd,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Referencias de Cliente',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      BlocBuilder<CustomersManagementCubit,
                          CustomersManagementState>(
                        builder: (context, state) {
                          if (state is CustomersPageLoaded) {
                            return IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () =>
                                  _showAddReferenceDialog(state.customers),
                              tooltip: 'Agregar referencia',
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                  AppSpacing.verticalGapSm,

                  // Lista de referencias
                  if (_customerReferences.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'No hay referencias de cliente agregadas',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  else
                    BlocBuilder<CustomersManagementCubit,
                        CustomersManagementState>(
                      builder: (context, state) {
                        if (state is CustomersPageLoaded) {
                          final customersMap = {
                            for (var c in state.customers) c.id: c.name
                          };

                          return Column(
                            children: _customerReferences.entries.map((entry) {
                              final customerName = customersMap[entry.key] ??
                                  'Cliente desconocido';

                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: const Icon(Icons.business),
                                  title: Text(customerName),
                                  subtitle: Text(
                                    entry.value,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20),
                                        onPressed: () => _editReference(
                                          entry.key,
                                          customerName,
                                          entry.value,
                                        ),
                                        tooltip: 'Editar',
                                      ),
                                      IconButton(
                                        icon:
                                            const Icon(Icons.delete, size: 20),
                                        onPressed: () =>
                                            _removeReference(entry.key),
                                        tooltip: 'Eliminar',
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                ],
              ),
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
      ),
    );
  }
}
