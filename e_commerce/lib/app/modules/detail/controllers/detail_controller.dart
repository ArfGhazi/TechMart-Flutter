import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce/app/modules/home/controllers/home_controller.dart';

class DetailController extends GetxController {
  late HomeController homeController;

  // Data produk
  final product = <String, dynamic>{}.obs;

  // State quantity
  final quantity = 1.obs;

  // State ukuran
  final selectedSize = '42'.obs;

  // State wishlist
  final isFavorite = false.obs;

  // Pilihan ukuran sepatu
  final availableSizes = <String>['39', '40', '41', '42', '43', '44', '45'];

  @override
  void onInit() {
    super.onInit();

    homeController = Get.find<HomeController>();

    final arguments = Get.arguments;

    if (arguments is Map) {
      product.assignAll(Map<String, dynamic>.from(arguments));

      final productId = product['id'].toString();

      isFavorite.value = homeController.isFavorite(productId);
    }
  }

  // Menambah quantity
  void incrementQuantity() {
    quantity.value++;
  }

  // Mengurangi quantity
  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // Mengubah ukuran
  void changeSize(String size) {
    selectedSize.value = size;
  }

  // Toggle wishlist
  void toggleFavorite() {
    final productId = product['id']?.toString() ?? '';

    if (productId.isEmpty) return;

    homeController.toggleFavorite(productId);

    isFavorite.value = homeController.isFavorite(productId);
  }

  // Menambahkan produk sesuai quantity ke keranjang
  void addToCart() {
    if (product.isEmpty) return;

    homeController.cartCount.value += quantity.value;

    Get.snackbar(
      'Keranjang Diperbarui',
      '${product['name']} (${quantity.value} item) berhasil ditambahkan!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
    );
  }
}
