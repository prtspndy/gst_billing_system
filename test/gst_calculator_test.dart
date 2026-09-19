import 'package:flutter_test/flutter_test.dart';
import 'package:gst_billing_system/models/item.dart';
import 'package:gst_billing_system/services/gst_calculator.dart';

void main() {
  group('GST Calculator - Supply Type Detection', () {
    test('Identifies Intra-State supply when shop and party states match', () {
      expect(GstCalculator.isInterStateSupply('Gujarat', 'Gujarat'), isFalse);
      expect(GstCalculator.isInterStateSupply(' Maharashtra ', 'maharashtra'), isFalse);
      expect(GstCalculator.isInterStateSupply('Delhi', 'delhi'), isFalse);
    });

    test('Identifies Inter-State supply when shop and party states differ', () {
      expect(GstCalculator.isInterStateSupply('Maharashtra', 'Gujarat'), isTrue);
      expect(GstCalculator.isInterStateSupply('Delhi', 'Haryana'), isTrue);
      expect(GstCalculator.isInterStateSupply('Karnataka', 'Tamil Nadu'), isTrue);
    });

    test('Gracefully handles null or empty states', () {
      expect(GstCalculator.isInterStateSupply(null, 'Gujarat'), isFalse);
      expect(GstCalculator.isInterStateSupply('Gujarat', null), isFalse);
      expect(GstCalculator.isInterStateSupply('', 'Gujarat'), isFalse);
      expect(GstCalculator.isInterStateSupply('Gujarat', ''), isFalse);
    });
  });

  group('GST Calculator - Line Item Calculation (Standard Slabs)', () {
    const shopState = 'Gujarat';

    test('0% GST Rate (Intra-State & Inter-State)', () {
      final item = Item(id: '1', name: 'Salt', unitPrice: 100.0, gstPercent: 0.0);

      // Intra-State
      final intra = GstCalculator.calculateLineItem(
        item: item,
        quantity: 2,
        rate: 100.0,
        partyState: 'Gujarat',
        shopState: shopState,
      );
      expect(intra.taxableAmount, 200.0);
      expect(intra.cgst, 0.0);
      expect(intra.sgst, 0.0);
      expect(intra.igst, 0.0);
      expect(intra.totalTax, 0.0);
      expect(intra.lineTotal, 200.0);

      // Inter-State
      final inter = GstCalculator.calculateLineItem(
        item: item,
        quantity: 2,
        rate: 100.0,
        partyState: 'Rajasthan',
        shopState: shopState,
      );
      expect(inter.taxableAmount, 200.0);
      expect(inter.cgst, 0.0);
      expect(inter.sgst, 0.0);
      expect(inter.igst, 0.0);
      expect(inter.totalTax, 0.0);
      expect(inter.lineTotal, 200.0);
    });

    test('5% GST Rate - Splits to 2.5% CGST + 2.5% SGST (Intra-State) or 5% IGST (Inter-State)', () {
      final item = Item(id: '2', name: 'Packaged Tea', unitPrice: 200.0, gstPercent: 5.0);

      // Intra-State
      final intra = GstCalculator.calculateLineItem(
        item: item,
        quantity: 3,
        rate: 200.0,
        partyState: 'Gujarat',
        shopState: shopState,
      );
      expect(intra.taxableAmount, 600.0);
      expect(intra.cgst, 15.0); // 600 * 2.5% = 15
      expect(intra.sgst, 15.0); // 600 * 2.5% = 15
      expect(intra.igst, 0.0);
      expect(intra.totalTax, 30.0);
      expect(intra.lineTotal, 630.0);

      // Inter-State
      final inter = GstCalculator.calculateLineItem(
        item: item,
        quantity: 3,
        rate: 200.0,
        partyState: 'Madhya Pradesh',
        shopState: shopState,
      );
      expect(inter.taxableAmount, 600.0);
      expect(inter.cgst, 0.0);
      expect(inter.sgst, 0.0);
      expect(inter.igst, 30.0); // 600 * 5% = 30
      expect(inter.totalTax, 30.0);
      expect(inter.lineTotal, 630.0);
    });

    test('12% GST Rate - Splits to 6% CGST + 6% SGST (Intra-State) or 12% IGST (Inter-State)', () {
      final item = Item(id: '3', name: 'Processed Food', unitPrice: 500.0, gstPercent: 12.0);

      // Intra-State
      final intra = GstCalculator.calculateLineItem(
        item: item,
        quantity: 2,
        rate: 500.0,
        partyState: 'Gujarat',
        shopState: shopState,
      );
      expect(intra.taxableAmount, 1000.0);
      expect(intra.cgst, 60.0);
      expect(intra.sgst, 60.0);
      expect(intra.igst, 0.0);
      expect(intra.totalTax, 120.0);
      expect(intra.lineTotal, 1120.0);

      // Inter-State
      final inter = GstCalculator.calculateLineItem(
        item: item,
        quantity: 2,
        rate: 500.0,
        partyState: 'Maharashtra',
        shopState: shopState,
      );
      expect(inter.taxableAmount, 1000.0);
      expect(inter.cgst, 0.0);
      expect(inter.sgst, 0.0);
      expect(inter.igst, 120.0);
      expect(inter.totalTax, 120.0);
      expect(inter.lineTotal, 1120.0);
    });

    test('18% GST Rate - Splits to 9% CGST + 9% SGST (Intra-State) or 18% IGST (Inter-State)', () {
      final item = Item(id: '4', name: 'Electronics Monitor', unitPrice: 10000.0, gstPercent: 18.0);

      // Intra-State
      final intra = GstCalculator.calculateLineItem(
        item: item,
        quantity: 1,
        rate: 10000.0,
        partyState: 'Gujarat',
        shopState: shopState,
      );
      expect(intra.taxableAmount, 10000.0);
      expect(intra.cgst, 900.0); // 10000 * 9% = 900
      expect(intra.sgst, 900.0); // 10000 * 9% = 900
      expect(intra.igst, 0.0);
      expect(intra.totalTax, 1800.0);
      expect(intra.lineTotal, 11800.0);

      // Inter-State
      final inter = GstCalculator.calculateLineItem(
        item: item,
        quantity: 1,
        rate: 10000.0,
        partyState: 'Karnataka',
        shopState: shopState,
      );
      expect(inter.taxableAmount, 10000.0);
      expect(inter.cgst, 0.0);
      expect(inter.sgst, 0.0);
      expect(inter.igst, 1800.0); // 10000 * 18% = 1800
      expect(inter.totalTax, 1800.0);
      expect(inter.lineTotal, 11800.0);
    });

    test('28% GST Rate - Splits to 14% CGST + 14% SGST (Intra-State) or 28% IGST (Inter-State)', () {
      final item = Item(id: '5', name: 'Air Conditioner', unitPrice: 35000.0, gstPercent: 28.0);

      // Intra-State
      final intra = GstCalculator.calculateLineItem(
        item: item,
        quantity: 1,
        rate: 35000.0,
        partyState: 'Gujarat',
        shopState: shopState,
      );
      expect(intra.taxableAmount, 35000.0);
      expect(intra.cgst, 4900.0); // 35000 * 14% = 4900
      expect(intra.sgst, 4900.0); // 35000 * 14% = 4900
      expect(intra.igst, 0.0);
      expect(intra.totalTax, 9800.0);
      expect(intra.lineTotal, 44800.0);

      // Inter-State
      final inter = GstCalculator.calculateLineItem(
        item: item,
        quantity: 1,
        rate: 35000.0,
        partyState: 'Punjab',
        shopState: shopState,
      );
      expect(inter.taxableAmount, 35000.0);
      expect(inter.cgst, 0.0);
      expect(inter.sgst, 0.0);
      expect(inter.igst, 9800.0); // 35000 * 28% = 9800
      expect(inter.totalTax, 9800.0);
      expect(inter.lineTotal, 44800.0);
    });

    test('Custom GST Rate (e.g., 3% for Gold, 7.5% Hospitality)', () {
      final gold = Item(id: '6', name: 'Gold Coin', unitPrice: 60000.0, gstPercent: 3.0);

      // Intra-State 3% -> 1.5% CGST + 1.5% SGST
      final intra = GstCalculator.calculateLineItem(
        item: gold,
        quantity: 1,
        rate: 60000.0,
        partyState: 'Gujarat',
        shopState: shopState,
      );
      expect(intra.taxableAmount, 60000.0);
      expect(intra.cgst, 900.0); // 60000 * 1.5% = 900
      expect(intra.sgst, 900.0); // 60000 * 1.5% = 900
      expect(intra.igst, 0.0);
      expect(intra.lineTotal, 61800.0);

      // Inter-State 3% -> 3% IGST
      final inter = GstCalculator.calculateLineItem(
        item: gold,
        quantity: 1,
        rate: 60000.0,
        partyState: 'Delhi',
        shopState: shopState,
      );
      expect(inter.taxableAmount, 60000.0);
      expect(inter.cgst, 0.0);
      expect(inter.sgst, 0.0);
      expect(inter.igst, 1800.0); // 60000 * 3% = 1800
      expect(inter.lineTotal, 61800.0);
    });
  });

  group('GST Calculator - Bill Totals Aggregation', () {
    const shopState = 'Gujarat';

    test('Aggregates multi-item intra-state bill correctly', () {
      final item1 = GstCalculator.calculateLineItem(
        item: Item(id: '1', name: 'Item A (18%)', unitPrice: 1000.0, gstPercent: 18.0),
        quantity: 2,
        rate: 1000.0,
        partyState: 'Gujarat',
        shopState: shopState,
      ); // Taxable: 2000, CGST: 180, SGST: 180, Total: 2360

      final item2 = GstCalculator.calculateLineItem(
        item: Item(id: '2', name: 'Item B (5%)', unitPrice: 500.0, gstPercent: 5.0),
        quantity: 4,
        rate: 500.0,
        partyState: 'Gujarat',
        shopState: shopState,
      ); // Taxable: 2000, CGST: 50, SGST: 50, Total: 2100

      final totals = GstCalculator.calculateBillTotals(
        items: [item1, item2],
        partyState: 'Gujarat',
        shopState: shopState,
      );

      expect(totals.isInterState, isFalse);
      expect(totals.subtotal, 4000.0);
      expect(totals.totalCgst, 230.0);
      expect(totals.totalSgst, 230.0);
      expect(totals.totalIgst, 0.0);
      expect(totals.totalTax, 460.0);
      expect(totals.grandTotal, 4460.0);
    });

    test('Aggregates multi-item inter-state bill correctly', () {
      final item1 = GstCalculator.calculateLineItem(
        item: Item(id: '1', name: 'Item A (18%)', unitPrice: 1000.0, gstPercent: 18.0),
        quantity: 2,
        rate: 1000.0,
        partyState: 'Maharashtra',
        shopState: shopState,
      ); // Taxable: 2000, IGST: 360, Total: 2360

      final item2 = GstCalculator.calculateLineItem(
        item: Item(id: '2', name: 'Item B (12%)', unitPrice: 1500.0, gstPercent: 12.0),
        quantity: 1,
        rate: 1500.0,
        partyState: 'Maharashtra',
        shopState: shopState,
      ); // Taxable: 1500, IGST: 180, Total: 1680

      final totals = GstCalculator.calculateBillTotals(
        items: [item1, item2],
        partyState: 'Maharashtra',
        shopState: shopState,
      );

      expect(totals.isInterState, isTrue);
      expect(totals.subtotal, 3500.0);
      expect(totals.totalCgst, 0.0);
      expect(totals.totalSgst, 0.0);
      expect(totals.totalIgst, 540.0);
      expect(totals.totalTax, 540.0);
      expect(totals.grandTotal, 4040.0);
    });

    test('Handles rounding precision for odd amounts correctly', () {
      final item = GstCalculator.calculateLineItem(
        item: Item(id: '1', name: 'Odd Item', unitPrice: 33.33, gstPercent: 18.0),
        quantity: 3,
        rate: 33.33,
        partyState: 'Gujarat',
        shopState: shopState,
      );
      // Taxable = 33.33 * 3 = 99.99
      // CGST = 99.99 * 9% = 8.9991 -> 9.00
      // SGST = 99.99 * 9% = 8.9991 -> 9.00
      // Total = 99.99 + 9.00 + 9.00 = 117.99
      expect(item.taxableAmount, 99.99);
      expect(item.cgst, 9.0);
      expect(item.sgst, 9.0);
      expect(item.lineTotal, 117.99);
    });
  });
}
