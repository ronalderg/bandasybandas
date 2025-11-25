import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/recipe_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_state.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/cubit/recipe_page_cubit.dart';
import 'package:bandasybandas/src/shared/atoms/at_textfield_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:ronalderg_util/ronalderg_util.dart';

/// Un diálogo para editar un [RecipeModel] existente.
class EditRecipeDialog extends StatefulWidget {
  const EditRecipeDialog({
    required this.recipe,
    super.key,
  });

  /// La receta que se va a editar.
  final RecipeModel recipe;

  @override
  State<EditRecipeDialog> createState() => _EditRecipeDialogState();
}

class _EditRecipeDialogState extends State<EditRecipeDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _descriptionController;
  late List<RecipeItem> _items;
  String? _pdfUrl;

  @override
  void initState() {
    super.initState();
    // Inicializamos los controladores con los valores de la receta existente.
    _nameController = TextEditingController(text: widget.recipe.name);
    _skuController = TextEditingController(text: widget.recipe.sku);
    _descriptionController =
        TextEditingController(text: widget.recipe.description);
    _items = List.from(widget.recipe.items);
    _pdfUrl = widget.recipe.urlPdf;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Validar que se haya agregado al menos un item
      if (_items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes agregar al menos un item a la receta.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Creamos una copia de la receta original con los datos actualizados.
      final updatedRecipe = widget.recipe.copyWith(
        name: _nameController.text,
        sku: _skuController.text,
        description: _descriptionController.text,
        items: _items,
        urlPdf: _pdfUrl,
      );

      // Llamamos al cubit para que actualice la receta.
      context.read<RecipesPageCubit>().updateExistingRecipe(updatedRecipe);

      Navigator.of(context).pop(); // Cierra el diálogo
    }
  }

  void _showAddItemDialog(List<ItemModel> availableItems) {
    showDialog<RecipeItem>(
      context: context,
      builder: (_) => _SearchAndAddItemDialog(availableItems: availableItems),
    ).then((newItem) {
      if (newItem != null) {
        setState(() {
          // Evitar duplicados, opcionalmente se podría sumar la cantidad
          final index =
              _items.indexWhere((item) => item.itemId == newItem.itemId);
          if (index == -1) {
            _items.add(newItem);
          } else {
            // Opcional: actualizar la cantidad si ya existe
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('El item ya ha sido agregado.')),
            );
          }
        });
      }
    });
  }

  void _showPdfDropzoneDialog() {
    showDialog<String>(
      context: context,
      builder: (_) =>
          // Pasamos el cubit al diálogo para que pueda usar el repositorio.
          BlocProvider.value(
        value: context.read<RecipesPageCubit>(),
        child: const _PdfDropzoneDialog(),
      ),
    ).then((url) {
      if (url != null) setState(() => _pdfUrl = url);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      scrollable: true,
      title: Text('${l10n?.edit ?? 'Editar'} ${l10n?.design ?? 'Diseño'}'),
      content: Form(
        key: _formKey,
        // Envolvemos el contenido en un SizedBox para darle un tamaño definido al diálogo.
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8, // Ancho del 80%
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AtTextfieldText(
                label: l10n?.name ?? '',
                controller: _nameController,
                validator: FormValidators.notEmpty(
                  message: l10n?.error_field_required,
                ),
              ),
              AppSpacing.verticalGapSm,
              AtTextfieldText(
                label: 'SKU / Referencia',
                controller: _skuController,
              ),
              AppSpacing.verticalGapSm,
              AtTextfieldText(
                label: l10n?.description ?? '',
                controller: _descriptionController,
                maxLines: 3,
              ),
              const Divider(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Items', style: Theme.of(context).textTheme.titleMedium),
                  // Usamos un BlocBuilder para obtener el estado de ItemsCubit
                  // y así tener acceso a la lista de items disponibles.
                  BlocBuilder<ItemsCubit, ItemsPageState>(
                    builder: (context, state) {
                      if (state is ItemsPageLoaded) {
                        return ElevatedButton.icon(
                          onPressed: () => _showAddItemDialog(state.items),
                          icon: const Icon(Icons.add),
                          label: Text(l10n?.item ?? 'Item'),
                        );
                      }
                      // Muestra un botón deshabilitado si los items no están cargados
                      return ElevatedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.add),
                        label: Text(l10n?.item ?? 'Item'),
                      );
                    },
                  ),
                ],
              ),
              AppSpacing.verticalGapSm,
              // Lista de items agregados
              // Se reemplaza ListView.builder por una Column con un map.
              // Esto es más eficiente para listas cortas y evita los conflictos
              // de layout con viewports anidados dentro de un AlertDialog scrollable.
              Column(
                children: _items.map((recipeItem) {
                  return BlocBuilder<ItemsCubit, ItemsPageState>(
                    builder: (context, state) {
                      var itemName = 'Item no encontrado';
                      if (state is ItemsPageLoaded) {
                        final itemModel = state.items.firstWhere(
                          (it) => it.id == recipeItem.itemId,
                          orElse: () => ItemModel.empty,
                        );
                        if (itemModel.isNotEmpty) itemName = itemModel.name;
                      }
                      return ListTile(
                        title: Text(itemName),
                        subtitle: Text('Cantidad: ${recipeItem.quantity}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _items.remove(recipeItem);
                            });
                          },
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              AppSpacing.verticalGapMd,
              // Botón para subir PDF
              ListTile(
                leading: Icon(
                  Icons.picture_as_pdf,
                  color: _pdfUrl != null ? Colors.green : Colors.grey,
                ),
                title: Text(
                  _pdfUrl != null
                      ? 'Ficha técnica adjunta'
                      : 'Adjuntar ficha técnica (PDF)',
                ),
                subtitle: _pdfUrl != null
                    ? const Text('El archivo se ha subido correctamente.')
                    : null,
                trailing: IconButton(
                  icon: const Icon(Icons.upload_file),
                  onPressed: _showPdfDropzoneDialog,
                  tooltip: 'Subir PDF',
                ),
                onTap: _showPdfDropzoneDialog,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n?.cancel ?? ''),
        ),
        ElevatedButton(onPressed: _submit, child: Text(l10n?.save ?? '')),
      ],
    );
  }
}

/// Diálogo para arrastrar y soltar un archivo PDF.
class _PdfDropzoneDialog extends StatefulWidget {
  const _PdfDropzoneDialog();

  @override
  State<_PdfDropzoneDialog> createState() => _PdfDropzoneDialogState();
}

class _PdfDropzoneDialogState extends State<_PdfDropzoneDialog> {
  late DropzoneViewController _controller;
  bool _isHovering = false;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleDrop(DropzoneFileInterface event) async {
    setState(() {
      _isHovering = false;
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final fileName = await _controller.getFilename(event);
      final fileData = await _controller.getFileData(event);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subiendo archivo: $fileName')),
        );
        final url = await context
            .read<RecipesPageCubit>()
            .uploadPdf(fileData, fileName);
        if (mounted) {
          Navigator.of(context).pop(url);
        }
      }
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Error al subir el archivo. Inténtalo de nuevo. error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Subir Ficha Técnica'),
      content: SizedBox(
        height: 200,
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isHovering
                          ? colorScheme.primary
                          : colorScheme.onSurface.withAlpha(75),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                    color: _isHovering
                        ? colorScheme.primaryContainer.withAlpha(128)
                        : colorScheme.surfaceContainerHighest.withAlpha(128),
                  ),
                  child: Stack(
                    children: [
                      DropzoneView(
                        onCreated: (controller) => _controller = controller,
                        onDropFile: _handleDrop,
                        onHover: () => setState(() => _isHovering = true),
                        onLeave: () => setState(() => _isHovering = false),
                        operation: DragOperation.copy,
                      ),
                      const Center(child: Text('Arrastra un archivo PDF aquí')),
                    ],
                  ),
                ),
              ),
            if (_errorMessage != null) ...[
              AppSpacing.verticalGapSm,
              Text(_errorMessage!, style: TextStyle(color: colorScheme.error)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Un diálogo para buscar y agregar un item con su cantidad.
class _SearchAndAddItemDialog extends StatefulWidget {
  const _SearchAndAddItemDialog({required this.availableItems});

  final List<ItemModel> availableItems;

  @override
  State<_SearchAndAddItemDialog> createState() =>
      __SearchAndAddItemDialogState();
}

class __SearchAndAddItemDialogState extends State<_SearchAndAddItemDialog> {
  final _quantityController = TextEditingController();
  ItemModel? _selectedItem;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() {
    final quantity = double.tryParse(_quantityController.text);
    if (_selectedItem != null && quantity != null && quantity > 0) {
      final recipeItem = RecipeItem(
        itemId: _selectedItem!.id,
        quantity: quantity,
      );
      Navigator.of(context).pop(recipeItem);
    } else {
      // Mostrar error si es necesario
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona un item e ingresa una cantidad válida.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: const Text('Añadir Item a la Receta'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Autocomplete<ItemModel>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<ItemModel>.empty();
                }
                return widget.availableItems.where(
                  (item) => item.name
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()),
                );
              },
              displayStringForOption: (ItemModel option) => option.name,
              onSelected: (ItemModel selection) {
                setState(() {
                  _selectedItem = selection;
                });
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                return AtTextfieldText(
                  controller: controller,
                  focusNode: focusNode,
                  onEditingComplete: onEditingComplete,
                  label: l10n?.search ?? 'Buscar item...',
                  prefixIcon: const Icon(Icons.search),
                );
              },
            ),
            if (_selectedItem != null) ...[
              AppSpacing.verticalGapMd,
              Text('Item seleccionado: ${_selectedItem!.name}'),
              AppSpacing.verticalGapMd,
              AtTextfieldText(
                controller: _quantityController,
                label: l10n?.quantity ?? 'Cantidad',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: FormValidators.notEmpty(),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n?.cancel ?? 'Cancelar',
          ),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(l10n?.save ?? 'Guardar'),
        ),
      ],
    );
  }
}
