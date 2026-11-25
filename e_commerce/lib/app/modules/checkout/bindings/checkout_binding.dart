import 'package:get/get.dart';

import '../../../data/local/order_local_datasource.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<OrderLocalDataSource>()) {
      Get.lazyPut<OrderLocalDataSource>(() => OrderLocalDataSourceImpl());
    }

    Get.lazyPut<CheckoutController>(() => CheckoutController());
  }
}
