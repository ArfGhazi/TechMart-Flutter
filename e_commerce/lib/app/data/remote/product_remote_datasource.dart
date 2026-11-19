import 'package:e_commerce/app/core/network/dio_client.dart';
import 'package:e_commerce/app/data/models/product_model.dart';

/// Kontrak abstraksi data remote khusus modul produk.
abstract class ProductRemoteDataSource {
  /// Mengambil data produk dari REST API.
  Future<List<ProductModel>> fetchProducts();
}

/// Implementasi ProductRemoteDataSource menggunakan DioClient.
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient _dioClient;

  /// Constructor Injection.
  ProductRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/products/category/mens-shoes',
    );

    final productsData = response['products'];

    if (productsData is List) {
      return productsData
          .whereType<Map>()
          .map((item) => ProductModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    return [];
  }
}
