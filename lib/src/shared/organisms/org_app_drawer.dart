import 'package:bandasybandas/src/app/bloc/auth/auth_bloc.dart';
import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class _DrawerItem {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;
}

class OrgAppDrawer extends StatefulWidget {
  const OrgAppDrawer({
    super.key,
    this.isPermanentlyDisplayed = false,
    this.onToggle,
  });

  final bool isPermanentlyDisplayed;
  final VoidCallback? onToggle;

  @override
  State<OrgAppDrawer> createState() => _OrgAppDrawerState();
}

class _OrgAppDrawerState extends State<OrgAppDrawer> {
  int _selectedIndex = 0;

  void _onItemTapped(int index, String route) {
    if (route.isEmpty) return;

    setState(() {
      _selectedIndex = index;
    });
    context.go(route);

    // Si no es un drawer permanente (modo móvil), ciérralo tras la selección.
    if (!widget.isPermanentlyDisplayed) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final drawerItems = <_DrawerItem>[
      _DrawerItem(icon: Icons.home, label: l10n.home, route: AppRoutes.home),
      // Puedes añadir más items aquí, por ejemplo:
      // _DrawerItem(icon: Icons.settings, label: l10n.settings, route: AppRoutes.settings),
    ];

    return Drawer(
      elevation: widget.isPermanentlyDisplayed ? 1 : 16,
      child: Column(
        children: [
          // Encabezado del Drawer
          SizedBox(
            height: 120,
            child: DrawerHeader(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              child: Center(
                child: Text(
                  'SIG',
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(color: theme.colorScheme.primary),
                ),
              ),
            ),
          ),
          // Lista de items de navegación
          Expanded(
            child: ListView.builder(
              itemCount: drawerItems.length,
              itemBuilder: (context, index) {
                final item = drawerItems[index];
                return ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.label),
                  selected: _selectedIndex == index,
                  onTap: () => _onItemTapped(index, item.route),
                );
              },
            ),
          ),
          // Botón de cerrar sesión
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.logout),
            onTap: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
          // Botón para colapsar/expandir (solo en modo permanente)
          if (widget.isPermanentlyDisplayed) ...[
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.menu_open),
              title: const Text('Colapsar'),
              onTap: widget.onToggle,
            ),
          ],
          AppSpacing.verticalGapSm,
        ],
      ),
    );
  }
}
