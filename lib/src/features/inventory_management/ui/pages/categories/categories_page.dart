import 'package:bandasybandas/src/app/bloc/auth/auth_bloc.dart';
import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/categories/cubit/categories_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/categories/cubit/categories_state.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/categories/view/categories_view.dart';
import 'package:bandasybandas/src/shared/models/user_model.dart';
import 'package:bandasybandas/src/shared/templates/tp_app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Página principal de categorías.
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el usuario actual para determinar permisos
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    final userType = user.getTipoUsuario();
    // Sales Advisor tiene acceso de solo lectura
    final isReadOnly = userType == UserType.asesorIndustrial;

    return BlocProvider(
      create: (_) => sl<CategoriesCubit>()..loadCategories(),
      child: TpAppScaffold(
        pageTitle: 'Categorías',
        body: SafeArea(
          child: BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesInitial || state is CategoriesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoriesLoaded) {
                return CategoriesView(
                  categories: state.categories,
                  isReadOnly: isReadOnly,
                );
              } else if (state is CategoriesError) {
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
