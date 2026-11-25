import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce/app/core/theme/app_colors.dart';
import 'package:e_commerce/app/routes/app_pages.dart';

import '../../../data/models/order_model.dart';
import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  String formatRupiah(int value) {
    final number = value.toString();

    return 'Rp ${number.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
  }

  String formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day $month $year, $hour:$minute';
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Diproses':
        return AppColors.warning;
      case 'Dikirim':
        return AppColors.primary;
      case 'Selesai':
        return AppColors.success;
      default:
        return AppColors.lightTextSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.offAllNamed(Routes.HOME),
        ),
        title: const Text('Riwayat Pesanan'),
        actions: [
          IconButton(
            tooltip: 'Belanja Lagi',
            icon: const Icon(Icons.storefront_outlined),
            onPressed: () => Get.offAllNamed(Routes.HOME),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filter status pesanan.
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(
              () => ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.filterTabs.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final status = controller.filterTabs[index];
                  final isSelected = controller.selectedStatus.value == status;

                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => controller.changeStatus(status),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                  ? AppColors.darkSurfaceCard
                                  : Colors.white),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Daftar pesanan dari Hive.
          Expanded(
            child: Obx(() {
              final filteredOrders = controller.filteredOrders;

              if (filteredOrders.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 72,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.selectedStatus.value == 'Semua'
                              ? 'Belum Ada Pesanan'
                              : 'Tidak Ada Pesanan ${controller.selectedStatus.value}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pesanan yang berhasil dibuat akan muncul di sini.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => Get.offAllNamed(Routes.HOME),
                          icon: const Icon(Icons.storefront_outlined),
                          label: const Text('Mulai Belanja'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: filteredOrders.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];

                  return _buildOrderCard(order: order, isDark: isDark);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard({required OrderModel order, required bool isDark}) {
    final statusColor = getStatusColor(order.status);
    final firstItem = order.items.first;
    final totalQuantity = order.items.fold<int>(
      0,
      (total, item) => total + item.quantity,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nomor pesanan dan status.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.receipt_outlined, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        order.id,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            formatDate(order.createdAt),
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ),

          const Divider(height: 20),

          // Produk pertama dalam pesanan.
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 64,
                  height: 64,
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  child: Image.network(
                    firstItem.product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported_outlined);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstItem.product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.items.length > 1 ? '+${order.items.length - 1} produk lainnya • ' : ''}$totalQuantity Barang',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Total pembayaran dan tombol pelacakan.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Belanja',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    formatRupiah(order.total),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.snackbar(
                    'Lacak Pesanan',
                    'Pesanan ${order.id} berstatus ${order.status}.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.primary,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                  );
                },
                child: const Text('Lacak Pesanan'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
