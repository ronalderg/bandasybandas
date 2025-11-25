import 'dart:async';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/products_usecases.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/product_detail/cubit/product_detail_page_state.dart';
import 'package:bloc/bloc.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({
    required this.getProductById,
  }) : super(ProductDetailInitial());

  final GetProductById getProductById;
  StreamSubscription<ProductModel?>? _productSubscription;

  Future<void> loadProduct(String productId) async {
    emit(ProductDetailLoading());
    final result = await getProductById(productId);

    result.fold(
      (failure) {
        emit(
          ProductDetailError(
            'Error al cargar el producto: ${failure.message}',
          ),
        );
      },
      (productStream) {
        _productSubscription?.cancel();
        _productSubscription = productStream.listen(
          (product) {
            if (product != null) {
              emit(ProductDetailLoaded(product));
            } else {
              emit(
                ProductDetailError(
                  'El producto con ID $productId no fue encontrado.',
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  Future<void> close() {
    _productSubscription?.cancel();
    return super.close();
  }
}
