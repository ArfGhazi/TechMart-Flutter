import 'package:hive_ce/hive.dart';

import '../models/order_model.dart';

abstract class OrderLocalDataSource {
  Future<void> saveOrder(OrderModel order);

  List<OrderModel> getOrders();

  OrderModel? getOrderById(String orderId);

  Future<void> deleteOrder(String orderId);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  static const String ordersBoxName = 'orders_box';

  Box<OrderModel> get _ordersBox => Hive.box<OrderModel>(ordersBoxName);

  @override
  Future<void> saveOrder(OrderModel order) async {
    await _ordersBox.put(order.id, order);
  }

  @override
  List<OrderModel> getOrders() {
    final orders = _ordersBox.values.toList();

    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return orders;
  }

  @override
  OrderModel? getOrderById(String orderId) {
    return _ordersBox.get(orderId);
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    await _ordersBox.delete(orderId);
  }
}
