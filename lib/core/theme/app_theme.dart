import 'package:flutter/material.dart';

class AppTheme {
  // Shared brand accents
  static const Color primaryIndigo = Color(0xFF3F51B5);
  static const Color secondaryTeal = Color(0xFF00897B);
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color warningAmber = Color(0xFFFF8F00);
  static const Color errorRed = Color(0xFFD32F2F);

  // Tax semantic colors
  static const Color cgstColor = Color(0xFF1565C0);
  static const Color sgstColor = Color(0xFF00838F);
  static const Color igstColor = Color(0xFF6A1B9A);

  // ================= LIGHT THEME =================
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryIndigo,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE8EAF6),
      onPrimaryContainer: Color(0xFF1A237E),
      secondary: secondaryTeal,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFE0F2F1),
      onSecondaryContainer: Color(0xFF004D40),
      surface: Colors.white,
      onSurface: Color(0xFF1C1B1F),
      error: errorRed,
      onError: Colors.white,
      outline: Color(0xFFE0E0E0),
      outlineVariant: Color(0xFFEEEEEE),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: primaryIndigo,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryIndigo, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: errorRed),
      ),
      labelStyle: const TextStyle(fontSize: 14, color: Color(0xFF616161)),
      hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFE8EAF6),
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: primaryIndigo,
          );
        }
        return const TextStyle(fontSize: 12, color: Color(0xFF757575));
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: primaryIndigo);
        }
        return const IconThemeData(color: Color(0xFF757575));
      }),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: primaryIndigo,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );

  // ================= DARK THEME =================
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF9FA8DA),
      onPrimary: Color(0xFF1A237E),
      primaryContainer: Color(0xFF303F9F),
      onPrimaryContainer: Colors.white,
      secondary: Color(0xFF80CBC4),
      onSecondary: Color(0xFF004D40),
      secondaryContainer: Color(0xFF00695C),
      onSecondaryContainer: Colors.white,
      surface: Color(0xFF1E1E1E),
      onSurface: Color(0xFFE6E1E5),
      error: Color(0xFFEF5350),
      onError: Colors.black,
      outline: Color(0xFF424242),
      outlineVariant: Color(0xFF2C2C2C),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFF383838)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF242424),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF424242)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF424242)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF9FA8DA), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFEF5350)),
      ),
      labelStyle: const TextStyle(fontSize: 14, color: Color(0xFFB0B0B0)),
      hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      indicatorColor: const Color(0xFF303F9F),
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9FA8DA),
          );
        }
        return const TextStyle(fontSize: 12, color: Color(0xFFB0B0B0));
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: Color(0xFF9FA8DA));
        }
        return const IconThemeData(color: Color(0xFFB0B0B0));
      }),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
