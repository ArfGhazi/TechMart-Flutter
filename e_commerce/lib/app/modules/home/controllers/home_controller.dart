import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // REACTIVE STATE
  final cartCount = 0.obs;
  final selectedCategory = 'Semua'.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // WISHLIST
  final favoriteIds = <String>{}.obs;

  // CATEGORY
  final categories = ['Semua', 'Running', 'Casual', 'Basketball', 'Lifestyle'];

  // PRODUCT DATA
  final products = <Map<String, dynamic>>[
    {
      'id': 'shoe-01',
      'name': 'Nike Air Max',
      'category': 'Running',
      'price': 120.00,
      'rating': 4.8,
      'reviewCount': 120,
      'imageUrl':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
      'description': 'Comfortable running shoes with modern design.',
    },
    {
      'id': 'shoe-02',
      'name': 'Adidas Ultraboost',
      'category': 'Running',
      'price': 150.00,
      'rating': 4.9,
      'reviewCount': 200,
      'imageUrl':
          'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=600',
      'description': 'Lightweight shoes for everyday running.',
    },
    {
      'id': 'shoe-03',
      'name': 'Nike Air Force 1',
      'category': 'Casual',
      'price': 110.00,
      'rating': 4.7,
      'reviewCount': 150,
      'imageUrl':
          'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=600',
      'description': 'Classic casual shoes for daily activities.',
    },
    {
      'id': 'shoe-04',
      'name': 'Jordan Basketball',
      'category': 'Basketball',
      'price': 180.00,
      'rating': 4.9,
      'reviewCount': 300,
      'imageUrl':
          'https://images.unsplash.com/photo-1519861531473-9200262188bf?w=600',
      'description': 'Basketball shoes designed for performance.',
    },
    {
      'id': 'shoe-05',
      'name': 'New Balance 574',
      'category': 'Lifestyle',
      'price': 95.00,
      'rating': 4.6,
      'reviewCount': 90,
      'imageUrl':
          'https://images.unsplash.com/photo-1539185441755-769473a23570?w=600',
      'description': 'Classic lifestyle sneakers with a comfortable fit.',
    },
    {
      'id': 'shoe-06',
      'name': 'Puma RS-X',
      'category': 'Casual',
      'price': 100.00,
      'rating': 4.5,
      'reviewCount': 80,
      'imageUrl':
          'https://images.unsplash.com/photo-1495555961986-6d4c1ecb7be3?w=600',
      'description': 'Modern sneakers with a bold design.',
    },
  ];

  // FILTER PRODUCTS
  List<Map<String, dynamic>> get filteredProducts {
    return products.where((product) {
      final categoryMatch =
          selectedCategory.value == 'Semua' ||
          product['category'] == selectedCategory.value;

      final searchMatch = product['name'].toString().toLowerCase().contains(
        searchQuery.value.toLowerCase(),
      );

      return categoryMatch && searchMatch;
    }).toList();
  }

  // CHANGE CATEGORY
  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
  }

  // SEARCH
  void updateSearch(String value) {
    searchQuery.value = value;
  }

  // REFRESH PRODUCTS
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

  // ADD TO CART
  void addToCart(Map<String, dynamic> product) {
    cartCount.value++;

    Get.snackbar(
      'Added to Cart',
      '${product['name']} added to cart.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // CHECK FAVORITE
  bool isFavorite(String productId) {
    return favoriteIds.contains(productId);
  }

  // TOGGLE FAVORITE
  void toggleFavorite(String productId) {
    if (favoriteIds.contains(productId)) {
      favoriteIds.remove(productId);
    } else {
      favoriteIds.add(productId);
    }
  }

  // OPEN DETAIL
  void openDetail(Map<String, dynamic> product) {
    Get.toNamed('/detail', arguments: product);
  }
}
