import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:gst_billing_system/models/bill.dart';
import 'package:gst_billing_system/models/business_profile.dart';
import 'package:gst_billing_system/models/item.dart';
import 'package:gst_billing_system/services/gst_calculator.dart';
import 'package:gst_billing_system/services/pdf_service.dart';

void main() {
  test('Generate 3 sample PDF invoices for project submission deliverables', () async {
    final sampleDir = Directory('sample_invoices');
    if (!sampleDir.existsSync()) {
      sampleDir.createSync(recursive: true);
    }

    const shopProfile = BusinessProfile(
      shopName: 'Apex Electronics & Appliances',
      address: 'Shop 102, Millennium Commercial Complex, Ring Road, Surat',
      state: 'Gujarat',
      gstin: '24AABCA1234F1Z9',
      phone: '+91 98765 43210',
      email: 'contact@apexelectronics.com',
      terms: '1. Goods once sold will not be taken back or exchanged.\n2. 1 Year manufacturer warranty on electronic appliances.\n3. All disputes are subject to Surat jurisdiction.',
    );

    // ================= Sample 1: Intra-State Invoice (Gujarat to Gujarat) =================
    final item1A = GstCalculator.calculateLineItem(
      item: Item(id: 'i1', name: 'LED Smart TV 43" 4K UHD', hsnCode: '8528', unitPrice: 24999.0, gstPercent: 18.0),
      quantity: 1,
      rate: 24999.0,
      partyState: 'Gujarat',
      shopState: 'Gujarat',
    );
    final item1B = GstCalculator.calculateLineItem(
      item: Item(id: 'i2', name: 'Heavy Duty Wall Mount Bracket', hsnCode: '8302', unitPrice: 850.0, gstPercent: 18.0),
      quantity: 1,
      rate: 850.0,
      partyState: 'Gujarat',
      shopState: 'Gujarat',
    );
    final totals1 = GstCalculator.calculateBillTotals(
      items: [item1A, item1B],
      partyState: 'Gujarat',
      shopState: 'Gujarat',
    );

    final bill1 = Bill(
      id: 'sample_bill_1',
      invoiceNo: 'INV-202609-0001',
      date: DateTime.now().subtract(const Duration(days: 2)),
      partyId: 'p1',
      partyName: 'Rajesh Patel (Patel Trading Co.)',
      partyMobile: '9825012345',
      partyAddress: 'B-12, Green City Complex, Adajan, Surat',
      partyState: 'Gujarat',
      partyGstin: '24AACCP1234A1Z1',
      items: [item1A, item1B],
      subtotal: totals1.subtotal,
      totalCgst: totals1.totalCgst,
      totalSgst: totals1.totalSgst,
      totalIgst: totals1.totalIgst,
      totalTax: totals1.totalTax,
      grandTotal: totals1.grandTotal,
      isInterState: totals1.isInterState,
      paymentStatus: 'Paid',
      notes: 'Payment received via UPI. Goods delivered in good condition.',
    );

    final pdf1Bytes = await PdfService.generateInvoicePdf(bill: bill1, profile: shopProfile);
    File('sample_invoices/Sample_Invoice_01_IntraState.pdf').writeAsBytesSync(pdf1Bytes);

    // ================= Sample 2: Inter-State Invoice (Gujarat to Maharashtra -> IGST) =================
    final item2A = GstCalculator.calculateLineItem(
      item: Item(id: 'i3', name: 'Ergonomic Standing Desk Frame', hsnCode: '9403', unitPrice: 16500.0, gstPercent: 18.0),
      quantity: 2,
      rate: 16500.0,
      partyState: 'Maharashtra',
      shopState: 'Gujarat',
    );
    final item2B = GstCalculator.calculateLineItem(
      item: Item(id: 'i4', name: 'High-Speed Type-C Thunderbolt Dock', hsnCode: '8471', unitPrice: 4200.0, gstPercent: 18.0),
      quantity: 2,
      rate: 4200.0,
      partyState: 'Maharashtra',
      shopState: 'Gujarat',
    );
    final totals2 = GstCalculator.calculateBillTotals(
      items: [item2A, item2B],
      partyState: 'Maharashtra',
      shopState: 'Gujarat',
    );

    final bill2 = Bill(
      id: 'sample_bill_2',
      invoiceNo: 'INV-202609-0002',
      date: DateTime.now().subtract(const Duration(days: 1)),
      partyId: 'p2',
      partyName: 'TechVibe IT Solutions Pvt Ltd',
      partyMobile: '9122334455',
      partyAddress: 'Floor 4, Tower B, Cyber City, Hinjawadi, Pune',
      partyState: 'Maharashtra',
      partyGstin: '27AABCT9876M1Z4',
      items: [item2A, item2B],
      subtotal: totals2.subtotal,
      totalCgst: totals2.totalCgst,
      totalSgst: totals2.totalSgst,
      totalIgst: totals2.totalIgst,
      totalTax: totals2.totalTax,
      grandTotal: totals2.grandTotal,
      isInterState: totals2.isInterState,
      paymentStatus: 'Paid',
      notes: 'Dispatched via BlueDart Air Cargo. E-Way bill generated.',
    );

    final pdf2Bytes = await PdfService.generateInvoicePdf(bill: bill2, profile: shopProfile);
    File('sample_invoices/Sample_Invoice_02_InterState_IGST.pdf').writeAsBytesSync(pdf2Bytes);

    // ================= Sample 3: Multi-Slab Invoice (5%, 12%, 18% slabs) =================
    final item3A = GstCalculator.calculateLineItem(
      item: Item(id: 'i5', name: 'Solar Charge Controller 12V/24V', hsnCode: '8504', unitPrice: 3200.0, gstPercent: 5.0),
      quantity: 1,
      rate: 3200.0,
      partyState: 'Gujarat',
      shopState: 'Gujarat',
    );
    final item3B = GstCalculator.calculateLineItem(
      item: Item(id: 'i6', name: 'Industrial Aluminum Equipment Enclosure', hsnCode: '7616', unitPrice: 1800.0, gstPercent: 12.0),
      quantity: 2,
      rate: 1800.0,
      partyState: 'Gujarat',
      shopState: 'Gujarat',
    );
    final item3C = GstCalculator.calculateLineItem(
      item: Item(id: 'i7', name: 'Pure Sine Wave Inverter 1100VA', hsnCode: '8504', unitPrice: 6500.0, gstPercent: 18.0),
      quantity: 1,
      rate: 6500.0,
      partyState: 'Gujarat',
      shopState: 'Gujarat',
    );

    final totals3 = GstCalculator.calculateBillTotals(
      items: [item3A, item3B, item3C],
      partyState: 'Gujarat',
      shopState: 'Gujarat',
    );

    final bill3 = Bill(
      id: 'sample_bill_3',
      invoiceNo: 'INV-202609-0003',
      date: DateTime.now(),
      partyId: 'p3',
      partyName: 'Mehta Solar Power & Engineering',
      partyMobile: '9426098765',
      partyAddress: 'Plot 78, GIDC Phase II, Vatva, Ahmedabad',
      partyState: 'Gujarat',
      partyGstin: '24AABCM4567K1Z8',
      items: [item3A, item3B, item3C],
      subtotal: totals3.subtotal,
      totalCgst: totals3.totalCgst,
      totalSgst: totals3.totalSgst,
      totalIgst: totals3.totalIgst,
      totalTax: totals3.totalTax,
      grandTotal: totals3.grandTotal,
      isInterState: totals3.isInterState,
      paymentStatus: 'Paid',
      notes: 'Customer collected from warehouse. Warranty card enclosed.',
    );

    final pdf3Bytes = await PdfService.generateInvoicePdf(bill: bill3, profile: shopProfile);
    File('sample_invoices/Sample_Invoice_03_MultiSlab.pdf').writeAsBytesSync(pdf3Bytes);

    expect(File('sample_invoices/Sample_Invoice_01_IntraState.pdf').existsSync(), true);
    expect(File('sample_invoices/Sample_Invoice_02_InterState_IGST.pdf').existsSync(), true);
    expect(File('sample_invoices/Sample_Invoice_03_MultiSlab.pdf').existsSync(), true);
  });
}
