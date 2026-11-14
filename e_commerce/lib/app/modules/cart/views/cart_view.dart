import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce/app/core/theme/app_colors.dart';
import 'package:e_commerce/app/routes/app_pages.dart';

import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  String formatRupiah(num value) {
    final number = value.toInt().toString();
    final result = StringBuffer();

    for (int i = 0; i < number.length; i++) {
      result.write(number[i]);

      final remaining = number.length - i - 1;

      if (remaining > 0 && remaining % 3 == 0) {
        result.write('.');
      }
    }

    return 'Rp ${result.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            'Keranjang Belanja (${controller.totalItems})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Obx(
            () => IconButton(
              tooltip: 'Kosongkan Keranjang',
              icon: const Icon(
                Icons.delete_sweep_outlined,
                color: AppColors.error,
              ),
              onPressed: controller.items.isEmpty
                  ? null
                  : () {
                      Get.defaultDialog(
                        title: 'Kosongkan Keranjang',
                        middleText: 'Yakin ingin menghapus seluruh belanjaan?',
                        textConfirm: 'Hapus',
                        textCancel: 'Batal',
                        confirmTextColor: Colors.white,
                        buttonColor: AppColors.error,
                        onConfirm: () {
                          controller.clearCart();
                          Get.back();
                        },
                      );
                    },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // CART BODY
      body: Obx(() {
        if (controller.items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 85,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Keranjang Masih Kosong',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Yuk, temukan produk favoritmu!',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Mulai Belanja'),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.items.length,
          separatorBuilder: (_, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = controller.items[index];
            final product = item.product;

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
                  // PRODUCT IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      child: product.imageUrl.isEmpty
                          ? const Icon(
                              Icons.image_not_supported_outlined,
                              size: 35,
                            )
                          : Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image_outlined,
                                  size: 35,
                                );
                              },
                            ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // PRODUCT INFORMATION
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
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Size ${item.size}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
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

                        const SizedBox(height: 8),

                        // QUANTITY CONTROLS
                        Row(
                          children: [
                            _quantityButton(
                              icon: Icons.remove_rounded,
                              onTap: () {
                                controller.decreaseQuantity(item.id);
                              },
                              isDark: isDark,
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),

                            _quantityButton(
                              icon: Icons.add_rounded,
                              onTap: () {
                                controller.increaseQuantity(item.id);
                              },
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // REMOVE BUTTON
                  IconButton(
                    tooltip: 'Hapus Produk',
                    onPressed: () {
                      controller.removeItem(item.id);
                    },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),

      // BOTTOM SUMMARY
      bottomNavigationBar: Obx(() {
        if (controller.items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 60 : 15),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // SUBTOTAL
                _summaryRow(
                  title: 'Subtotal',
                  value: formatRupiah(controller.subtotal),
                  isDark: isDark,
                ),

                const SizedBox(height: 8),

                // TAX
                _summaryRow(
                  title: 'PPN (11%)',
                  value: formatRupiah(controller.tax),
                  isDark: isDark,
                ),

                const SizedBox(height: 8),

                // SHIPPING
                _summaryRow(
                  title: 'Ongkos Kirim',
                  value: controller.shippingFee == 0
                      ? 'GRATIS'
                      : formatRupiah(controller.shippingFee),
                  isDark: isDark,
                  valueColor: controller.shippingFee == 0
                      ? AppColors.success
                      : null,
                ),

                const Divider(height: 22),

                // TOTAL
                _summaryRow(
                  title: 'Total Pembayaran',
                  value: formatRupiah(controller.total),
                  isDark: isDark,
                  bold: true,
                  valueColor: AppColors.primary,
                ),

                const SizedBox(height: 14),

                // CHECKOUT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.payment_rounded),
                    label: const Text(
                      'Lanjut ke Pembayaran',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.CHECKOUT);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _summaryRow({
    required String title,
    required String value,
    required bool isDark,
    bool bold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 18 : 14,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            color:
                valueColor ??
                (isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary),
          ),
        ),
      ],
    );
  }
}
