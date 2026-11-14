import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../wishlist/controllers/wishlist_controller.dart';

class HomeController extends GetxController {
  final CartController cartController = Get.find<CartController>();

  final WishlistController wishlistController = Get.find<WishlistController>();

  final selectedCategory = 'Semua'.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final categories = ['Semua', 'Running', 'Casual', 'Basketball', 'Lifestyle'];

  final List<ProductModel> products = [
    ProductModel(
      id: 'shoe-01',
      title: 'Nike Air Max',
      category: 'Running',
      price: 120,
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
      description: 'Comfortable running shoes with modern design.',
    ),
    ProductModel(
      id: 'shoe-02',
      title: 'Adidas Ultraboost',
      category: 'Running',
      price: 150,
      rating: 4.9,
      imageUrl:
          'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=600',
      description: 'Lightweight shoes for everyday running.',
    ),
    ProductModel(
      id: 'shoe-03',
      title: 'Nike Air Force 1',
      category: 'Casual',
      price: 110,
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=600',
      description: 'Classic casual shoes for daily activities.',
    ),
    ProductModel(
      id: 'shoe-04',
      title: 'Jordan Basketball',
      category: 'Basketball',
      price: 180,
      rating: 4.9,
      imageUrl:
          'https://images.unsplash.com/photo-1519861531473-9200262188bf?w=600',
      description: 'Basketball shoes designed for performance.',
    ),
    ProductModel(
      id: 'shoe-05',
      title: 'New Balance 574',
      category: 'Lifestyle',
      price: 95,
      rating: 4.6,
      imageUrl:
          'https://images.unsplash.com/photo-1539185441755-769473a23570?w=600',
      description: 'Classic lifestyle sneakers with a comfortable fit.',
    ),
    ProductModel(
      id: 'shoe-06',
      title: 'Puma RS-X',
      category: 'Casual',
      price: 100,
      rating: 4.5,
      imageUrl:
          'https://images.unsplash.com/photo-1495555961986-6d4c1ecb7be3?w=600',
      description: 'Modern sneakers with a bold design.',
    ),
  ];

  int get cartCount => cartController.totalItems;

  int get wishlistCount => wishlistController.count;

  List<ProductModel> get filteredProducts {
    return products.where((product) {
      final categoryMatch =
          selectedCategory.value == 'Semua' ||
          product.category == selectedCategory.value;

      final searchMatch = product.title.toLowerCase().contains(
        searchQuery.value.toLowerCase(),
      );

      return categoryMatch && searchMatch;
    }).toList();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void changeCategory(String category) {
    selectCategory(category);
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      errorMessage.value = 'Failed to load products.';
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavorite(String productId) {
    return wishlistController.isFavorite(productId);
  }

  void toggleFavorite(String productId) {
    ProductModel? selectedProduct;

    for (final product in products) {
      if (product.id == productId) {
        selectedProduct = product;
        break;
      }
    }

    if (selectedProduct == null) return;

    wishlistController.toggleFavorite(selectedProduct);
  }

  void openDetail(ProductModel product) {
    Get.toNamed('/detail', arguments: product.toJson());
  }
}
