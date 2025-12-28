import 'package:bandasybandas/src/app/bloc/auth/auth_bloc.dart';
import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/app/router/app_routes.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/shared/models/user_model.dart';
import 'package:bandasybandas/src/shared/models/vm_drawer_item_data.dart';
import 'package:bandasybandas/src/shared/molecules/mol_drawer_expansion_tile.dart';
import 'package:bandasybandas/src/shared/molecules/mol_drawer_header.dart';
import 'package:bandasybandas/src/shared/molecules/mol_drawer_item.dart';
import 'package:bandasybandas/src/shared/navigation/app_drawer_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

  List<VmDrawerItemData> _getDrawerItemsForUser(
    AppUser user,
    AppLocalizations l10n,
  ) {
    final userType = user.getTipoUsuario();
    // Items comunes para todos los usuarios autenticados
    final baseItems = <VmDrawerItemData>[
      VmDrawerItemData(
        icon: Icons.home,
        label: l10n.home,
        route: AppRoutes.home,
      ),
    ];

    // Items específicos por rol
    switch (userType) {
      case UserType.gerente:
        baseItems.addAll(getGerenteDrawerItems(l10n));
      case UserType.tecnico:
        baseItems.addAll(getTechnicalDrawerItems(l10n));
      case UserType.asesorIndustrial:
        baseItems.addAll(getSalesAdvisorDrawerItems(l10n));
      case UserType.pmi:
      case UserType.gerenteComercial:
      case UserType.clienteAdministrador:
        baseItems.addAll(getClienteAdminDrawerItems(l10n));
      case UserType.cliente:
        baseItems.addAll(getClienteDrawerItems(l10n));
      case UserType.none:
        // Usuario sin tipo asignado - mostrar solo items base
        debugPrint('⚠️ Usuario sin tipo asignado: ${user.email}');
        baseItems.add(
          VmDrawerItemData(
            icon: Icons.warning,
            label: 'Tipo de usuario no asignado',
            route: '',
          ),
        );
    }

    return baseItems;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
          // Añadimos esta línea para eliminar las esquinas redondeadas.
          shape: const RoundedRectangleBorder(),
          child: Column(
            children: [
              // Encabezado del Drawer
              SizedBox(
                height: 120,
                child: MolDrawerHeader(
                  isColapsed: isCollapsed,
                  title: user.fullName.isNotEmpty ? user.fullName : user.email,
                  subtitle: user.userType ?? '',
                ),
              ),
              // Lista de items de navegación
              Expanded(
                child: ListView.builder(
                  itemCount: drawerItems.length,
                  itemBuilder: (context, index) {
                    final item = drawerItems[index];

                    // Si el item es expandible, usa MolDrawerExpansionTile
                    if (item.isExpandable) {
                      return MolDrawerExpansionTile(
                        icon: item.icon,
                        title: item.label,
                        onTap: () {}, // El onTap del padre no hace nada
                        children: item.children.map((child) {
                          return Padding(
                            padding: const EdgeInsets.only(left: AppSpacing.md),
                            child: MolDrawerItem(
                              icon: child.icon,
                              text: child.label,
                              isColapsed: isCollapsed,
                              onPressed: () =>
                                  _onItemTapped(index, child.route!),
                              // La selección podría necesitar una lógica más compleja
                              // para resaltar el padre cuando un hijo está activo.
                              //selected: false,
                            ),
                          );
                        }).toList(),
                      );
                    }

                    // Si no, usa el MolDrawerItem normal
                    return MolDrawerItem(
                      icon: item.icon,
                      text: item.label,
                      isColapsed: isCollapsed,
                      onPressed: () => _onItemTapped(index, item.route!),
                      selected: _selectedIndex == index,
                    );
                  },
                ),
              ),
              // Botón de cerrar sesión
              const Divider(height: 1),
              MolDrawerItem(
                icon: Icons.logout,
                text: l10n.logout,
                isColapsed: isCollapsed,
                onPressed: () {
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
