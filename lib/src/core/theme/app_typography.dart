import 'package:bandasybandas/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// [AppTypography] define los estilos de texto y el tema de texto.
///
/// El uso de una clase dedicada para la tipografía asegura la consistencia
/// visual en toda la aplicación y facilita la realización de cambios globales
/// en el estilo del texto.
class AppTypography {
  // Constructor privado para evitar la instanciación.
  AppTypography._();

  // Define los pesos de fuente para facilitar su uso.
  static const FontWeight _light = FontWeight.w300;
  static const FontWeight _regular = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _semiBold = FontWeight.w600;
  static const FontWeight _bold = FontWeight.w700;

  /// Define la base de la tipografía sin colores.
  /// Contiene solo la configuración de fuentes (tamaño, peso).
  static const TextTheme _rawTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: _bold),
    displayMedium: TextStyle(fontSize: 45, fontWeight: _bold),
    displaySmall: TextStyle(fontSize: 36, fontWeight: _bold),
    headlineLarge: TextStyle(fontSize: 32, fontWeight: _semiBold),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: _semiBold),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: _semiBold),
    titleLarge: TextStyle(fontSize: 22, fontWeight: _medium),
    titleMedium: TextStyle(fontSize: 16, fontWeight: _medium),
    titleSmall: TextStyle(fontSize: 14, fontWeight: _medium),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: _regular),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: _regular),
    bodySmall: TextStyle(fontSize: 12, fontWeight: _regular),
    labelLarge: TextStyle(fontSize: 14, fontWeight: _medium),
    labelMedium: TextStyle(fontSize: 12, fontWeight: _medium),
    labelSmall: TextStyle(fontSize: 11, fontWeight: _light),
  );

  /// Tema de texto para el modo claro.
  ///
  /// Se utiliza `copyWith` para aplicar un color base a todos los estilos de
  /// texto, lo que facilita la adaptación a temas claros y oscuros.
  static final TextTheme lightTextTheme = _rawTextTheme.apply(
    bodyColor: AppColors.textColorPrimary,
    displayColor: AppColors.textColorPrimary,
  );

  /// Tema de texto para el modo oscuro.
  static final TextTheme darkTextTheme = _rawTextTheme.apply(
    bodyColor: AppColors.textColorInverse,
    displayColor: AppColors.textColorInverse,
  );
}
