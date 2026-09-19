import 'package:flutter/material.dart';

/// Canonical midnight slate theme color tokens (from the reference login UI)
class AppMidnightColors {
  static const Color bg = Color(0xFF0B0E14);
  static const Color card = Color(0xFF141923);
  static const Color input = Color(0xFF161B26);
  static const Color border = Color(0xFF232B3E);
  static const Color borderFocused = Color(0xFF3F51B5);
  static const Color btnPrimary = Color(0xFF222D42);
  static const Color btnBorder = Color(0xFF2E3D59);
  static const Color btnGoogle = Color(0xFF161B26);
  static const Color divider = Color(0xFF1E2536);
  static const Color textMuted = Color(0xFF838C9E);
  static const Color iconMuted = Color(0xFF788296);
}

/// Semantic GST Tax and Status colors defined as a ThemeExtension
class TaxColors extends ThemeExtension<TaxColors> {
  final Color cgst;
  final Color sgst;
  final Color igst;
  final Color taxable;
  final Color paid;
  final Color unpaid;
  final Color partial;

  const TaxColors({
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.taxable,
    required this.paid,
    required this.unpaid,
    required this.partial,
  });

  static const TaxColors light = TaxColors(
    cgst: Color(0xFF1565C0),
    sgst: Color(0xFF00838F),
    igst: Color(0xFF6A1B9A),
    taxable: Color(0xFF37474F),
    paid: Color(0xFF2E7D32),
    unpaid: Color(0xFFD32F2F),
    partial: Color(0xFFFF8F00),
  );

  static const TaxColors dark = TaxColors(
    cgst: Color(0xFF64B5F6),
    sgst: Color(0xFF4DD0E1),
    igst: Color(0xFFBA68C8),
    taxable: AppMidnightColors.textMuted,
    paid: Color(0xFF4CAF50),
    unpaid: Color(0xFFEF5350),
    partial: Color(0xFFFFB74D),
  );

  @override
  TaxColors copyWith({
    Color? cgst,
    Color? sgst,
    Color? igst,
    Color? taxable,
    Color? paid,
    Color? unpaid,
    Color? partial,
  }) {
    return TaxColors(
      cgst: cgst ?? this.cgst,
      sgst: sgst ?? this.sgst,
      igst: igst ?? this.igst,
      taxable: taxable ?? this.taxable,
      paid: paid ?? this.paid,
      unpaid: unpaid ?? this.unpaid,
      partial: partial ?? this.partial,
    );
  }

  @override
  TaxColors lerp(ThemeExtension<TaxColors>? other, double t) {
    if (other is! TaxColors) return this;
    return TaxColors(
      cgst: Color.lerp(cgst, other.cgst, t) ?? cgst,
      sgst: Color.lerp(sgst, other.sgst, t) ?? sgst,
      igst: Color.lerp(igst, other.igst, t) ?? igst,
      taxable: Color.lerp(taxable, other.taxable, t) ?? taxable,
      paid: Color.lerp(paid, other.paid, t) ?? paid,
      unpaid: Color.lerp(unpaid, other.unpaid, t) ?? unpaid,
      partial: Color.lerp(partial, other.partial, t) ?? partial,
    );
  }
}

/// Helper extension on BuildContext to quickly access tax colors and scheme
extension TaxColorsExtension on BuildContext {
  TaxColors get taxColors =>
      Theme.of(this).extension<TaxColors>() ?? TaxColors.light;
}
