import 'package:flutter/material.dart';

class MolDrawerExpansionTile extends StatefulWidget {
  const MolDrawerExpansionTile({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.children,
    super.key,
  });
  final String title;

  final IconData icon;
  final VoidCallback onTap;
  final List<Widget> children;

  @override
  State<MolDrawerExpansionTile> createState() => _MolDrawerExpansionTileState();
}

class _MolDrawerExpansionTileState extends State<MolDrawerExpansionTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // En modo oscuro, forzamos el color a blanco. En modo claro, dejamos que el tema decida.
    final color = isDarkMode ? Colors.white : null;

    return ExpansionTile(
      leading: Icon(
        widget.icon,
      ),
      // Color del icono cuando el tile está expandido.
      iconColor: color,
      // Color del icono cuando el tile está colapsado.
      collapsedIconColor: color,
      title: Text(
        widget.title,
      ),
      children: widget.children,
    );
  }
}
