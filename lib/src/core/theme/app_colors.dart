// lib/src/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Define la paleta de colores central de la aplicación.
///
/// Esta clase contiene todos los tokens de color primarios y secundarios
/// que deben ser utilizados consistentemente en toda la interfaz de usuario.
/// Esto asegura una identidad de marca coherente y facilita los cambios de tema.
class AppColors {
  // Constructor privado para evitar instanciación, es una clase de utilidades estáticas.
  AppColors._();

  // --- Colores Primarios y de Marca ---
  static const Color primary = Color(0xFF00388d);
  static const Color primaryDark = Color(0xFF16A085);
  static const Color secondary = Color(0xFFFF0000);
  static const Color onPrimar = Colors.white;

  static const Color accentColor = Color(0xFF3498DB);
  static const Color accentColorDark = Color(0xFF2980B9);
  static const Color onAccentColor = Colors.white;

  // --- Colores de Fondo y Superficie ---
  static const Color backgroundLight = Color(0xFFF0F2F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight =
      Colors.white; // Color para tarjetas, modales, etc. en tema claro
  static const Color surfaceDark =
      Color(0xFF1E1E1E); // Color para tarjetas, modales, etc. en tema oscuro
  static const Color borderColor =
      Color(0xFFE0E0E0); // Color para bordes de inputs, divisores

  // --- Colores de Texto ---
  static const Color textColorPrimary =
      Color(0xFF333333); // Color principal para texto oscuro
  static const Color textColorSecondary = Color(
    0xFF757575,
  ); // Color secundario para texto oscuro (menos prominente)
  static const Color textColorInverse =
      Colors.white; // Color para texto sobre fondos oscuros
  static const Color textColorHint =
      Color(0xFFBDBDBD); // Color para texto de placeholder/sugerencia

  // --- Colores de Estado / Semánticos ---
  static const Color successColor = Color(0xFF2ECC71); // Verde para éxito
  static const Color warningColor =
      Color(0xFFF39C12); // Naranja para advertencia
  static const Color errorColor = Color(0xFFE74C3C); // Rojo para error
  static const Color infoColor = Color(0xFF3498DB); // Azul para información

  //APP
  static const Color red = Color.fromARGB(255, 255, 0, 0);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color black = Color.fromARGB(255, 0, 0, 0);
  static const Color redEmerald = Color(0xFFE12D29);

  static const Color blueBandas = Color(0xFF00388d);
  static const Color blueSky = Color(0xFF007aff);

  // --- Colores Dashboard ---
  static const Color dashboardBlue = Colors.blue;
  static const Color dashboardGreen = Colors.green;
  static const Color dashboardOrange = Colors.orange;
  static const Color dashboardPurple = Colors.purple;
  static const Color dashboardPink = Colors.pink;
  static const Color dashboardTeal = Colors.teal;
  static const Color dashboardRed = Colors.red;
}
