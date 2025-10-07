import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/desing_model.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/view/create_desing_dialog.dart';
import 'package:flutter/material.dart';

class DesingView extends StatelessWidget {
  const DesingView({required this.desings, super.key});

  final List<DesingModel> desings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
                l10n.desings,
                style: theme.textTheme.headlineSmall,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return const CreateDesingDialog();
                    },
                  );
                },
                icon: const Icon(Icons.add),
                label: Text('Nuevo ${l10n.desing}'),
              ),
            ],
          ),
          AppSpacing.verticalGapLg,

          // Mensaje si la lista está vacía
          if (desings.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child:
                    Text('No hay ${l10n.desings.toLowerCase()} registrados.'),
              ),
            )
          else
            // Lista de diseños
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: desings.length,
              itemBuilder: (context, index) {
                final desing = desings[index];
                // TODO(Ronder): Reemplazar con un widget de molécula específico para diseños si es necesario.
                return ListTile(
                  title: Text(desing.name),
                  subtitle: Text(desing.description ?? ''),
                  trailing: const Icon(Icons.more_vert),
                );
              },
            ),
        ],
      ),
    );
  }
}
