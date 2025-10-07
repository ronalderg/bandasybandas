import 'package:bandasybandas/src/features/inventory_management/domain/models/desing_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/view/desing_view.dart';
import 'package:flutter/material.dart';

class DesingPage extends StatelessWidget {
  const DesingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Aquí conectarías tu BLoC o Provider para obtener los datos reales.
    // Por ahora, usamos datos de ejemplo.
    final desings = [
      DesingModel(
        id: '1',
        name: 'Diseño Floral 2024',
        description: 'Colección de primavera',
      ),
      DesingModel(
        id: '2',
        name: 'Diseño Geométrico',
        description: 'Patrones modernos',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Diseños')),
      body: DesingView(desings: desings),
    );
  }
}
