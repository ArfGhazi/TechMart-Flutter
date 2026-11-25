import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final DateTime createdAt;
  final String customerName;
  final String phone;
  final String address;
  final List<CartItemModel> items;
  final String courier;
  final String paymentMethod;
  final int subtotal;
  final int tax;
  final int shippingFee;
  final int discount;
  final int total;
  final String status;

  OrderModel({
    required this.id,
    required this.createdAt,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.items,
    required this.courier,
    required this.paymentMethod,
    required this.subtotal,
    required this.tax,
    required this.shippingFee,
    required this.discount,
    required this.total,
    this.status = 'Diproses',
  });
}
