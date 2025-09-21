import 'package:bandasybandas/src/app/bloc/auth/auth_bloc.dart';
import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/shared/domain/models/user.dart';
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

  List<_DrawerItem> _getDrawerItemsForUser(
    AppUser user,
    AppLocalizations l10n,
  ) {
    final userType = user.getTipoUsuario();

    // Items comunes para todos los usuarios autenticados
    final baseItems = <_DrawerItem>[
      _DrawerItem(icon: Icons.home, label: l10n.home, route: AppRoutes.home),
    ];

    // Items específicos por rol
    switch (userType) {
      case UserType.gerente:
        // Añadir items solo para gerentes
        // baseItems.add(_DrawerItem(icon: Icons.dashboard, label: 'Dashboard', route: '/dashboard'));
        break;
      case UserType.tecnico:
        // Añadir items solo para técnicos
        // baseItems.add(_DrawerItem(icon: Icons.build, label: 'Órdenes de Trabajo', route: '/work-orders'));
        break;
      // Añadir más casos para otros roles
      case UserType.asesorIndustrial:
      case UserType.pmi:
      case UserType.gerenteComercial:
      case UserType.none:
        break;
    }

    return baseItems;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    // Obtenemos el usuario actual desde el AuthBloc
    final user = context.select((AuthBloc bloc) => bloc.state.user);

    // Generamos los items del drawer dinámicamente según el usuario
    final drawerItems = _getDrawerItemsForUser(user, l10n);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Si el ancho es menor a 100, consideramos que está colapsado.
        final isCollapsed = constraints.maxWidth < 100;

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
                    child: isCollapsed
                        ? Icon(
                            Icons.ac_unit, // Reemplaza con tu logo
                            color: theme.colorScheme.primary,
                            size: 32,
                          )
                        : Text(
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
                      title: isCollapsed ? null : Text(item.label),
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
                title: isCollapsed ? null : Text(l10n.logout),
                onTap: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                },
              ),
              // Botón para colapsar/expandir (solo en modo permanente)
              if (widget.isPermanentlyDisplayed)
                _buildToggleCollapseButton(isCollapsed),
              if (!isCollapsed) AppSpacing.verticalGapSm,
            ],
          ),
        );
      },
    );
  }

  Widget _buildToggleCollapseButton(bool isCollapsed) {
    return Column(
      children: [
        const Divider(height: 1),
        if (isCollapsed)
          InkWell(
            onTap: widget.onToggle,
            child: const SizedBox(
              height: kMinInteractiveDimension,
              width: double.infinity,
              child: Icon(Icons.chevron_right),
            ),
          )
        else
          ListTile(
            leading: const Icon(Icons.menu_open),
            title: const Text('Colapsar'),
            onTap: widget.onToggle,
          ),
      ],
    );
  }
}
