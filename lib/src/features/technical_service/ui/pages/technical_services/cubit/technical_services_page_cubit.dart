import 'dart:async';

import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/technical_service/domain/models/technical_service_model.dart';
import 'package:bandasybandas/src/features/technical_service/domain/usecases/technical_service_usecases.dart';
import 'package:bandasybandas/src/features/technical_service/ui/pages/technical_services/cubit/technical_services_page_state.dart';
import 'package:bloc/bloc.dart';

class TechnicalServicesPageCubit extends Cubit<TechnicalServicesPageState> {
  TechnicalServicesPageCubit({
    required this.getTechnicalServices,
    required this.addTechnicalServiceUseCase,
    required this.updateTechnicalServiceUseCase,
  }) : super(TechnicalServicesPageInitial());

  final GetTechnicalServices getTechnicalServices;
  final AddTechnicalService addTechnicalServiceUseCase;
  final UpdateTechnicalService updateTechnicalServiceUseCase;
  StreamSubscription<List<TechnicalServiceModel>>? _servicesSubscription;

  Future<void> loadTechnicalServices() async {
    emit(TechnicalServicesPageLoading());

    final result = await getTechnicalServices(NoParams());

    result.fold(
      (failure) => emit(
        TechnicalServicesPageError(
          'Falló la carga inicial de servicios técnicos: ${failure.message}',
        ),
      ),
      (servicesStream) {
        _servicesSubscription?.cancel();
        _servicesSubscription = servicesStream.listen((services) {
          emit(TechnicalServicesPageLoaded(services));
        });
      },
    );
  }

  Future<void> addTechnicalService(TechnicalServiceModel service) async {
    // No se emite un estado de carga aquí para no bloquear toda la UI.
    // La actualización de la lista se manejará por el stream.
    final result = await addTechnicalServiceUseCase(service);

    result.fold(
      (failure) => emit(
        TechnicalServicesPageError(
          'Falló al agregar el servicio técnico: ${failure.message}',
        ),
      ),
      (_) {}, // En caso de éxito, no hacemos nada, el stream actualizará la UI.
    );
  }

  Future<void> updateTechnicalService(TechnicalServiceModel service) async {
    // No emitimos un estado de carga para una mejor experiencia de usuario.
    // La UI se actualizará automáticamente a través del stream de la lista.
    final result = await updateTechnicalServiceUseCase(service);

    result.fold(
      (failure) => emit(
        TechnicalServicesPageError(
          'Falló al actualizar el servicio técnico: ${failure.message}',
        ),
      ),
      (_) {}, // En caso de éxito, no hacemos nada; el stream se encarga.
    );
  }

  @override
  Future<void> close() {
    _servicesSubscription?.cancel();
    return super.close();
  }
}
