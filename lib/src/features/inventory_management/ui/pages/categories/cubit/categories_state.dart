import 'package:bandasybandas/src/features/inventory_management/domain/models/category_model.dart';
import 'package:equatable/equatable.dart';

/// Estados para la gestión de categorías.
abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial.
class CategoriesInitial extends CategoriesState {}

/// Estado de carga.
class CategoriesLoading extends CategoriesState {}

/// Estado cuando las categorías se han cargado exitosamente.
class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded(this.categories);

  final List<CategoryModel> categories;

  @override
  List<Object?> get props => [categories];
}

/// Estado de error.
class CategoriesError extends CategoriesState {
  const CategoriesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
