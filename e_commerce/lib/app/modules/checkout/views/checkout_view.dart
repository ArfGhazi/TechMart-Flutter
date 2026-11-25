import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce/app/core/theme/app_colors.dart';

import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  String formatRupiah(int value) {
    final number = value.toString();

    return 'Rp ${number.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
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
        title: const Text('Pengiriman & Checkout'),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress checkout.
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceCard : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStep('1', 'Keranjang', true, isDark),
                    _buildStepLine(true),
                    _buildStep('2', 'Pengiriman', true, isDark),
                    _buildStepLine(false),
                    _buildStep('3', 'Selesai', false, isDark),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _buildSectionTitle('Alamat Pengiriman', isDark),

              const SizedBox(height: 12),

              TextFormField(
                controller: controller.nameController,
                textCapitalization: TextCapitalization.words,
                validator: controller.validateName,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap Penerima',
                  hintText: 'Contoh: Ahmad Rizki',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                validator: controller.validatePhone,
                decoration: const InputDecoration(
                  labelText: 'Nomor WhatsApp / Telepon',
                  hintText: 'Contoh: 081234567890',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: controller.addressController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                validator: controller.validateAddress,
                decoration: const InputDecoration(
                  labelText: 'Alamat Lengkap Rumah',
                  hintText:
                      'Nama jalan, nomor rumah, RT/RW, kelurahan, kecamatan, kota/kabupaten',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Pilih Kurir', isDark),

              const SizedBox(height: 12),

              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceCard : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller.selectedCourier.value,
                      items: controller.courierFees.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(
                            '${entry.key} - ${formatRupiah(entry.value)}',
                          ),
                        );
                      }).toList(),
                      onChanged: controller.changeCourier,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Metode Pembayaran', isDark),

              const SizedBox(height: 12),

              Obx(
                () => RadioGroup<int>(
                  groupValue: controller.selectedPaymentMethod.value,
                  onChanged: controller.changePaymentMethod,
                  child: Column(
                    children: [
                      _buildPaymentOption(
                        index: 0,
                        title: 'COD (Bayar di Tempat)',
                        subtitle:
                            'Bayar tunai kepada kurir saat pesanan sampai',
                        icon: Icons.local_shipping_outlined,
                        selectedIndex: controller.selectedPaymentMethod.value,
                        onTap: () => controller.changePaymentMethod(0),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),
                      _buildPaymentOption(
                        index: 1,
                        title: 'Transfer Bank (BCA / Mandiri)',
                        subtitle: 'Metode pembayaran melalui transfer bank',
                        icon: Icons.account_balance_outlined,
                        selectedIndex: controller.selectedPaymentMethod.value,
                        onTap: () => controller.changePaymentMethod(1),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Kode Promo', isDark),

              const SizedBox(height: 12),

              // Input kupon dan tombol dengan lebar terbatas.
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.couponController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan kode promo',
                        prefixIcon: Icon(Icons.discount_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 90,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.appliedCoupon.isNotEmpty
                            ? controller.removeCoupon
                            : controller.applyCoupon,
                        child: Text(
                          controller.appliedCoupon.isNotEmpty
                              ? 'Hapus'
                              : 'Pakai',
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Obx(
                () => controller.appliedCoupon.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Kupon ${controller.appliedCoupon.value} aktif',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 24),

              // Ringkasan pembayaran dinamis.
              Obx(
                () => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceCard : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ringkasan Pembayaran',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _buildPriceRow(
                        'Total Harga Barang (${controller.cartController.totalItems} item)',
                        formatRupiah(controller.subtotal),
                        isDark,
                      ),

                      const SizedBox(height: 6),

                      _buildPriceRow(
                        'Pajak (11%)',
                        formatRupiah(controller.tax),
                        isDark,
                      ),

                      const SizedBox(height: 6),

                      _buildPriceRow(
                        'Ongkos Kirim (${controller.selectedCourier.value})',
                        formatRupiah(controller.shippingFee),
                        isDark,
                      ),

                      const SizedBox(height: 6),

                      _buildPriceRow(
                        'Diskon Promosi',
                        '- ${formatRupiah(controller.discount.value)}',
                        isDark,
                        isDiscount: controller.discount.value > 0,
                      ),

                      const Divider(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Tagihan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            formatRupiah(controller.total),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      // Tombol checkout di bagian bawah.
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 50 : 20),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Obx(
            () => ElevatedButton.icon(
              icon: controller.isLoading.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline_rounded),
              label: Text(
                controller.isLoading.value
                    ? 'Memproses Pesanan...'
                    : 'Bayar Sekarang & Buat Pesanan',
              ),
              onPressed: controller.isLoading.value
                  ? null
                  : controller.submitOrder,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
    );
  }

  Widget _buildStep(String number, String label, bool isActive, bool isDark) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive
                ? AppColors.primary
                : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      color: isActive ? AppColors.primary : Colors.grey.shade300,
      margin: const EdgeInsets.only(bottom: 16),
    );
  }

  Widget _buildPaymentOption({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required int selectedIndex,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final isSelected = selectedIndex == index;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceCard : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? Colors.white70 : Colors.black54),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Radio<int>(value: index, activeColor: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value,
    bool isDark, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isDiscount ? FontWeight.bold : FontWeight.w500,
            color: isDiscount
                ? AppColors.success
                : (isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary),
          ),
        ),
      ],
    );
  }
}
