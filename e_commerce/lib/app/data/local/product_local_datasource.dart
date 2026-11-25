import 'package:e_commerce/app/data/models/product_model.dart';
import 'package:hive_ce/hive.dart';

abstract class ProductLocalDataSource {
  // Product cache
  Future<void> cacheProducts(List<ProductModel> products);

  Future<List<ProductModel>> getCachedProducts();

  Future<void> clearProducts();

  // Wishlist CRUD
  Future<void> addToWishlist(ProductModel product);

  Future<List<ProductModel>> getWishlist();

  Future<void> removeFromWishlist(String productId);

  Future<bool> isInWishlist(String productId);

  Future<void> clearWishlist();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String productsBoxName = 'products_box';
  static const String wishlistBoxName = 'wishlist_box';

  Box<ProductModel> get _productsBox => Hive.box<ProductModel>(productsBoxName);

  Box<ProductModel> get _wishlistBox => Hive.box<ProductModel>(wishlistBoxName);

  // PRODUCT CACHE

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    await _productsBox.clear();

    if (products.isNotEmpty) {
      final entries = <String, ProductModel>{
        for (final product in products) product.id: product,
      };

      await _productsBox.putAll(entries);
    }
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    return _productsBox.values.toList();
  }

  @override
  Future<void> clearProducts() async {
    await _productsBox.clear();
  }

  // WISHLIST CRUD

  @override
  Future<void> addToWishlist(ProductModel product) async {
    await _wishlistBox.put(product.id, product.copyWith(isFavorite: true));
  }

  @override
  Future<List<ProductModel>> getWishlist() async {
    return _wishlistBox.values.toList();
  }

  @override
  Future<void> removeFromWishlist(String productId) async {
    await _wishlistBox.delete(productId);
  }

  @override
  Future<bool> isInWishlist(String productId) async {
    return _wishlistBox.containsKey(productId);
  }

  @override
  Future<void> clearWishlist() async {
    await _wishlistBox.clear();
  }
}
