import '../models/bill_item.dart';
import '../models/item.dart';

class GstCalculationResult {
  final List<BillItem> items;
  final double subtotal;
  final double totalCgst;
  final double totalSgst;
  final double totalIgst;
  final double totalTax;
  final double grandTotal;
  final bool isInterState;

  const GstCalculationResult({
    required this.items,
    required this.subtotal,
    required this.totalCgst,
    required this.totalSgst,
    required this.totalIgst,
    required this.totalTax,
    required this.grandTotal,
    required this.isInterState,
  });
}

class GstCalculator {
  /// Rounding helper for currency amounts to 2 decimal places
  static double round(double value) {
    return (value * 100).roundToDouble() / 100;
  }

  /// Calculates a single BillItem line item
  static BillItem calculateLineItem({
    required Item item,
    required int quantity,
    required double rate,
    required String partyState,
    required String shopState,
    double? customGstPercent,
  }) {
    final double gstPercent = customGstPercent ?? item.gstPercent;
    final double taxableAmount = round(rate * quantity);

    final bool isInterState =
        partyState.trim().toLowerCase() != shopState.trim().toLowerCase();

    double cgst = 0.0;
    double sgst = 0.0;
    double igst = 0.0;

    if (isInterState) {
      // Different state -> IGST (full GST% as one tax)
      igst = round((taxableAmount * gstPercent) / 100);
    } else {
      // Same state -> CGST + SGST (split the item's GST% equally)
      final halfRate = gstPercent / 2.0;
      cgst = round((taxableAmount * halfRate) / 100);
      sgst = round((taxableAmount * halfRate) / 100);
    }

    final double lineTotal = round(taxableAmount + cgst + sgst + igst);

    return BillItem(
      itemId: item.id,
      name: item.name,
      hsnCode: item.hsnCode,
      qty: quantity,
      rate: rate,
      gstPercent: gstPercent,
      taxableAmount: taxableAmount,
      cgst: cgst,
      sgst: sgst,
      igst: igst,
      lineTotal: lineTotal,
    );
  }

  /// Calculates full bill totals given a list of line items
  static GstCalculationResult calculateBillTotals({
    required List<BillItem> items,
    required String partyState,
    required String shopState,
  }) {
    final bool isInterState =
        partyState.trim().toLowerCase() != shopState.trim().toLowerCase();

    double subtotal = 0.0;
    double totalCgst = 0.0;
    double totalSgst = 0.0;
    double totalIgst = 0.0;

    for (final item in items) {
      subtotal += item.taxableAmount;
      totalCgst += item.cgst;
      totalSgst += item.sgst;
      totalIgst += item.igst;
    }

    subtotal = round(subtotal);
    totalCgst = round(totalCgst);
    totalSgst = round(totalSgst);
    totalIgst = round(totalIgst);

    final double totalTax = round(totalCgst + totalSgst + totalIgst);
    final double grandTotal = round(subtotal + totalTax);

    return GstCalculationResult(
      items: items,
      subtotal: subtotal,
      totalCgst: totalCgst,
      totalSgst: totalSgst,
      totalIgst: totalIgst,
      totalTax: totalTax,
      grandTotal: grandTotal,
      isInterState: isInterState,
    );
  }
}
