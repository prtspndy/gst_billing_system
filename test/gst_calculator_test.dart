import 'package:flutter_test/flutter_test.dart';
import 'package:gst_billing_system/models/item.dart';
import 'package:gst_billing_system/services/gst_calculator.dart';
import 'package:gst_billing_system/utils/number_to_words.dart';
import 'package:gst_billing_system/utils/validators.dart';

void main() {
  group('GST Calculator Tests', () {
    final tvItem = Item(
      id: '1',
      name: 'LED TV',
      hsnCode: '8528',
      unitPrice: 25000.0,
      gstPercent: 18.0,
    );

    final cableItem = Item(
      id: '2',
      name: 'USB Cable',
      hsnCode: '8544',
      unitPrice: 299.0,
      gstPercent: 18.0,
    );

    test('Intra-State GST: Splits GST equally into CGST and SGST', () {
      final lineItem = GstCalculator.calculateLineItem(
        item: tvItem,
        quantity: 1,
        rate: 25000.0,
        partyState: 'Gujarat',
        shopState: 'Gujarat',
      );

      expect(lineItem.taxableAmount, 25000.0);
      expect(lineItem.cgst, 2250.0); // 9% of 25,000
      expect(lineItem.sgst, 2250.0); // 9% of 25,000
      expect(lineItem.igst, 0.0);
      expect(lineItem.lineTotal, 29500.0);
    });

    test('Inter-State GST: Applies full rate to IGST with zero CGST/SGST', () {
      final lineItem = GstCalculator.calculateLineItem(
        item: tvItem,
        quantity: 1,
        rate: 25000.0,
        partyState: 'Maharashtra',
        shopState: 'Gujarat',
      );

      expect(lineItem.taxableAmount, 25000.0);
      expect(lineItem.cgst, 0.0);
      expect(lineItem.sgst, 0.0);
      expect(lineItem.igst, 4500.0); // 18% of 25,000
      expect(lineItem.lineTotal, 29500.0);
    });

    test('Multiple items totals calculation with proper rounding', () {
      final item1 = GstCalculator.calculateLineItem(
        item: tvItem,
        quantity: 1,
        rate: 25000.0,
        partyState: 'Gujarat',
        shopState: 'Gujarat',
      );

      final item2 = GstCalculator.calculateLineItem(
        item: cableItem,
        quantity: 3,
        rate: 299.0,
        partyState: 'Gujarat',
        shopState: 'Gujarat',
      );

      final totals = GstCalculator.calculateBillTotals(
        items: [item1, item2],
        partyState: 'Gujarat',
        shopState: 'Gujarat',
      );

      expect(totals.isInterState, false);
      expect(totals.subtotal, 25897.0); // 25000 + (299 * 3 = 897)
      expect(totals.totalCgst, 2330.73); // 2250 + 80.73
      expect(totals.totalSgst, 2330.73); // 2250 + 80.73
      expect(totals.totalIgst, 0.0);
      expect(totals.totalTax, 4661.46);
      expect(totals.grandTotal, 30558.46);
    });
  });

  group('Number to Words Tests', () {
    test('Converts exact rupees', () {
      expect(NumberToWords.convert(25000), 'Twenty-Five Thousand Rupees Only');
    });

    test('Converts rupees and paise correctly', () {
      expect(
        NumberToWords.convert(30558.46),
        'Thirty Thousand Five Hundred Fifty-Eight Rupees and Forty-Six Paise Only',
      );
    });

    test('Converts zero rupees', () {
      expect(NumberToWords.convert(0), 'Zero Rupees Only');
    });
  });

  group('Validators Tests', () {
    test('Mobile validation', () {
      expect(Validators.mobile('9876543210'), null);
      expect(Validators.mobile('12345'), isNotNull);
      expect(Validators.mobile(''), isNotNull);
    });

    test('GSTIN validation', () {
      expect(Validators.gstin('24AAAAA0000A1Z5'), null);
      expect(Validators.gstin('27AABCP5678K1Z3'), null);
      expect(Validators.gstin('INVALID'), isNotNull);
      expect(Validators.gstin('', required: false), null);
    });

    test('Positive number validation', () {
      expect(Validators.positiveNumber('250.50', 'Price'), null);
      expect(Validators.positiveNumber('-10', 'Price'), isNotNull);
      expect(Validators.positiveNumber('0', 'Price'), isNotNull);
      expect(Validators.positiveNumber('abc', 'Price'), isNotNull);
    });
  });
}
