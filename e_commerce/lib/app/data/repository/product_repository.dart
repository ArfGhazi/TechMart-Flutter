import 'package:e_commerce/app/core/network/result.dart';
import 'package:e_commerce/app/data/local/product_local_datasource.dart';
import 'package:e_commerce/app/data/models/product_model.dart';
import 'package:e_commerce/app/data/remote/product_remote_datasource.dart';

abstract class ProductRepository {
  Future<Result<List<ProductModel>, String>> getProducts();

  bool get isOffline;
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;

  ProductRepositoryImpl(this._remoteDataSource, this._localDataSource);

  bool _isOffline = false;

  @override
  bool get isOffline => _isOffline;

  @override
  Future<Result<List<ProductModel>, String>> getProducts() async {
    try {
      final products = await _remoteDataSource.fetchProducts();

      _isOffline = false;

      try {
        await _localDataSource.cacheProducts(products);
      } catch (_) {
        // Tetap gunakan data API jika penyimpanan cache gagal.
      }

      return Success<List<ProductModel>, String>(data: products);
    } catch (error) {
      _isOffline = true;

      try {
        final cachedProducts = await _localDataSource.getCachedProducts();

        if (cachedProducts.isNotEmpty) {
          return Success<List<ProductModel>, String>(data: cachedProducts);
        }
      } catch (cacheError) {
        return Failure<List<ProductModel>, String>(
          error: cacheError.toString(),
        );
      }

      return Failure<List<ProductModel>, String>(error: error.toString());
    }
  }
}
