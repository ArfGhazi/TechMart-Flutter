import 'package:get/get.dart';

import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> items = <CartItemModel>[].obs;

  // Jumlah seluruh barang
  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Subtotal belanja
  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // PPN 11%
  double get tax => subtotal * 0.11;

  // Gratis ongkir minimal Rp2.000.000
  double get shippingFee {
    if (items.isEmpty || subtotal >= 2000000) {
      return 0;
    }

    return 25000;
  }

  // Total pembayaran
  double get total => subtotal + tax + shippingFee;

  // Tambah produk ke keranjang
  void addItem({
    required ProductModel product,
    required int quantity,
    required String size,
  }) {
    final index = items.indexWhere(
      (item) => item.product.id == product.id && item.size == size,
    );

    if (index != -1) {
      final currentItem = items[index];

      items[index] = currentItem.copyWith(
        quantity: currentItem.quantity + quantity,
      );
    } else {
      items.add(
        CartItemModel(product: product, quantity: quantity, size: size),
      );
    }

    Get.snackbar(
      'Berhasil',
      '${product.title} ditambahkan ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Tambah kuantitas
  void increaseQuantity(String itemId) {
    final index = items.indexWhere((item) => item.id == itemId);

    if (index != -1) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    }
  }

  // Kurangi kuantitas
  void decreaseQuantity(String itemId) {
    final index = items.indexWhere((item) => item.id == itemId);

    if (index == -1) return;

    final currentItem = items[index];

    if (currentItem.quantity > 1) {
      items[index] = currentItem.copyWith(quantity: currentItem.quantity - 1);
    } else {
      items.removeAt(index);
    }
  }

  // Hapus produk
  void removeItem(String itemId) {
    items.removeWhere((item) => item.id == itemId);
  }

  // Kosongkan keranjang
  void clearCart() {
    items.clear();
  }
}
