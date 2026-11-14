import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          Obx(
            () => IconButton(
              onPressed: controller.toggleFavorite,
              icon: Icon(
                controller.isFavorite.value
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: controller.isFavorite.value ? Colors.red : null,
              ),
            ),
          ),
        ],
      ),

      body: Obx(() {
        if (controller.product.isEmpty) {
          return const Center(child: Text('Product not found.'));
        }

        final product = controller.product;

        final name = product['name']?.toString() ?? 'Product';
        final category = product['category']?.toString() ?? 'Other';
        final description =
            product['description']?.toString() ?? 'No description available.';
        final imageUrl = product['imageUrl']?.toString() ?? '';
        final price = (product['price'] as num?) ?? 0;
        final rating = (product['rating'] as num?) ?? 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PRODUCT IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 1.1,
                  child: imageUrl.isEmpty
                      ? Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            size: 60,
                          ),
                        )
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.broken_image_outlined,
                                size: 60,
                              ),
                            );
                          },
                        ),
                ),
              ),

              const SizedBox(height: 22),

              // CATEGORY
              Text(
                category.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF4F46E5),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 8),

              // PRODUCT NAME
              Text(
                name,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // RATING
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber),
                  const SizedBox(width: 5),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // PRICE
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F46E5),
                ),
              ),

              const SizedBox(height: 20),

              // DESCRIPTION
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                description,
                style: const TextStyle(fontSize: 14, height: 1.6),
              ),

              const SizedBox(height: 25),

              // SIZE SELECTOR
              const Text(
                'Select Size',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                children: controller.availableSizes.map((size) {
                  final selected = controller.selectedSize.value == size;

                  return ChoiceChip(
                    label: Text(size),
                    selected: selected,
                    selectedColor: const Color(0xFF4F46E5),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : null,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) {
                      controller.changeSize(size);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 25),

              // QUANTITY
              const Text(
                'Quantity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  IconButton(
                    onPressed: controller.decrementQuantity,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    '${controller.quantity.value}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: controller.incrementQuantity,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ADD TO CART BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: controller.addToCart,
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}
