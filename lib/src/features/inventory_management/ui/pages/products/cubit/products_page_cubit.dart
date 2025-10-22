import 'dart:async';

import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/products_usecases.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/cubit/products_page_state.dart';
import 'package:bloc/bloc.dart';

class ProductsPageCubit extends Cubit<ProductsPageState> {
  ProductsPageCubit({
    required this.getProducts,
    required this.addProduct,
  }) : super(ProductsPageInitial());

  final GetProducts getProducts;
  final AddProduct addProduct;
  StreamSubscription<List<ProductModel>>? _productsSubscription;

  Future<void> loadProducts() async {
    emit(ProductsPageLoading());
    final result = await getProducts(NoParams());
    result.fold(
      (failure) => emit(
        ProductsPageError('Error al cargar productos: ${failure.message}'),
      ),
      (stream) {
        _productsSubscription?.cancel();
        _productsSubscription = stream.listen((products) {
          emit(ProductsPageLoaded(products));
        });
      },
    );
  }

  Future<void> createProduct(ProductModel product) async {
    final result = await addProduct(product);
    result.fold(
      (failure) => emit(
        ProductsPageError('Error al crear producto: ${failure.message}'),
      ),
      (_) {
        // El stream se encargará de actualizar la lista, no es necesario emitir aquí.
      },
    );
  }

  @override
  Future<void> close() {
    _productsSubscription?.cancel();
    return super.close();
  }
}
