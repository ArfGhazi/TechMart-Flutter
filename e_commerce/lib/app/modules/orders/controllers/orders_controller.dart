import 'package:get/get.dart';

import '../../../data/local/order_local_datasource.dart';
import '../../../data/models/order_model.dart';

class OrdersController extends GetxController {
  OrdersController({required this.orderLocalDataSource});

  final OrderLocalDataSource orderLocalDataSource;

  final orders = <OrderModel>[].obs;
  final selectedStatus = 'Semua'.obs;

  final filterTabs = ['Semua', 'Diproses', 'Dikirim', 'Selesai'];

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  void loadOrders() {
    orders.assignAll(orderLocalDataSource.getOrders());
  }

  List<OrderModel> get filteredOrders {
    if (selectedStatus.value == 'Semua') {
      return orders.toList();
    }

    return orders
        .where((order) => order.status == selectedStatus.value)
        .toList();
  }

  void changeStatus(String status) {
    selectedStatus.value = status;
  }

  int get totalOrders => orders.length;
}
