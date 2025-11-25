import 'package:bandasybandas/src/features/inventory_management/domain/models/recipe_model.dart';
import 'package:equatable/equatable.dart';

abstract class RecipesPageState extends Equatable {
  const RecipesPageState();

  @override
  List<Object> get props => [];
}

class RecipesPageInitial extends RecipesPageState {}

class RecipesPageLoading extends RecipesPageState {}

class RecipesPageLoaded extends RecipesPageState {
  const RecipesPageLoaded(this.recipes);
  final List<RecipeModel> recipes;
  @override
  List<Object> get props => [recipes];
}

class RecipesPageError extends RecipesPageState {
  const RecipesPageError(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
