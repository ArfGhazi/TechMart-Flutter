import 'package:get/get.dart';

import '../../../core/network/dio_client.dart';
import '../../../data/local/cart_local_datasource.dart';
import '../../../data/local/product_local_datasource.dart';
import '../../../data/remote/product_remote_datasource.dart';
import '../../../data/repository/product_repository.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
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

    // Dio Client
    if (!Get.isRegistered<DioClient>()) {
      Get.lazyPut<DioClient>(() => DioClient(), fenix: true);
    }

    // Product Remote Data Source
    if (!Get.isRegistered<ProductRemoteDataSource>()) {
      Get.lazyPut<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(Get.find<DioClient>()),
        fenix: true,
      );
    }

    // Product Repository
    if (!Get.isRegistered<ProductRepository>()) {
      Get.lazyPut<ProductRepository>(
        () => ProductRepositoryImpl(
          Get.find<ProductRemoteDataSource>(),
          Get.find<ProductLocalDataSource>(),
        ),
        fenix: true,
      );
    }

    // Home Controller
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(() => HomeController());
    }
  }
}
