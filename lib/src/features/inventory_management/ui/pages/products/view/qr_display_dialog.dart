import 'package:bandasybandas/src/app/app_config.dart';
import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_colors.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Un diálogo que muestra un código QR generado a partir de una cadena de datos.
class QrDisplayDialog extends StatelessWidget {
  const QrDisplayDialog({
    required this.data,
    required this.title,
    super.key,
  });

  /// Los datos que se codificarán en el QR (ej. el ID del producto).
  final String data;

  /// Un título descriptivo para mostrar sobre el QR.
  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Construimos la URL completa para el código QR.
    final qrDataUrl = '${AppConfig.webBaseUrl}/products/$data';

    return AlertDialog(
      backgroundColor: AppColors.white,
      title: Text(
        'Código QR para: $title',
        style: const TextStyle(color: AppColors.black),
      ),
      content: SizedBox(
        width: 280, // Un tamaño fijo es bueno para un diálogo de QR.
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: qrDataUrl,
              //version: QrVersions.auto,
              size: 250,
            ),
            AppSpacing.verticalGapMd,
            Text(
              'Escanea este código para identificar el producto.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.black),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n?.close ?? 'Cerrar'),
        ),
      ],
    );
  }
}
