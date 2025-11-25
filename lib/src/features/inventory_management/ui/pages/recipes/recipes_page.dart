import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/cubit/recipe_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/cubit/recipe_page_state.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/view/recipes_view.dart';
import 'package:bandasybandas/src/shared/templates/tp_app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Usamos MultiBlocProvider para proveer ambos Cubits a esta página y sus hijos.
    return MultiBlocProvider(
      providers: [
        // Proveemos el Cubit para las recetas.
        BlocProvider(create: (_) => sl<RecipesPageCubit>()..loadRecipes()),
        // Proveemos el Cubit para los items, que será usado por el diálogo.
        BlocProvider(create: (_) => sl<ItemsCubit>()..loadItems()),
      ],
      child: TpAppScaffold(
        pageTitle: l10n?.designs ?? '',
        body: SafeArea(
          child: BlocBuilder<RecipesPageCubit, RecipesPageState>(
            builder: (context, state) {
              if (state is RecipesPageInitial || state is RecipesPageLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RecipesPageLoaded) {
                return RecipesView(designs: state.recipes);
              } else if (state is RecipesPageError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
