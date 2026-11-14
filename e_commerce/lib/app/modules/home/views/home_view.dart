import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'components/product_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.devices, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text(
              'TechMart',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.changeThemeMode(
                Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
              );
            },
            icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
          IconButton(
            onPressed: () {
              Get.snackbar('Shopping Cart', 'Your cart is currently empty.');
            },
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: controller.fetchProducts,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SEARCH BAR
              TextField(
                onChanged: controller.updateSearch,
                decoration: InputDecoration(
                  hintText: 'Search gadgets...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // PROMO BANNER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF3730A3), Color(0xFF6366F1)],
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TECH THAT MOVES YOU',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Upgrade Your\nEveryday Life',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Discover the latest gadgets.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.devices_other,
                      color: Colors.white70,
                      size: 70,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // CATEGORY TITLE
              const Text(
                'Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              // CATEGORY FILTER
              Obx(() {
                final selected = controller.selectedCategory.value;

                return SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];

                      return ChoiceChip(
                        label: Text(category),
                        selected: selected == category,
                        selectedColor: const Color(0xFF4F46E5),
                        showCheckmark: false,
                        labelStyle: TextStyle(
                          color: selected == category ? Colors.white : null,
                        ),
                        onSelected: (_) {
                          controller.selectCategory(category);
                        },
                      );
                    },
                  ),
                );
              }),

              const SizedBox(height: 24),

              // PRODUCT TITLE
              const Text(
                'Explore Products',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              // PRODUCT LIST
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        const Icon(Icons.wifi_off, size: 45),
                        const SizedBox(height: 12),
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: controller.fetchProducts,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                final items = controller.filteredProducts;

                if (items.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text('No products found.'),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.66,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final product = items[index];

                    return ProductCard(
                      title: product['title'].toString(),
                      category: product['category'].toString(),
                      price:
                          '\$${(product['price'] as num).toStringAsFixed(2)}',
                      rating: (product['rating'] as num).toDouble(),
                      imageUrl: product['thumbnail'].toString(),
                      onTap: () {
                        Get.snackbar(
                          product['title'].toString(),
                          product['description'].toString(),
                        );
                      },
                      onAddToCart: () {
                        Get.snackbar(
                          'Added to Cart',
                          '${product['title']} added to cart.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
