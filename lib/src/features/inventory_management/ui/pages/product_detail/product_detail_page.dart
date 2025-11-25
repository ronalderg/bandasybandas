import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/product_detail/cubit/product_detail_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/product_detail/cubit/product_detail_page_state.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/product_detail/view/product_detail_view.dart';
import 'package:bandasybandas/src/shared/templates/tp_app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({
    required this.productId,
    super.key,
  });

  final String productId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ProductDetailCubit>()..loadProduct(productId),
        ),
        // Proveemos ItemsCubit para poder resolver los nombres de los items.
        BlocProvider(create: (_) => sl<ItemsCubit>()..loadItems()),
      ],
      child: TpAppScaffold(
        pageTitle: l10n?.machine ?? 'Producto', //Producto/maquina
        body: SafeArea(
          child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
            builder: (context, state) {
              if (state is ProductDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ProductDetailLoaded) {
                // Asumiendo que ProductDetailView espera un solo ProductModel
                return ProductDetailView(product: state.product);
              }
              if (state is ProductDetailError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              // Estado inicial o no manejado
              return const Center(child: Text('Cargando producto...'));
            },
          ),
        ),
      ),
    );
  }
}
