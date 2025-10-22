import 'dart:async';

import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/customers/domain/models/customer_model.dart';
import 'package:bandasybandas/src/features/customers/domain/usecases/customers_usecases.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_state.dart';

import 'package:bloc/bloc.dart';

class CustomersManagementCubit extends Cubit<CustomersManagementState> {
  CustomersManagementCubit({
    required this.getCustomers,
    required this.addCustomerUseCase,
  }) : super(CustomersPageInitial());

  final GetCustomers getCustomers;
  final AddCustomer addCustomerUseCase;
  StreamSubscription<List<CustomerModel>>? _customersSubscription;

  Future<void> loadCustomers() async {
    emit(CustomersPageLoading());

    final result = await getCustomers(NoParams());

    result.fold(
      (failure) => emit(
        CustomersPageError(
          'Falló la carga inicial de ítems: ${failure.message}',
        ),
      ),
      (customersStream) {
        _customersSubscription?.cancel();
        _customersSubscription = customersStream.listen((customers) {
          emit(CustomersPageLoaded(customers));
        });
      },
    );
  }

  Future<void> addCustomer(CustomerModel customer) async {
    // No se emite un estado de carga aquí para no bloquear toda la UI.
    // La actualización de la lista se manejará por el stream.
    final result = await addCustomerUseCase(customer);

    result.fold(
      (failure) => emit(
        CustomersPageError('Falló al agregar el ítem: ${failure.message}'),
      ),
      (_) {}, // En caso de éxito, no hacemos nada, el stream actualizará la UI.
    );
  }

  @override
  Future<void> close() {
    _customersSubscription?.cancel();
    return super.close();
  }
}
