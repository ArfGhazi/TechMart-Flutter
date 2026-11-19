import 'package:e_commerce/app/core/network/result.dart';
import 'package:e_commerce/app/data/models/product_model.dart';
import 'package:e_commerce/app/data/remote/product_remote_datasource.dart';

/// Kontrak repository untuk pengelolaan data produk.
abstract class ProductRepository {
  Future<Result<List<ProductModel>, String>> getProducts();
}

/// Implementasi repository menggunakan remote data source.
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  /// Constructor Injection.
  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<ProductModel>, String>> getProducts() async {
    try {
      final products = await _remoteDataSource.fetchProducts();

      return Success<List<ProductModel>, String>(data: products);
    } catch (error) {
      return Failure<List<ProductModel>, String>(error: error.toString());
    }
  }
}
