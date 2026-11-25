// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final typeId = 0;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      price: (fields[3] as num).toInt(),
      rating: (fields[4] as num).toDouble(),
      imageUrl: fields[6] as String,
      description: fields[7] == null ? '' : fields[7] as String,
      reviewCount: fields[5] == null ? 0 : (fields[5] as num).toInt(),
      isFavorite: fields[8] == null ? false : fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.reviewCount)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CartItemModelAdapter extends TypeAdapter<CartItemModel> {
  @override
  final typeId = 1;

  @override
  CartItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemModel(
      id: fields[0] as String?,
      product: fields[1] as ProductModel,
      quantity: fields[3] == null ? 1 : (fields[3] as num).toInt(),
      size: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CartItemModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.product)
      ..writeByte(2)
      ..write(obj.size)
      ..writeByte(3)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final typeId = 2;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      id: fields[0] as String,
      createdAt: fields[1] as DateTime,
      customerName: fields[2] as String,
      phone: fields[3] as String,
      address: fields[4] as String,
      items: (fields[5] as List).cast<CartItemModel>(),
      courier: fields[6] as String,
      paymentMethod: fields[7] as String,
      subtotal: (fields[8] as num).toInt(),
      tax: (fields[9] as num).toInt(),
      shippingFee: (fields[10] as num).toInt(),
      discount: (fields[11] as num).toInt(),
      total: (fields[12] as num).toInt(),
      status: fields[13] == null ? 'Diproses' : fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.customerName)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.items)
      ..writeByte(6)
      ..write(obj.courier)
      ..writeByte(7)
      ..write(obj.paymentMethod)
      ..writeByte(8)
      ..write(obj.subtotal)
      ..writeByte(9)
      ..write(obj.tax)
      ..writeByte(10)
      ..write(obj.shippingFee)
      ..writeByte(11)
      ..write(obj.discount)
      ..writeByte(12)
      ..write(obj.total)
      ..writeByte(13)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
