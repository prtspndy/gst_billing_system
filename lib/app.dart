import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/bindings/initial_binding.dart';
import 'core/routes/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_shell.dart';
import 'services/auth_service.dart';
import 'utils/constants.dart';

class GstBillingApp extends StatelessWidget {
  const GstBillingApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put<ThemeController>(ThemeController(), permanent: true);

    return Obx(
      () => GetMaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,
        initialBinding: InitialBinding(),
        getPages: AppPages.pages,
        home: StreamBuilder<User?>(
          stream: AuthService().authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasData && snapshot.data != null) {
              return const HomeShell();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
