import 'package:hive_ce/hive_ce.dart';
import '../app/data/models/product_model.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([AdapterSpec<ProductModel>()])
// ignore: unused_element
void registerHiveAdapters() {}
