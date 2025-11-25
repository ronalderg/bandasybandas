/// Enum para representar los estados de un producto en el cliente.
enum CustomerProductStatus {
  /// Producto trasladado al cliente.
  transferred,

  /// Producto en inventario del cliente.
  inventory,

  /// Producto en uso por el cliente.
  inUse,

  /// Producto desechado.
  discarded,

  /// Producto en mantenimiento.
  maintenance,
}
