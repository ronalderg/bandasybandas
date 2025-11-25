import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/recipe_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/cubit/products_page_cubit.dart';
import 'package:bandasybandas/src/shared/atoms/at_textfield_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronalderg_util/ronalderg_util.dart';

/// Un diálogo para editar un [ProductModel] existente.
class EditProductDialog extends StatefulWidget {
  const EditProductDialog({
    required this.product,
    required this.availableRecipes,
    super.key,
  });

  /// El producto que se va a editar.
  final ProductModel product;

  /// Lista de recetas disponibles para seleccionar.
  final List<RecipeModel> availableRecipes;

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _serialController;
  late final TextEditingController _categoryController;
  late final TextEditingController _quantityController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  String? _selectedRecipeId;
  List<RecipeItem> _selectedRecipeItems = [];

  @override
  void initState() {
    super.initState();
    // Inicializamos los controladores con los valores del producto existente.
    _nameController = TextEditingController(text: widget.product.name);
    _skuController = TextEditingController(text: widget.product.sku);
    _serialController = TextEditingController(text: widget.product.serial);
    _categoryController = TextEditingController(text: widget.product.category);
    _quantityController =
        TextEditingController(text: widget.product.quantity.toString());
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(
      text: widget.product.price?.toString() ?? '',
    );
    _selectedRecipeId = widget.product.recipeId;
    _selectedRecipeItems = widget.product.items;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _serialController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Creamos una copia del producto original con los datos actualizados.
      final updatedProduct = widget.product.copyWith(
        name: _nameController.text,
        sku: _skuController.text,
        serial: _serialController.text,
        category: _categoryController.text,
        quantity: double.tryParse(_quantityController.text) ?? 1.0,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text),
        recipeId: _selectedRecipeId,
        items: _selectedRecipeItems,
      );

      // Llamamos al cubit para que actualice el producto.
      context.read<ProductsPageCubit>().updateExistingProduct(updatedProduct);

      Navigator.of(context).pop(); // Cierra el diálogo
    }
  }

  void _onRecipeSelected(RecipeModel recipe) {
    setState(() {
      _selectedRecipeId = recipe.id;
      _selectedRecipeItems = recipe.items;
      // Opcionalmente, puedes actualizar otros campos basados en la receta
      // _nameController.text = recipe.name;
      // _skuController.text = recipe.sku;
      // _descriptionController.text = recipe.description ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      scrollable: true,
      title: Text(l10n?.edit_product ?? 'Editar Producto'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Selector de Diseño/Receta ---
              if (widget.availableRecipes.isNotEmpty) ...[
                Text(
                  'Basado en el diseño:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                AppSpacing.verticalGapSm,
                Autocomplete<RecipeModel>(
                  initialValue: _selectedRecipeId != null
                      ? TextEditingValue(
                          text: widget.availableRecipes
                              .firstWhere(
                                (r) => r.id == _selectedRecipeId,
                                orElse: () => widget.availableRecipes.first,
                              )
                              .name,
                        )
                      : TextEditingValue.empty,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<RecipeModel>.empty();
                    }
                    return widget.availableRecipes.where(
                      (recipe) => recipe.name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()),
                    );
                  },
                  displayStringForOption: (RecipeModel option) =>
                      '${option.name} (SKU: ${option.sku})',
                  onSelected: _onRecipeSelected,
                  fieldViewBuilder:
                      (context, controller, focusNode, onEditingComplete) {
                    return AtTextfieldText(
                      controller: controller,
                      focusNode: focusNode,
                      onEditingComplete: onEditingComplete,
                      label: l10n?.search_design ?? 'Buscar diseño...',
                      prefixIcon: const Icon(Icons.search),
                    );
                  },
                  optionsViewBuilder: (
                    BuildContext context,
                    AutocompleteOnSelected<RecipeModel> onSelected,
                    Iterable<RecipeModel> options,
                  ) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        color: Theme.of(context).colorScheme.surface,
                        elevation: 4,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: options.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              final option = options.elementAt(index);
                              return ListTile(
                                title: Text(
                                  '${option.name} (SKU: ${option.sku})',
                                ),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: AppSpacing.lg),
              ],

              // --- Campos del Producto ---
              AtTextfieldText(
                label: l10n?.name ?? 'Nombre',
                controller: _nameController,
                validator: FormValidators.notEmpty(
                  message: l10n?.error_field_required,
                ),
              ),
              AppSpacing.verticalGapSm,
              Row(
                children: [
                  Expanded(
                    child: AtTextfieldText(
                      label: 'SKU / Referencia',
                      controller: _skuController,
                      validator: FormValidators.notEmpty(),
                    ),
                  ),
                  AppSpacing.horizontalGapSm,
                  Expanded(
                    child: AtTextfieldText(
                      label: 'Serial',
                      controller: _serialController,
                    ),
                  ),
                ],
              ),
              AppSpacing.verticalGapSm,
              Row(
                children: [
                  Expanded(
                    child: AtTextfieldText(
                      label: 'Categoría',
                      controller: _categoryController,
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
              AppSpacing.verticalGapSm,
              AtTextfieldText(
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
              AppSpacing.verticalGapSm,
              AtTextfieldText(
                label: l10n?.description ?? 'Descripción',
                controller: _descriptionController,
                maxLines: 3,
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
