import 'package:bandasybandas/src/core/error/failures.dart';

import 'package:bandasybandas/src/features/customer_profile/domain/models/customer_product_model.dart';
import 'package:dartz/dartz.dart';

/// Interfaz abstracta para el repositorio de perfil de cliente.
///
/// Define las operaciones que se pueden realizar sobre los datos del perfil del cliente,
/// actuando como la única puerta de entrada a la capa de datos desde el dominio.
/// La capa de dominio solo depende de esta abstracción, no de su implementación.
abstract class CustomerProfileRepository {
  /// Obtiene un stream de los productos (máquinas) asociados a un cliente.
  /// Retorna un [Stream] que emite [Either] un [Failure] o una [List<CustomerProductModel>].
  Stream<Either<Failure, List<CustomerProductModel>>> getCustomerProducts(
    String customerId,
  );

  /// Agrega un nuevo producto al perfil del cliente.
  Future<Either<Failure, void>> addCustomerProduct(
    CustomerProductModel product,
  );

  /// Actualiza un producto existente en el perfil del cliente.
  Future<Either<Failure, void>> updateCustomerProduct(
    CustomerProductModel product,
  );
}
