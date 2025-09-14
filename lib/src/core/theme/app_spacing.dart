// lib/src/core/theme/app_spacing.dart
import 'package:flutter/widgets.dart'; // Para EdgeInsets y SizedBox

/// Define un sistema de espaciado consistente para la aplicación.
///
/// Esta clase contiene valores estandarizados para márgenes, paddings,
/// tamaños de huecos entre widgets y dimensiones fijas.
/// Usar estos valores ayuda a mantener una interfaz de usuario armoniosa
/// y facilita el diseño responsivo y el mantenimiento.
class AppSpacing {
  // Constructor privado para evitar instanciación, es una clase de utilidades estáticas.
  AppSpacing._();

  // --- Espaciados Generales (Escala Basada en 8dp grid) ---
  // Ideal para paddings y márgenes consistentes.

  /// Espacio extra pequeño (e.g., para elementos compactos o internos).
  static const double xxs = 2;

  /// Espacio extra pequeño (e.g., para elementos compactos o internos).
  static const double xs = 4;

  /// Espacio pequeño (e.g., entre elementos de una lista, iconos y texto).
  static const double sm = 8;

  /// Espacio medio (e.g., entre secciones, paddings de cards).
  static const double md = 16;

  /// Espacio grande (e.g., entre bloques de contenido importantes).
  static const double lg = 24;

  /// Espacio extra grande (e.g., secciones principales, separación de pantallas).
  static const double xl = 32;

  /// Espacio doble extra grande.
  static const double xxl = 48;

  /// Espacio triple extra grande.
  static const double xxxl = 64;

  // --- EdgeInsets (Paddings y Márgenes) ---
  // Define EdgeInsets predefinidos para facilitar su uso.

  /// Padding horizontal simétrico (e.g., en pantallas).
  static const EdgeInsets horizontalPadding =
      EdgeInsets.symmetric(horizontal: md);

  /// Padding vertical simétrico.
  static const EdgeInsets verticalPadding = EdgeInsets.symmetric(vertical: md);

  /// Padding simétrico en todos los lados.
  static const EdgeInsets allPadding = EdgeInsets.all(md);

  /// Padding pequeño en todos los lados.
  static const EdgeInsets allSmall = EdgeInsets.all(sm);

  /// Padding grande en todos los lados.
  static const EdgeInsets allLarge = EdgeInsets.all(lg);

  // --- Gaps (Espacios entre Widgets Flexibles - Column, Row) ---
  // Usar SizedBox para crear espacios fijos entre widgets.

  /// Un hueco vertical pequeño.
  static const Widget verticalGapSm = SizedBox(height: sm);

  /// Un hueco vertical medio.
  static const Widget verticalGapMd = SizedBox(height: md);

  /// Un hueco vertical grande.
  static const Widget verticalGapLg = SizedBox(height: lg);

  /// Un hueco horizontal pequeño.
  static const Widget horizontalGapSm = SizedBox(width: sm);

  /// Un hueco horizontal medio.
  static const Widget horizontalGapMd = SizedBox(width: md);

  /// Un hueco horizontal grande.
  static const Widget horizontalGapLg = SizedBox(width: lg);

  // --- Radios de Borde ---
  // Valores para `BorderRadius`.
  /// Radio de borde estándar para elementos como tarjetas y botones.
  static const double borderRadius = sm; // 8.0
}
