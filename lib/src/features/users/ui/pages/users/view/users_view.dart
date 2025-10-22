import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/shared/models/user.dart';
// Asume la ruta del modelo de usuario compartido. Ajústala si es necesario.
import 'package:flutter/material.dart';

class UsersView extends StatelessWidget {
  const UsersView({required this.users, super.key});
  final List<AppUser> users;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado con título y botón
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Usuarios',
                style: theme.textTheme.headlineSmall,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO(user): Implementar diálogo para crear usuario
                },
                icon: const Icon(Icons.add),
                label: const Text('Nuevo Usuario'),
              ),
            ],
          ),
          AppSpacing.verticalGapLg,

          // Mensaje si la lista está vacía
          if (users.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text('No hay usuarios registrados.'),
              ),
            )
          else
            // Lista de usuarios
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(
                    user.fullName.isNotEmpty ? user.fullName : user.email,
                  ), // Muestra nombre completo o email
                  subtitle: Text(user.userType ?? 'Tipo no especificado'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // TODO(user): Implementar edición de usuario
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
