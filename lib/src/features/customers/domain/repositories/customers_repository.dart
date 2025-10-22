import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/customers/domain/models/customer_model.dart';
import 'package:dartz/dartz.dart';

/// Interfaz abstracta para el repositorio de clientes.
///
/// Define las operaciones que se pueden realizar sobre los datos de los clientes,
/// actuando como la única puerta de entrada a la capa de datos desde el dominio.
/// La capa de dominio solo depende de esta abstracción, no de su implementación.
abstract class CustomersRepository {
  /// Obtiene un stream de la lista de clientes.
  /// Retorna un [Stream] que emite [Either] un [Failure] o una [List<CustomerModel>].
  Stream<Either<Failure, List<CustomerModel>>> getCustomers();

  /// Agrega un nuevo cliente.
  Future<Either<Failure, void>> addCustomer(CustomerModel customer);
}
