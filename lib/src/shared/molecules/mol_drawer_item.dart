import 'package:flutter/material.dart';

class MolDrawerItem extends StatelessWidget {
  const MolDrawerItem({
    required this.icon,
    required this.text,
    required this.isColapsed,
    this.selected = false,
    super.key,
    this.onPressed,
  });

  final bool isColapsed;
  final bool selected;
  final VoidCallback? onPressed;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (isColapsed) {
      return IconButton(onPressed: onPressed, icon: Icon(icon));
    }
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onPressed,
    );
  }
}
