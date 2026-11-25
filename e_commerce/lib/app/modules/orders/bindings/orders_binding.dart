import 'package:get/get.dart';

import '../../../data/local/order_local_datasource.dart';
import '../controllers/orders_controller.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderLocalDataSource>(() => OrderLocalDataSourceImpl());

    Get.lazyPut<OrdersController>(
      () => OrdersController(
        orderLocalDataSource: Get.find<OrderLocalDataSource>(),
      ),
    );
  }
}
