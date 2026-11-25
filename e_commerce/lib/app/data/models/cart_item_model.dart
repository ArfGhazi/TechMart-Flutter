import 'product_model.dart';

class CartItemModel {
  final String id;
  final ProductModel product;
  final String size;
  int quantity;

  CartItemModel({
    String? id,
    required this.product,
    this.quantity = 1,
    required this.size,
  }) : id = id ?? '${product.id}_$size';

  int get totalPrice => product.price * quantity;

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    int? quantity,
    String? size,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
    );
  }
}
