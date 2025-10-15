import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/cubit/products_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/cubit/products_page_state.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/view/products_view.dart';
import 'package:bandasybandas/src/shared/templates/tp_app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Usamos MultiBlocProvider para proveer ambos Cubits a esta página y sus hijos.
    return MultiBlocProvider(
      providers: [
        // Proveemos el Cubit para las recetas.
        BlocProvider(create: (_) => sl<ProductsPageCubit>()..loadProducts()),
        // Proveemos el Cubit para los items, que será usado por el diálogo.
        BlocProvider(create: (_) => sl<ItemsCubit>()..loadItems()),
      ],
      child: TpAppScaffold(
        pageTitle: l10n?.products ?? 'Productos',
        body: SafeArea(
          child: BlocBuilder<ProductsPageCubit, ProductsPageState>(
            builder: (context, state) {
              if (state is ProductsPageInitial ||
                  state is ProductsPageLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductsPageLoaded) {
                return ProductsView(products: state.products);
              } else if (state is ProductsPageError) {
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
