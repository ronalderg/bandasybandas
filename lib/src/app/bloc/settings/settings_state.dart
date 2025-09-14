import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// El estado de la configuración de la aplicación.
class SettingsState extends Equatable {
  const SettingsState({
    this.themeMode = ThemeMode.system, // Por defecto, sigue el sistema.
    this.locale,
  });

  final ThemeMode themeMode;
  final Locale? locale;

  @override
  List<Object?> get props => [themeMode, locale];
}
