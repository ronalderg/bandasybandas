// lib/src/features/home/presentation/pages/home_page.dart
import 'package:bandasybandas/src/app/bloc/auth/auth_bloc.dart';
import 'package:bandasybandas/src/shared/organisms/org_app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDrawerExpanded = true;

  void _toggleDrawer() {
    setState(() {
      _isDrawerExpanded = !_isDrawerExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Usamos LayoutBuilder para adaptar la UI al tamaño de la pantalla.
    return LayoutBuilder(builder: (context, constraints) {
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
                      title: const Text('Inicio'),
                      automaticallyImplyLeading:
                          false, // No queremos el botón de hamburguesa
                    ),
                    const Expanded(
                      child: Center(
                        child: Text('¡Bienvenido! (Vista de Escritorio)'),
                      ),
                    ),
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
            title: const Text('Inicio'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                },
              ),
            ],
          ),
          drawer: const OrgAppDrawer(), // Drawer tradicional
          body: const Center(
            child: Text('¡Bienvenido! (Vista Móvil)'),
          ),
        );
      }
    });
  }
}
