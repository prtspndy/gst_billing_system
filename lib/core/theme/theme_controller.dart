import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const String _themePrefKey = 'user_theme_mode';

  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.dark) return true;
    if (_themeMode.value == ThemeMode.light) return false;
    return Get.isPlatformDarkMode;
  }

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_themePrefKey);
    if (savedMode == 'light') {
      _themeMode.value = ThemeMode.light;
    } else if (savedMode == 'dark') {
      _themeMode.value = ThemeMode.dark;
    } else {
      _themeMode.value = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    final prefs = await SharedPreferences.getInstance();
    if (mode == ThemeMode.light) {
      await prefs.setString(_themePrefKey, 'light');
    } else if (mode == ThemeMode.dark) {
      await prefs.setString(_themePrefKey, 'dark');
    } else {
      await prefs.setString(_themePrefKey, 'system');
    }
  }
}
