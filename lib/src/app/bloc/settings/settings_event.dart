// --- Eventos ---
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// La clase base para todos los eventos relacionados con la configuración.
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cambiar el modo del tema (claro/oscuro).
class ThemeModeChanged extends SettingsEvent {
  const ThemeModeChanged(this.themeMode);
  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}
