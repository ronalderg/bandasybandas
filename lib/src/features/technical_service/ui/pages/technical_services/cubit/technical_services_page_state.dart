import 'package:bandasybandas/src/features/technical_service/domain/models/technical_service_model.dart';
import 'package:equatable/equatable.dart';

abstract class TechnicalServicesPageState extends Equatable {
  const TechnicalServicesPageState();

  @override
  List<Object> get props => [];
}

class TechnicalServicesPageInitial extends TechnicalServicesPageState {}

class TechnicalServicesPageLoading extends TechnicalServicesPageState {}

class TechnicalServicesPageLoaded extends TechnicalServicesPageState {
  const TechnicalServicesPageLoaded(this.services);
  final List<TechnicalServiceModel> services;

  @override
  List<Object> get props => [services];
}

class TechnicalServicesPageError extends TechnicalServicesPageState {
  const TechnicalServicesPageError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
