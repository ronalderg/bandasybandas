import 'package:bandasybandas/src/shared/templates/tp_app_scaffold.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TpAppScaffold(
      pageTitle: 'Inicio',
      body: Center(
        child: Text('¡Bienvenido!'),
      ),
    );
  }
}
