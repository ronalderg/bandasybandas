import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/models/customer_product_model.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/repositories/customer_profile_repository.dart';
import 'package:dartz/dartz.dart';

/// Use case para actualizar un producto existente en el perfil del cliente.
class UpdateCustomerProduct {
  const UpdateCustomerProduct(this._repository);

  final CustomerProfileRepository _repository;

  Future<Either<Failure, void>> call(CustomerProductModel product) {
    return _repository.updateCustomerProduct(product);
  }
}
