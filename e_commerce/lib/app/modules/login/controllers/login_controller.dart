import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce/app/core/theme/app_colors.dart';
import 'package:e_commerce/app/data/local/auth_service.dart';
import 'package:e_commerce/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();

    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Alamat email wajib diisi';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi wajib diisi';
    }

    if (value.length < 6) {
      return 'Kata sandi minimal 6 karakter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Kata sandi harus mengandung minimal 1 angka';
    }

    return null;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 1200));

      final email = emailController.text.trim();

      await _authService.login(name: email.split('@').first, email: email);

      Get.snackbar(
        'Login Berhasil 🎉',
        'Selamat datang kembali!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      );

      final destination = Get.arguments is String
          ? Get.arguments as String
          : Routes.HOME;

      Get.offAllNamed(destination);
    } finally {
      isLoading.value = false;
    }
  }
}
