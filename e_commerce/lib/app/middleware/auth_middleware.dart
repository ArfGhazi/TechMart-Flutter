import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/local/auth_service.dart';
import '../routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();

    if (!authService.isLoggedIn.value) {
      return RouteSettings(
        name: Routes.LOGIN,
        arguments: route ?? Routes.CHECKOUT,
      );
    }

    return null;
  }
}
