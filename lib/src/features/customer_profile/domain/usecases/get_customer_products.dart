import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/models/customer_product_model.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/repositories/customer_profile_repository.dart';
import 'package:dartz/dartz.dart';

/// Caso de uso para obtener los productos (máquinas) de un cliente.
///
/// Este caso de uso encapsula la lógica de negocio para recuperar
/// la lista de productos asociados a un cliente específico.
class GetCustomerProducts {
  /// Constructor que inyecta el repositorio necesario.
  const GetCustomerProducts(this._repository);

  final CustomerProfileRepository _repository;

  /// Ejecuta el caso de uso.
  ///
  /// [customerId] El ID del cliente del cual obtener los productos.
  /// Retorna un [Stream] que emite [Either] un [Failure] o una lista de [CustomerProductModel].
  Stream<Either<Failure, List<CustomerProductModel>>> call(String customerId) {
    return _repository.getCustomerProducts(customerId);
  }
}
