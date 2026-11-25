import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service penyimpanan data lokal terpusat.
class StorageService extends GetxService {
  static const String _themeKey = 'is_dark_mode';

  late final SharedPreferences _prefs;

  final RxBool _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  /// Inisialisasi SharedPreferences dan Hive CE.
  Future<StorageService> init({bool initHive = true}) async {
    _prefs = await SharedPreferences.getInstance();

    _isDarkMode.value = _prefs.getBool(_themeKey) ?? false;

    if (initHive) {
      await Hive.initFlutter();
    }

    return this;
  }

  /// Mengubah tema, menyimpan preferensi, dan menampilkan feedback.
  Future<void> toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;

    await _prefs.setBool(_themeKey, _isDarkMode.value);

    Get.changeThemeMode(themeMode);

    if (_isDarkMode.value) {
      Get.snackbar(
        'Mode Gelap Diaktifkan',
        'Tampilan hemat daya dan nyaman untuk mata telah aktif.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        borderRadius: 12,
        icon: const Icon(Icons.dark_mode_rounded, color: Color(0xFFFFC107)),
      );
    } else {
      Get.snackbar(
        'Mode Terang Diaktifkan',
        'Tampilan cerah bersemangat telah aktif.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4F46E5),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        borderRadius: 12,
        icon: const Icon(Icons.light_mode_rounded, color: Colors.white),
      );
    }
  }

  /// Akses SharedPreferences jika dibutuhkan modul lain.
  SharedPreferences get prefs => _prefs;
}
