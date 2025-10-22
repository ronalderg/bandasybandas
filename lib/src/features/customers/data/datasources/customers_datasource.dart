import 'package:bandasybandas/src/features/customers/domain/models/customer_model.dart';

/// Interfaz abstracta para la fuente de datos de los customers.
///
/// Define los métodos que deben ser implementados por cualquier datasource
/// que gestione los customers, como obtener, crear, actualizar o eliminar.
abstract class CustomersDatasource {
  /// Obtiene un stream de la lista de customers desde la fuente de datos.
  Stream<List<CustomerModel>> getCustomers();

  /// Agrega un nuevo customer a la fuente de datos.
  Future<void> addCustomer(CustomerModel customer);
}
