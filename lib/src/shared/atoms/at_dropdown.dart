import 'package:flutter/material.dart';

/// Componente atómico para DropdownButtonFormField con estilos consistentes.
///
/// Maneja automáticamente los colores para tema oscuro y claro.
class AtDropdown<T> extends StatelessWidget {
  const AtDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.hintText,
    this.validator,
    this.enabled = true,
    super.key,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hintText;
  final String? Function(T?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
      ),
      dropdownColor: isDarkMode ? Colors.grey[850] : null,
    );
  }
}
