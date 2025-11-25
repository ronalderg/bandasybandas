/// Enum para representar el estado de un componente dentro de un producto/máquina.
enum ComponentStatus {
  /// Componente actualmente en uso y funcionando.
  active,

  /// Componente que fue reemplazado por otro.
  replaced,

  /// Componente removido sin reemplazo inmediato.
  removed,

  /// Componente que falló y necesita ser reemplazado.
  failed,
}
