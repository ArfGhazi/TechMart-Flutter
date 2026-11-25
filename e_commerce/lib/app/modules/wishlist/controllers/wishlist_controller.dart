import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/local/product_local_datasource.dart';
import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';

class WishlistController extends GetxController {
  final CartController cartController = Get.find<CartController>();

  final ProductLocalDataSource _localDataSource =
      Get.find<ProductLocalDataSource>();

  final RxList<ProductModel> items = <ProductModel>[].obs;

  int get count => items.length;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    final savedItems = await _localDataSource.getWishlist();
    items.assignAll(savedItems);
  }

  bool isFavorite(String productId) {
    return items.any((product) => product.id == productId);
  }

  Future<void> toggleFavorite(ProductModel product) async {
    if (isFavorite(product.id)) {
      await _localDataSource.removeFromWishlist(product.id);
      items.removeWhere((item) => item.id == product.id);

      Get.snackbar(
        'Wishlist',
        '${product.title} dihapus dari wishlist.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      final favoriteProduct = product.copyWith(isFavorite: true);

      await _localDataSource.addToWishlist(favoriteProduct);
      items.add(favoriteProduct);

      Get.snackbar(
        'Wishlist',
        '${product.title} ditambahkan ke wishlist.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> removeItem(String productId) async {
    await _localDataSource.removeFromWishlist(productId);
    items.removeWhere((product) => product.id == productId);
  }

  Future<void> addToCart(ProductModel product) async {
    cartController.addItem(product: product, quantity: 1, size: '42');

    await removeItem(product.id);
  }

  Future<void> clearWishlist() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text(
          'Kosongkan Wishlist?',
          style: TextStyle(
            color: Color(0xFFEF4444),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus seluruh sepatu favorit dari memori penyimpanan lokal?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Hapus Semua',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _localDataSource.clearWishlist();
      items.clear();

      Get.snackbar(
        'Wishlist',
        'Semua wishlist berhasil dihapus.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
