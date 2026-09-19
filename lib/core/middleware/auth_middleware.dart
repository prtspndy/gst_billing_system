import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    final isAuthenticated = authController.isAuthenticated;

    // If trying to access protected routes while unauthenticated, redirect to login
    if (!isAuthenticated &&
        route != AppRoutes.login &&
        route != AppRoutes.register &&
        route != AppRoutes.splash) {
      return const RouteSettings(name: AppRoutes.login);
    }

    // If already authenticated and trying to go to login or register, redirect to home
    if (isAuthenticated && (route == AppRoutes.login || route == AppRoutes.register)) {
      return const RouteSettings(name: AppRoutes.home);
    }

    return null;
  }
}
