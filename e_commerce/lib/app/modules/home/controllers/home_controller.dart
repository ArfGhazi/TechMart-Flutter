import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/result.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repository/product_repository.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../wishlist/controllers/wishlist_controller.dart';

class HomeController extends GetxController {
  final CartController cartController = Get.find<CartController>();

  final WishlistController wishlistController = Get.find<WishlistController>();

  final ProductRepository _productRepository = Get.find<ProductRepository>();

  final selectedCategory = 'Semua'.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final categories = ['Semua', 'Running', 'Casual', 'Basketball', 'Lifestyle'];

  final RxList<ProductModel> products = <ProductModel>[].obs;

  int get cartCount => cartController.totalItems;

  int get wishlistCount => wishlistController.count;

  List<ProductModel> get filteredProducts {
    return products.where((product) {
      final categoryMatch =
          selectedCategory.value == 'Semua' ||
          product.category.toLowerCase() ==
              selectedCategory.value.toLowerCase();

      final searchMatch = product.title.toLowerCase().contains(
        searchQuery.value.toLowerCase(),
      );

      return categoryMatch && searchMatch;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void changeCategory(String category) {
    selectCategory(category);
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  Future<void> fetchProducts() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _productRepository.getProducts();

      switch (result) {
        case Success<List<ProductModel>, String>(:final data):
          products.assignAll(data);

          if (_productRepository.isOffline) {
            Get.snackbar(
              'Mode Offline',
              'Koneksi server terputus. Menampilkan ${data.length} produk dari penyimpanan lokal.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFFEF4444),
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
              icon: const Icon(Icons.cloud_off_rounded, color: Colors.white),
            );
          } else {
            Get.snackbar(
              'Katalog Berhasil Diperbarui',
              'Berhasil mengunduh ${data.length} sepatu terbaru dari server!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFF10B981),
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
              icon: const Icon(Icons.cloud_done_rounded, color: Colors.white),
            );
          }

        case Failure<List<ProductModel>, String>(:final error):
          errorMessage.value = error;

          Get.snackbar(
            'Gagal Memuat Produk',
            'Tidak dapat mengambil produk dari server maupun penyimpanan lokal.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFEF4444),
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
      }
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavorite(String productId) {
    return wishlistController.isFavorite(productId);
  }

  void toggleFavorite(String productId) {
    ProductModel? selectedProduct;

    for (final product in products) {
      if (product.id == productId) {
        selectedProduct = product;
        break;
      }
    }

    if (selectedProduct == null) return;

    wishlistController.toggleFavorite(selectedProduct);
  }

  void openDetail(ProductModel product) {
    Get.toNamed('/detail', arguments: product.toJson());
  }
}
