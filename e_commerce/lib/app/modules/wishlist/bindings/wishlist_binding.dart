import 'package:get/get.dart';

import '../../../data/local/cart_local_datasource.dart';
import '../../../data/local/product_local_datasource.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/wishlist_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    // Cart Local Data Source
    if (!Get.isRegistered<CartLocalDataSource>()) {
      Get.lazyPut<CartLocalDataSource>(
        () => CartLocalDataSourceImpl(),
        fenix: true,
      );
    }

    // Cart Controller
    if (!Get.isRegistered<CartController>()) {
      Get.put<CartController>(
        CartController(Get.find<CartLocalDataSource>()),
        permanent: true,
      );
    }

    // Product Local Data Source
    if (!Get.isRegistered<ProductLocalDataSource>()) {
      Get.lazyPut<ProductLocalDataSource>(
        () => ProductLocalDataSourceImpl(),
        fenix: true,
      );
    }

    // Wishlist Controller
    if (!Get.isRegistered<WishlistController>()) {
      Get.put<WishlistController>(WishlistController(), permanent: true);
    }
  }
}
