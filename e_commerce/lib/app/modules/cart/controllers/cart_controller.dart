import 'package:get/get.dart';

import '../../../data/local/cart_local_datasource.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';

class CartController extends GetxController {
  CartController(this._cartDataSource);

  final CartLocalDataSource _cartDataSource;

  final RxList<CartItemModel> items = <CartItemModel>[].obs;

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get tax => subtotal * 0.11;

  double get shippingFee {
    if (items.isEmpty || subtotal >= 2000000) {
      return 0;
    }

    return 25000;
  }

  double get total => subtotal + tax + shippingFee;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    items.assignAll(_cartDataSource.getCartItems());
  }

  Future<void> addItem({
    required ProductModel product,
    required int quantity,
    required String size,
  }) async {
    final index = items.indexWhere(
      (item) => item.product.id == product.id && item.size == size,
    );

    if (index != -1) {
      final updatedItem = items[index].copyWith(
        quantity: items[index].quantity + quantity,
      );

      items[index] = updatedItem;
      await _cartDataSource.saveCartItem(updatedItem);
    } else {
      final newItem = CartItemModel(
        product: product,
        quantity: quantity,
        size: size,
      );

      items.add(newItem);
      await _cartDataSource.saveCartItem(newItem);
    }

    Get.snackbar(
      'Berhasil',
      '${product.title} ditambahkan ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> increaseQuantity(String itemId) async {
    final index = items.indexWhere((item) => item.id == itemId);

    if (index == -1) return;

    final updatedItem = items[index].copyWith(
      quantity: items[index].quantity + 1,
    );

    items[index] = updatedItem;
    await _cartDataSource.saveCartItem(updatedItem);
  }

  Future<void> decreaseQuantity(String itemId) async {
    final index = items.indexWhere((item) => item.id == itemId);

    if (index == -1) return;

    final currentItem = items[index];

    if (currentItem.quantity > 1) {
      final updatedItem = currentItem.copyWith(
        quantity: currentItem.quantity - 1,
      );

      items[index] = updatedItem;
      await _cartDataSource.saveCartItem(updatedItem);
    } else {
      items.removeAt(index);
      await _cartDataSource.removeCartItem(itemId);
    }
  }

  Future<void> removeItem(String itemId) async {
    items.removeWhere((item) => item.id == itemId);
    await _cartDataSource.removeCartItem(itemId);
  }

  Future<void> clearCart() async {
    items.clear();
    await _cartDataSource.clearCart();
  }
}
