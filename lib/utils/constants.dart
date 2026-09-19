import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppColors {
  // Primary & Containers
  static const Color primary = Color(0xFF3F51B5); // Indigo
  static const Color primaryLight = Color(0xFFE8EAF6);
  static const Color primaryDark = Color(0xFF303F9F);

  // Secondary & Containers
  static const Color secondary = Color(0xFF00897B); // Teal
  static const Color secondaryLight = Color(0xFFE0F2F1);
  static const Color secondaryDark = Color(0xFF004D40);

  // Status & Semantic
  static const Color success = Color(0xFF2E7D32); // Green
  static const Color warning = Color(0xFFFF8F00); // Amber
  static const Color error = Color(0xFFD32F2F); // Red
  static const Color info = Color(0xFF0288D1); // Light Blue

  // GST Specific Tags
  static const Color cgstColor = Color(0xFF1565C0);
  static const Color sgstColor = Color(0xFF00838F);
  static const Color igstColor = Color(0xFF6A1B9A);

  // Surfaces & Backgrounds
  static const Color surface = Colors.white;
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardSurface = Colors.white;
  static const Color divider = Color(0xFFEEEEEE);
  static const Color outline = Color(0xFFE0E0E0);

  // Text
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF616161);
  static const Color textMuted = Color(0xFF9E9E9E);
}

class AppConstants {
  static const String appName = 'GST Billing System';
  static const String appTagline = 'Fast, Reliable & GST-Compliant Invoicing';

  // Standard Indian GST Slabs
  static const List<double> gstSlabs = [0.0, 5.0, 12.0, 18.0, 28.0];

  // List of Indian States and Union Territories with state codes
  static const List<String> indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    // Union Territories
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Jammu and Kashmir',
    'Ladakh',
    'Lakshadweep',
    'Puducherry',
  ];

  // Currency Formatter
  static final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  // Format currency with symbol
  static String formatCurrency(double amount) {
    return currencyFormatter.format(amount);
  }

  // Format currency without symbol
  static String formatAmountOnly(double amount) {
    return NumberFormat('#,##,##0.00', 'en_IN').format(amount);
  }

  // Date Formatters
  static final DateFormat invoiceDateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat invoiceDateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat monthYearFormat = DateFormat('MMMM yyyy');
}
