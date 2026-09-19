import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../utils/constants.dart';

/// Minimal, professional Splash Screen for GST Billing System.
///
/// Prominently displays the official app logo and the app name
/// "GST Billing System" in the center without any animations.
class SplashScreen extends StatefulWidget {
  final VoidCallback? onLoaded;
  final Duration minimumDuration;

  const SplashScreen({
    super.key,
    this.onLoaded,
    this.minimumDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    // Minimum display duration & auth check in parallel
    await Future.wait([
      Future.delayed(widget.minimumDuration),
      _checkAuthStatus(),
    ]);

    if (!mounted) return;

    if (widget.onLoaded != null) {
      widget.onLoaded!();
    } else {
      await _navigateNext();
    }
  }

  Future<void> _checkAuthStatus() async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        await AuthService().authStateChanges.first.timeout(
          const Duration(seconds: 2),
          onTimeout: () => null,
        );
      }
    } catch (_) {
      // Gracefully handle offline or uninitialized environment in tests
    }
  }

  Future<void> _navigateNext() async {
    final isAuthenticated = FirebaseAuth.instance.currentUser != null;
    if (isAuthenticated) {
      final isSetupDone = await DatabaseService.instance.isShopSetupCompleted();
      if (!isSetupDone) {
        Get.offAllNamed(AppRoutes.shopSetup);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppMidnightColors.bg : const Color(0xFFF8F9FA);

    final size = MediaQuery.sizeOf(context);
    final isTabletOrDesktop = size.width >= 600;

    // Properly sized logo: 110 on mobile, 130 on tablet/desktop
    final logoSize = isTabletOrDesktop ? 130.0 : 110.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: bgColor,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppConstants.appLogo,
                width: logoSize,
                height: logoSize,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.receipt_long_rounded,
                    size: logoSize,
                    color: isDark ? Colors.white : AppColors.primary,
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                'GST Billing System',
                style: TextStyle(
                  fontSize: isTabletOrDesktop ? 26 : 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: isDark ? Colors.white : const Color(0xFF1C1B1F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
