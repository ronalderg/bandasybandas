import 'dart:convert';
import 'dart:ui' as ui;

import 'package:bandasybandas/src/app/app_config.dart';
import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_colors.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:universal_html/html.dart' as html;

/// Un diálogo que muestra un código QR generado a partir de una cadena de datos.
class QrDisplayDialog extends StatefulWidget {
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
  State<QrDisplayDialog> createState() => _QrDisplayDialogState();
}

class _QrDisplayDialogState extends State<QrDisplayDialog> {
  final GlobalKey _qrKey = GlobalKey();
  bool _isDownloading = false;

  Future<void> _downloadQR() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      // Capturar el widget QR como imagen
      final boundary =
          _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes == null) return;

      if (kIsWeb) {
        // Lógica para Web
        final base64 = base64Encode(pngBytes);
        final anchor = html.AnchorElement(href: 'data:image/png;base64,$base64')
          ..target = 'blank'
          ..download =
              'QR_${widget.title}_${DateTime.now().millisecondsSinceEpoch}.png';

        html.document.body?.append(anchor);
        anchor.click();
        anchor.remove();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✓ QR descargado'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Lógica para Móvil (Android/iOS)
        // Solicitar permisos de almacenamiento
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          // Intentar guardar de todos modos, ya que en Android 13+ READ_MEDIA_IMAGES es suficiente
          // y Permission.storage podría devolver denied permanentemente.
          // ImageGallerySaver maneja algunos permisos internamente también.

          // Si es Android 13+ (SDK 33), Permission.storage no es necesario/válido.
          // Podríamos chequear Permission.photos o simplemente intentar guardar.
        }

        // Guardar en la galería
        final result = await ImageGallerySaver.saveImage(
          pngBytes,
          quality: 100,
          name: 'QR_${widget.title}_${DateTime.now().millisecondsSinceEpoch}',
        );

        if (mounted) {
          if (result['isSuccess'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✓ QR guardado en la galería'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error al guardar el QR'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Construimos la URL completa para el código QR.
    final qrDataUrl = '${AppConfig.webBaseUrl}/products/${widget.data}';
    print(qrDataUrl);
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: Text(
        'Código QR para: ${widget.title}',
        style: const TextStyle(color: AppColors.black),
      ),
      content: SizedBox(
        width: 280, // Un tamaño fijo es bueno para un diálogo de QR.
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              key: _qrKey,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: QrImageView(
                  data: qrDataUrl,
                  //version: QrVersions.auto,
                  size: 250,
                  backgroundColor: Colors.white,
                ),
              ),
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
        OutlinedButton.icon(
          onPressed: _isDownloading ? null : _downloadQR,
          icon: _isDownloading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.download),
          label: Text(_isDownloading ? 'Guardando...' : 'Descargar QR'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n?.close ?? 'Cerrar'),
        ),
      ],
    );
  }
}
