import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:flutter/material.dart';

/// Un diálogo para visualizar los detalles de un [ItemModel] existente.
class ViewItemDialog extends StatelessWidget {
  const ViewItemDialog({required this.item, super.key});

  /// El item que se va a visualizar.
  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(item.name),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            _buildDetailRow(context, label: 'SKU', value: item.sku),
            if (item.description != null && item.description!.isNotEmpty)
              _buildDetailRow(
                context,
                label: l10n?.description ?? 'Descripción',
                value: item.description!,
              ),
            _buildDetailRow(
              context,
              label: l10n?.quantity ?? 'Cantidad',
              value: item.quantity.toString(),
            ),
            _buildDetailRow(
              context,
              label: l10n?.price ?? 'Precio',
              value: item.price.toStringAsFixed(2),
            ),
            if (item.observations != null && item.observations!.isNotEmpty)
              _buildDetailRow(
                context,
                label: 'Observaciones',
                value: item.observations!,
              ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n?.close ?? 'Cerrar'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Text.rich(
        TextSpan(
          style: Theme.of(context).textTheme.bodyLarge,
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
