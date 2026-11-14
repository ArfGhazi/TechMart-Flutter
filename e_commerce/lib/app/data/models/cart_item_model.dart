import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;
  final String size;

  CartItemModel({required this.product, this.quantity = 1, required this.size});

  String get id => '${product.id}_$size';

  int get totalPrice => product.price * quantity;

  CartItemModel copyWith({ProductModel? product, int? quantity, String? size}) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
    );
  }
}
