import 'package:get/get.dart';

import '../../../core/network/dio_client.dart';
import '../../../data/remote/product_remote_datasource.dart';
import '../../../data/repository/product_repository.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Cart Controller
    if (!Get.isRegistered<CartController>()) {
      Get.put<CartController>(CartController(), permanent: true);
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
        () => ProductRepositoryImpl(Get.find<ProductRemoteDataSource>()),
        fenix: true,
      );
    }

    // Home Controller
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(() => HomeController());
    }
  }
}
