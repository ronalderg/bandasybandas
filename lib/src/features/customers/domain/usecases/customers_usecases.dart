import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/customers/domain/models/customer_model.dart';
import 'package:bandasybandas/src/features/customers/domain/repositories/customers_repository.dart';
import 'package:dartz/dartz.dart';

/// Caso de uso para obtener la lista de clientes.
///
/// Extiende de [UseCase] y no requiere parámetros ([NoParams]).
/// Devuelve un [Stream] de `Either` para notificar cambios en tiempo real.
class GetCustomers extends UseCase<Stream<List<CustomerModel>>, NoParams> {
  GetCustomers(this.repository);
  final CustomersRepository repository;

  @override
  Future<Either<Failure, Stream<List<CustomerModel>>>> call(
    NoParams params,
  ) async {
    // El repositorio devuelve un Stream<Either<...>>, lo transformamos
    // para que el caso de uso devuelva un Either<Failure, Stream<...>>
    return Right(
      repository.getCustomers().map(
            (either) => either.fold((failure) => [], (customers) => customers),
          ),
    );
  }
}

/// Caso de uso para agregar un nuevo cliente.
///
/// Extiende de [UseCase] y requiere un [CustomerModel] como parámetro.
class AddCustomer extends UseCase<void, CustomerModel> {
  AddCustomer(this.repository);
  final CustomersRepository repository;

  @override
  Future<Either<Failure, void>> call(CustomerModel params) {
    return repository.addCustomer(params);
  }
}
