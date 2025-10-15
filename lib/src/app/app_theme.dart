import 'package:bandasybandas/src/core/theme/app_colors.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// [AppTheme] proporciona una configuración centralizada para los temas de la
/// aplicación.
///
/// Define `lightTheme` y `darkTheme` para asegurar una apariencia consistente
/// en toda la aplicación, siguiendo las directrices de Material Design.
class AppTheme {
  // Constructor privado para evitar la instanciación.
  AppTheme._();

  /// Tema para el modo claro.
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    fontFamily: 'TuFuentePrincipal', // Reemplaza con el nombre de tu fuente

    // Esquema de colores del tema claro
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.backgroundLight,
      error: AppColors.errorColor,
      onSurface: AppColors.textColorPrimary,
    ),

    // Tema de texto
    textTheme: AppTypography.lightTextTheme,

    // Tema para AppBar
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white, // Color para íconos y título
      titleTextStyle: AppTypography.lightTextTheme.headlineSmall
          ?.copyWith(color: AppColors.white),
    ),

    // Tema para ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg,
        ),
        textStyle: AppTypography.lightTextTheme.labelLarge,
      ),
    ),

    // Tema para campos de texto
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      labelStyle: AppTypography.lightTextTheme.bodyMedium
          ?.copyWith(color: AppColors.textColorSecondary),
    ),

    // Tema para Cards
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      margin: const EdgeInsets.all(AppSpacing.sm),
    ),
  );

  /// Tema para el modo oscuro.
  /// Se basa en el tema claro y sobrescribe los colores.
  static final ThemeData darkTheme = lightTheme.copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surfaceDark,
      error: AppColors.errorColor,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onError: AppColors.white,
    ),
    appBarTheme: lightTheme.appBarTheme.copyWith(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textColorInverse,
      titleTextStyle: AppTypography.darkTextTheme.headlineSmall
          ?.copyWith(color: AppColors.textColorInverse),
    ),
    inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(
      labelStyle: AppTypography.darkTextTheme.bodyMedium
          ?.copyWith(color: AppColors.textColorHint),
    ),
    textTheme: AppTypography.darkTextTheme,
    // Tema para Iconos
    iconTheme: lightTheme.iconTheme.copyWith(
      color: AppColors.white, // Color blanco para íconos en modo oscuro
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textColorInverse,
      ),
    ),
  );
}
