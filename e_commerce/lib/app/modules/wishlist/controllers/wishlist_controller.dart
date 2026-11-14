import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';

class WishlistController extends GetxController {
  final CartController cartController = Get.find<CartController>();

  final RxList<ProductModel> items = <ProductModel>[].obs;

  int get count => items.length;

  bool isFavorite(String productId) {
    return items.any((product) => product.id == productId);
  }

  void toggleFavorite(ProductModel product) {
    final index = items.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      items.removeAt(index);

      Get.snackbar(
        'Wishlist',
        '${product.title} dihapus dari wishlist.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      items.add(product);

      Get.snackbar(
        'Wishlist',
        '${product.title} ditambahkan ke wishlist.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeItem(String productId) {
    items.removeWhere((product) => product.id == productId);
  }

  void addToCart(ProductModel product) {
    cartController.addItem(product: product, quantity: 1, size: '42');

    removeItem(product.id);
  }

  void clearWishlist() {
    items.clear();
  }
}
