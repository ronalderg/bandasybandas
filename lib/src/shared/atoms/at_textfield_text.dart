import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AtTextfieldText extends StatelessWidget {
  const AtTextfieldText({
    required this.label,
    required this.controller,
    this.validator,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.inputFormatters,
    super.key,
    this.focusNode,
    this.onEditingComplete,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
    );
  }
}
