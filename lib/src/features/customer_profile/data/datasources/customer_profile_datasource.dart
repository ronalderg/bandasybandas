import 'package:bandasybandas/src/features/customer_profile/domain/models/customer_product_model.dart';

/// Interfaz abstracta para la fuente de datos del perfil de cliente.
///
/// Define el contrato que deben seguir las implementaciones concretas (como
/// Firestore, una API REST, o una base de datos local) para interactuar con
/// los datos del perfil del cliente.
abstract class CustomerProfileDatasource {
  /// Obtiene un stream que emite la lista de productos (máquinas) de un cliente.
  ///
  /// El stream se actualiza en tiempo real cada vez que hay un cambio
  /// en la fuente de datos.
  Stream<List<CustomerProductModel>> getCustomerProducts(String customerId);

  /// Agrega un nuevo producto al perfil del cliente.
  Future<void> addCustomerProduct(CustomerProductModel product);

  /// Actualiza un producto existente en el perfil del cliente.
  Future<void> updateCustomerProduct(CustomerProductModel product);
}
