import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/users/ui/pages/users/cubit/users_page_cubit.dart';
import 'package:bandasybandas/src/features/users/ui/pages/users/view/create_user_dialog.dart';
import 'package:bandasybandas/src/features/users/ui/pages/users/view/edit_user_dialog.dart';
import 'package:bandasybandas/src/shared/models/user_model.dart';
// Asume la ruta del modelo de usuario compartido. Ajústala si es necesario.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersView extends StatelessWidget {
  const UsersView({required this.users, super.key});
  final List<AppUser> users;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
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
                l10n?.users ?? 'Usuarios',
                style: theme.textTheme.headlineSmall,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return CreateUserDialog(
                        cubit: context.read<UsersPageCubit>(),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add),
                label: Text(l10n?.create_new_user ?? 'Nuevo Usuario'),
              ),
            ],
          ),
          AppSpacing.verticalGapLg,

          // Mensaje si la lista está vacía
          if (users.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text('${l10n?.there_are_no_users_registered}.'),
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
                      showDialog<void>(
                        context: context,
                        builder: (_) {
                          return EditUserDialog(
                            user: user,
                            cubit: context.read<UsersPageCubit>(),
                          );
                        },
                      );
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
