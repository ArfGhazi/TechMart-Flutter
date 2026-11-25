import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce/app/core/theme/app_colors.dart';
import 'package:e_commerce/app/data/local/auth_service.dart';
import 'package:e_commerce/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();

    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama wajib diisi';
    }

    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }

    return null;
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi kata sandi wajib diisi';
    }

    if (value != passwordController.text) {
      return 'Konfirmasi kata sandi tidak cocok';
    }

    return null;
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 1200));

      await _authService.login(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
      );

      Get.snackbar(
        'Registrasi Berhasil 🎉',
        'Akun kamu berhasil dibuat!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      );

      Get.offAllNamed(Routes.HOME);
    } finally {
      isLoading.value = false;
    }
  }
}
