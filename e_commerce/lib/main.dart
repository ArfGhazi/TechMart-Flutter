import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/bindings/initial_binding.dart';
import 'app/core/theme/app_theme.dart';
import 'app/data/local/product_local_datasource.dart';
import 'app/data/local/storage_service.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi SharedPreferences dan Hive CE.
  final storageService = await Get.putAsync(
    () => StorageService().init(),
    permanent: true,
  );

  // Daftarkan local data source setelah Hive siap.
  Get.put<ProductLocalDataSource>(
    ProductLocalDataSourceImpl(),
    permanent: true,
  );

  runApp(
    GetMaterialApp(
      title: 'KicksStore',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: storageService.themeMode,
      initialRoute: AppPages.INITIAL,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
    ),
  );
}
