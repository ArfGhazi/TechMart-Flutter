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

      // APP BAR
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
          // THEME BUTTON
          IconButton(
            onPressed: () {
              Get.changeThemeMode(
                Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
              );
            },
            icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),

          // CART BUTTON
          Obx(() {
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Get.snackbar(
                      'Shopping Cart',
                      'You have ${controller.cartCount.value} items in your cart.',
                    );
                  },
                  icon: const Icon(Icons.shopping_bag_outlined),
                ),
                if (controller.cartCount.value > 0)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${controller.cartCount.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),

      // BODY
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
                return SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    separatorBuilder: (_, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];

                      final selected =
                          controller.selectedCategory.value == category;

                      return ChoiceChip(
                        label: Text(category),
                        selected: selected,
                        selectedColor: const Color(0xFF4F46E5),
                        showCheckmark: false,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : null,
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

              // PRODUCT GRID
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

                final products = controller.filteredProducts;

                if (products.isEmpty) {
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
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.66,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];

                    // READ PRODUCT DATA
                    final productId = product['id']?.toString() ?? '';

                    final productName =
                        product['name']?.toString() ?? 'Unknown Product';

                    final productCategory =
                        product['category']?.toString() ?? 'Other';

                    final productPrice = (product['price'] as num?) ?? 0;

                    final productRating = (product['rating'] as num?) ?? 0;

                    final productImage = product['imageUrl']?.toString() ?? '';

                    // DEBUG
                    debugPrint('PRODUCT: $product');
                    debugPrint('PRODUCT NAME: $productName');
                    debugPrint('PRODUCT IMAGE: $productImage');

                    return Obx(() {
                      return ProductCard(
                        title: productName,
                        category: productCategory,
                        price: '\$${productPrice.toStringAsFixed(2)}',
                        rating: productRating.toDouble(),
                        imageUrl: productImage,
                        isFavorite: controller.isFavorite(productId),

                        // OPEN DETAIL
                        onTap: () {
                          controller.openDetail(product);
                        },

                        // ADD TO CART
                        onAddToCart: () {
                          controller.addToCart(product);
                        },

                        // WISHLIST
                        onToggleFavorite: () {
                          controller.toggleFavorite(productId);
                        },
                      );
                    });
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
