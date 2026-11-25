import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/local/order_local_datasource.dart';
import '../../../data/models/order_model.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../routes/app_pages.dart';

class CheckoutController extends GetxController {
  final CartController cartController = Get.find<CartController>();
  final OrderLocalDataSource orderDataSource = Get.find<OrderLocalDataSource>();

  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  late final TextEditingController couponController;

  final selectedPaymentMethod = 0.obs;
  final selectedCourier = 'JNE'.obs;
  final discount = 0.obs;
  final appliedCoupon = ''.obs;
  final isLoading = false.obs;

  final Map<String, int> courierFees = {
    'JNE': 25000,
    'SiCepat': 22000,
    'GoSend': 35000,
  };

  @override
  void onInit() {
    super.onInit();

    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    couponController = TextEditingController();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    couponController.dispose();

    super.onClose();
  }

  int get subtotal => cartController.subtotal.round();

  int get tax => (subtotal * 0.11).round();

  int get shippingFee => courierFees[selectedCourier.value] ?? 25000;

  int get total => (subtotal + tax + shippingFee - discount.value)
      .clamp(0, 999999999999)
      .toInt();

  String get paymentMethod => selectedPaymentMethod.value == 0
      ? 'COD (Bayar di Tempat)'
      : 'Transfer Bank (BCA / Mandiri)';

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama penerima wajib diisi';
    }

    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }

    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor WhatsApp wajib diisi';
    }

    final phone = value.replaceAll(RegExp(r'[\s-]'), '');

    final phoneRegex = RegExp(r'^(?:\+62|62|0)8[1-9][0-9]{6,11}$');

    if (!phoneRegex.hasMatch(phone)) {
      return 'Format nomor WhatsApp tidak valid';
    }

    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Alamat lengkap wajib diisi';
    }

    if (value.trim().length < 15) {
      return 'Masukkan alamat yang lebih lengkap';
    }

    return null;
  }

  void changeCourier(String? courier) {
    if (courier == null || !courierFees.containsKey(courier)) {
      return;
    }

    selectedCourier.value = courier;
  }

  void changePaymentMethod(int? method) {
    if (method != null) {
      selectedPaymentMethod.value = method;
    }
  }

  void applyCoupon() {
    final code = couponController.text.trim().toUpperCase();

    if (code == 'SMKBISA' || code == 'KICKS10') {
      discount.value = 25000;
      appliedCoupon.value = code;

      Get.snackbar(
        'Kupon Berhasil!',
        'Diskon Rp25.000 berhasil diterapkan.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } else {
      discount.value = 0;
      appliedCoupon.value = '';

      Get.snackbar(
        'Kupon Tidak Valid',
        'Gunakan kode SMKBISA atau KICKS10.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void removeCoupon() {
    discount.value = 0;
    appliedCoupon.value = '';
    couponController.clear();
  }

  Future<void> submitOrder() async {
    if (isLoading.value) return;

    if (cartController.items.isEmpty) {
      Get.snackbar(
        'Keranjang Kosong',
        'Tambahkan produk sebelum melakukan checkout.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final now = DateTime.now();

      final order = OrderModel(
        id: 'ORD-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.microsecondsSinceEpoch}',
        createdAt: now,
        customerName: nameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        items: cartController.items.map((item) => item.copyWith()).toList(),
        courier: selectedCourier.value,
        paymentMethod: paymentMethod,
        subtotal: subtotal,
        tax: tax,
        shippingFee: shippingFee,
        discount: discount.value,
        total: total,
      );

      await orderDataSource.saveOrder(order);
      await cartController.clearCart();

      Get.defaultDialog(
        title: 'Pesanan Berhasil! 🎉',
        titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        middleText: 'Terima kasih! Pesanan ${order.id} berhasil disimpan.',
        textConfirm: 'Lihat Riwayat Pesanan',
        confirmTextColor: Colors.white,
        buttonColor: const Color(0xFF4F46E5),
        barrierDismissible: false,
        onConfirm: () {
          Get.back();
          Get.offAllNamed(Routes.ORDERS);
        },
      );
    } catch (error) {
      Get.snackbar(
        'Checkout Gagal',
        'Pesanan belum berhasil disimpan. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
