import 'package:dio/dio.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  final products = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final selectedCategory = 'All'.obs;
  final searchQuery = ''.obs;

  final categories = const ['All', 'Smartphones', 'Laptops'];

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final responses = await Future.wait([
        _dio.get('/products/category/smartphones'),
        _dio.get('/products/category/laptops'),
      ]);

      final loadedProducts = <Map<String, dynamic>>[];

      for (final response in responses) {
        final data = response.data as Map<String, dynamic>;

        loadedProducts.addAll(
          List<Map<String, dynamic>>.from(data['products']),
        );
      }

      products.assignAll(loadedProducts);
    } on DioException {
      errorMessage.value =
          'Failed to load products. Check your internet connection.';
    } catch (e) {
      errorMessage.value = 'Something went wrong: $e';
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> get filteredProducts {
    return products.where((product) {
      final category = selectedCategory.value;

      final matchesCategory =
          category == 'All' ||
          product['category'].toString().toLowerCase() ==
              category.toLowerCase();

      final title = product['title'].toString().toLowerCase();

      final matchesSearch = title.contains(searchQuery.value.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }
}
