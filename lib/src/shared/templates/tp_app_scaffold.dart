import 'package:bandasybandas/src/app/bloc/auth/auth_bloc.dart';
import 'package:bandasybandas/src/shared/organisms/org_app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Un Scaffold reutilizable que se adapta a diferentes tamaños de pantalla
/// y gestiona un drawer responsivo.
///
/// - En **escritorio/web**, muestra un `Drawer` permanente que se puede colapsar.
/// - En **móvil**, muestra un `Drawer` tradicional que se oculta.
class TpAppScaffold extends StatefulWidget {
  const TpAppScaffold({
    super.key,
    required this.body,
    required this.pageTitle,
  });

  final Widget body;
  final String pageTitle;

  @override
  State<TpAppScaffold> createState() => _TpAppScaffoldState();
}

class _TpAppScaffoldState extends State<TpAppScaffold> {
  bool _isDrawerExpanded = true;

  void _toggleDrawer() {
    setState(() {
      _isDrawerExpanded = !_isDrawerExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Usamos LayoutBuilder para adaptar la UI al tamaño de la pantalla.
    return LayoutBuilder(
      builder: (context, constraints) {
        // Punto de corte para cambiar entre layout móvil y de escritorio.
        const double breakpoint = 768;
        final bool isDesktop = constraints.maxWidth >= breakpoint;

        if (isDesktop) {
          // --- VISTA DE ESCRITORIO / WEB ---
          return Scaffold(
            body: Row(
              children: [
                // Drawer colapsable/expandible
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isDrawerExpanded ? 250 : 80,
                  child: OrgAppDrawer(
                    isPermanentlyDisplayed: true,
                    onToggle: _toggleDrawer,
                  ),
                ),
                // Contenido principal de la página
                Expanded(
                  child: Column(
                    children: [
                      AppBar(
                        title: Text(widget.pageTitle),
                        automaticallyImplyLeading:
                            false, // No queremos el botón de hamburguesa
                      ),
                      Expanded(child: widget.body),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          // --- VISTA MÓVIL ---
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.pageTitle),
            ),
            // El OrgAppDrawer ya sabe cómo comportarse en modo móvil
            drawer: const OrgAppDrawer(),
            body: widget.body,
          );
        }
      },
    );
  }
}
