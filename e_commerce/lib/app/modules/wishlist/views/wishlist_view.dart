import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce/app/core/theme/app_colors.dart';
import 'package:e_commerce/app/routes/app_pages.dart';

import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  String formatRupiah(num value) {
    final formatted = value.toInt().toString();
    final result = StringBuffer();

    for (int i = 0; i < formatted.length; i++) {
      if (i > 0 && (formatted.length - i) % 3 == 0) {
        result.write('.');
      }
      result.write(formatted[i]);
    }

    return 'Rp $result';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text('Wishlist Favorit'),
        actions: [
          Obx(() {
            if (controller.items.isEmpty) {
              return const SizedBox.shrink();
            }

            return IconButton(
              tooltip: 'Hapus semua wishlist',
              icon: const Icon(Icons.delete_sweep_rounded),
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Hapus Semua Wishlist?'),
                    content: const Text('Semua produk favorit akan dihapus.'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.clearWishlist();
                          Get.back();
                        },
                        child: const Text('Hapus'),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),

      body: Obx(() {
        if (controller.items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 72,
                    color: secondaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Wishlist Masih Kosong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan produk favoritmu dari halaman Home.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: secondaryColor),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed(Routes.HOME);
                    },
                    child: const Text('Jelajahi Produk'),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final product = controller.items[index];

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 85,
                      height: 85,
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported_outlined,
                            size: 32,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          product.category,
                          style: TextStyle(fontSize: 11, color: secondaryColor),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          formatRupiah(product.price),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Column(
                    children: [
                      IconButton(
                        tooltip: 'Hapus dari wishlist',
                        icon: const Icon(
                          Icons.favorite_rounded,
                          color: AppColors.error,
                        ),
                        onPressed: () {
                          controller.removeItem(product.id);
                        },
                      ),

                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          controller.addToCart(product);
                          Get.toNamed(Routes.CART);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
