import 'package:hive_ce/hive_ce.dart';

import '../app/data/models/cart_item_model.dart';
import '../app/data/models/order_model.dart';
import '../app/data/models/product_model.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<ProductModel>(),
  AdapterSpec<CartItemModel>(),
  AdapterSpec<OrderModel>(),
])
// ignore: unused_element
void registerHiveAdapters() {}
