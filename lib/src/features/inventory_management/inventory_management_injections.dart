import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/categories_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/categories_datasource_impl.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/inventory_movement_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/inventory_movement_datasource_impl.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/item_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/item_datasource_impl.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/product_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/product_datasource_impl.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/recipe_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/recipe_datasource_impl.dart';
import 'package:bandasybandas/src/features/inventory_management/data/repositories/categories_repository_impl.dart';
import 'package:bandasybandas/src/features/inventory_management/data/repositories/inventory_movement_repository_impl.dart';
import 'package:bandasybandas/src/features/inventory_management/data/repositories/item_repository_impl.dart';
import 'package:bandasybandas/src/features/inventory_management/data/repositories/product_repository_impl.dart';
import 'package:bandasybandas/src/features/inventory_management/data/repositories/recipe_repository_impl.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/categories_repository.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/inventory_movement_repository.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/item_repository.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/product_repository.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/recipe_repository.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/categories_usecases.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/inventory_movement_usecases.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/items_usecases.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/products_usecases.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/recipes_usecases.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/categories/cubit/categories_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/product_detail/cubit/product_detail_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/cubit/products_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/cubit/recipe_page_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Registra todas las dependencias para el feature de 'Inventory Management'.
void initInventoryManagementInjections(FirebaseFirestore firestore) {
  // --- Cubit (Presentation Layer) ---
  // Se registra como 'factory' porque queremos una nueva instancia cada vez
  // que una página la necesite, para evitar problemas de estado entre pantallas.
  sl
    ..registerFactory(
      () => ItemsCubit(
        getItems: sl(),
        addItemUseCase: sl(),
        updateItemUseCase: sl(),
        addInventoryMovement: sl(),
        addCustomerProduct: sl(),
        updateCustomerProduct: sl(),
        getCustomerProducts: sl(),
      ),
    )
    ..registerFactory(
      () => RecipesPageCubit(
        getRecipes: sl(),
        addRecipe: sl(),
        updateRecipe: sl(),
        deleteRecipe: sl(),
        uploadPdfUseCase: sl(),
      ),
    )
    ..registerFactory(
      () => ProductsPageCubit(
        getProducts: sl(),
        addProduct: sl(),
        updateProduct: sl(),
        deleteProduct: sl(),
        addCustomerProduct: sl(),
        addInventoryMovement: sl(),
      ),
    )
    ..registerFactory(
      () => ProductDetailCubit(getProductById: sl()),
    )
    ..registerFactory(
      () => CategoriesCubit(
        getCategories: sl(),
        addCategoryUseCase: sl(),
        updateCategoryUseCase: sl(),
        deleteCategoryUseCase: sl(),
      ),
    )

    // ----------------------- Use Cases (Domain Layer) -----------------------
    // Items
    ..registerLazySingleton(() => GetItems(sl()))
    ..registerLazySingleton(() => AddItem(sl()))
    ..registerLazySingleton(() => UpdateItem(sl()))
    ..registerLazySingleton(() => AddInventoryMovement(sl()))

    // Recetas
    ..registerLazySingleton(() => GetRecipes(sl()))
    ..registerLazySingleton(() => AddRecipe(sl()))
    ..registerLazySingleton(() => UpdateRecipe(sl()))
    ..registerLazySingleton(() => DeleteRecipe(sl()))
    ..registerLazySingleton(() => UploadPdfUseCase(sl()))

    // Productos
    ..registerLazySingleton(() => GetProductById(sl()))
    ..registerLazySingleton(() => GetProducts(sl()))
    ..registerLazySingleton(() => AddProduct(sl()))
    ..registerLazySingleton(() => UpdateProduct(sl()))
    ..registerLazySingleton(() => DeleteProduct(sl()))

    // Categorías
    ..registerLazySingleton(() => GetCategories(sl()))
    ..registerLazySingleton(() => AddCategory(sl()))
    ..registerLazySingleton(() => UpdateCategory(sl()))
    ..registerLazySingleton(() => DeleteCategory(sl()))

    // ----------- Repository (Data Layer) --- interfaz del dominio ------------
    // ItemRepository
    ..registerLazySingleton<ItemRepository>(
      () => ItemRepositoryImpl(sl<ItemDatasource>()),
    )
    // RecipeRepository
    ..registerLazySingleton<RecipeRepository>(
      () => RecipeRepositoryImpl(sl<RecipeDatasource>()),
    )
    // ProductRepository
    ..registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(sl<ProductDatasource>()),
    )
    // InventoryMovementRepository
    ..registerLazySingleton<InventoryMovementRepository>(
      () => InventoryMovementRepositoryImpl(sl<InventoryMovementDatasource>()),
    )
    // CategoriesRepository
    ..registerLazySingleton<CategoriesRepository>(
      () => CategoriesRepositoryImpl(sl<CategoriesDataSource>()),
    )

    // ------------------------ Data Source (Data Layer) -----------------------
    ..registerLazySingleton<ItemDatasource>(
      () => ItemDatasourceImpl(firestore),
    )
    ..registerLazySingleton<RecipeDatasource>(
      () => RecipeDatasourceImpl(firestore),
    )
    ..registerLazySingleton<ProductDatasource>(
      () => ProductDatasourceImpl(firestore),
    )
    ..registerLazySingleton<InventoryMovementDatasource>(
      () => InventoryMovementDatasourceImpl(firestore),
    )
    ..registerLazySingleton<CategoriesDataSource>(
      () => CategoriesDataSourceImpl(firestore),
    );
}
