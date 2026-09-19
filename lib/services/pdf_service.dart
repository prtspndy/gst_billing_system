import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/bill.dart';
import '../models/business_profile.dart';
import '../utils/constants.dart';
import '../utils/number_to_words.dart';

class PdfService {
  static Future<Uint8List> generateInvoicePdf({
    required Bill bill,
    required BusinessProfile profile,
  }) async {
    final pdf = pw.Document();

    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();
    final fontMedium = await PdfGoogleFonts.robotoMedium();
    final fontItalic = await PdfGoogleFonts.robotoItalic();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(
          base: fontRegular,
          bold: fontBold,
          italic: fontItalic,
        ),
        build: (pw.Context context) {
          return [
            // ================= HEADER =================
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        profile.shopName,
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 18,
                          color: PdfColors.indigo900,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        profile.address,
                        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                      ),
                      pw.Text(
                        'State: ${profile.state}',
                        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                      ),
                      if (profile.gstin.isNotEmpty)
                        pw.Text(
                          'GSTIN: ${profile.gstin}',
                          style: pw.TextStyle(font: fontMedium, fontSize: 10),
                        ),
                      if (profile.phone.isNotEmpty)
                        pw.Text(
                          'Phone: ${profile.phone}',
                          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                        ),
                      if (profile.email.isNotEmpty)
                        pw.Text(
                          'Email: ${profile.email}',
                          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                        ),
                    ],
                  ),
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.indigo50,
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                        border: pw.Border.all(color: PdfColors.indigo200),
                      ),
                      child: pw.Text(
                        'TAX INVOICE',
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 14,
                          color: PdfColors.indigo900,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Invoice No: ${bill.invoiceNo}',
                      style: pw.TextStyle(font: fontBold, fontSize: 11),
                    ),
                    pw.Text(
                      'Date: ${AppConstants.invoiceDateFormat.format(bill.date)}',
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                    ),
                    pw.Text(
                      'Place of Supply: ${bill.partyState}',
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                    ),
                    pw.Container(
                      margin: const pw.EdgeInsets.only(top: 4),
                      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: pw.BoxDecoration(
                        color: bill.isInterState ? PdfColors.purple50 : PdfColors.teal50,
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                      ),
                      child: pw.Text(
                        bill.isInterState ? 'INTER-STATE (IGST)' : 'INTRA-STATE (CGST+SGST)',
                        style: pw.TextStyle(
                          font: fontMedium,
                          fontSize: 8,
                          color: bill.isInterState ? PdfColors.purple800 : PdfColors.teal800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            pw.Divider(thickness: 1, color: PdfColors.grey300, height: 24),

            // ================= BILL TO SECTION =================
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'BILL TO:',
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 9,
                            color: PdfColors.grey700,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          bill.partyName,
                          style: pw.TextStyle(font: fontBold, fontSize: 12),
                        ),
                        if (bill.partyAddress.isNotEmpty)
                          pw.Text(
                            bill.partyAddress,
                            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                          ),
                        pw.Text(
                          'State: ${bill.partyState}',
                          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                        ),
                      ],
                    ),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      if (bill.partyMobile.isNotEmpty)
                        pw.Text(
                          'Mobile: ${bill.partyMobile}',
                          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800),
                        ),
                      if (bill.partyGstin != null && bill.partyGstin!.isNotEmpty)
                        pw.Text(
                          'GSTIN: ${bill.partyGstin}',
                          style: pw.TextStyle(font: fontMedium, fontSize: 9),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 16),

            // ================= ITEMS TABLE =================
            pw.TableHelper.fromTextArray(
              headers: bill.isInterState
                  ? [
                      '#',
                      'Item Description',
                      'HSN',
                      'Qty',
                      'Rate',
                      'Taxable',
                      'GST%',
                      'IGST',
                      'Total'
                    ]
                  : [
                      '#',
                      'Item Description',
                      'HSN',
                      'Qty',
                      'Rate',
                      'Taxable',
                      'GST%',
                      'CGST',
                      'SGST',
                      'Total'
                    ],
              headerStyle: pw.TextStyle(
                font: fontBold,
                fontSize: 9,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.indigo800,
              ),
              headerHeight: 24,
              cellHeight: 22,
              cellStyle: const pw.TextStyle(fontSize: 8.5),
              cellAlignment: pw.Alignment.centerRight,
              cellAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.center,
                3: pw.Alignment.center,
                4: pw.Alignment.centerRight,
                5: pw.Alignment.centerRight,
                6: pw.Alignment.center,
                7: pw.Alignment.centerRight,
                8: pw.Alignment.centerRight,
                if (!bill.isInterState) 9: pw.Alignment.centerRight,
              },
              data: List<List<dynamic>>.generate(bill.items.length, (index) {
                final item = bill.items[index];
                if (bill.isInterState) {
                  return [
                    '${index + 1}',
                    item.name,
                    item.hsnCode ?? '-',
                    '${item.qty}',
                    AppConstants.formatAmountOnly(item.rate),
                    AppConstants.formatAmountOnly(item.taxableAmount),
                    AppConstants.formatGstRate(item.gstPercent),
                    AppConstants.formatAmountOnly(item.igst),
                    AppConstants.formatAmountOnly(item.lineTotal),
                  ];
                } else {
                  return [
                    '${index + 1}',
                    item.name,
                    item.hsnCode ?? '-',
                    '${item.qty}',
                    AppConstants.formatAmountOnly(item.rate),
                    AppConstants.formatAmountOnly(item.taxableAmount),
                    AppConstants.formatGstRate(item.gstPercent),
                    AppConstants.formatAmountOnly(item.cgst),
                    AppConstants.formatAmountOnly(item.sgst),
                    AppConstants.formatAmountOnly(item.lineTotal),
                  ];
                }
              }),
            ),

            pw.SizedBox(height: 16),

            // ================= TOTALS & SUMMARY =================
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Left side: Amount in words & terms
                pw.Expanded(
                  flex: 6,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey50,
                          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                          border: pw.Border.all(color: PdfColors.grey300),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'AMOUNT IN WORDS:',
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 8,
                                color: PdfColors.grey700,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              NumberToWords.convert(bill.grandTotal),
                              style: pw.TextStyle(font: fontItalic, fontSize: 9.5),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 12),
                      pw.Text(
                        'Terms & Conditions:',
                        style: pw.TextStyle(font: fontBold, fontSize: 8),
                      ),
                      pw.Text(
                        profile.terms,
                        style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(width: 16),

                // Right side: Calculation Breakdown
                pw.Expanded(
                  flex: 5,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                    ),
                    child: pw.Column(
                      children: [
                        _pdfSummaryRow('Subtotal (Taxable)', AppConstants.formatCurrency(bill.subtotal), fontRegular),
                        pw.Divider(height: 6, thickness: 0.5, color: PdfColors.grey300),
                        if (!bill.isInterState) ...[
                          _pdfSummaryRow('Total CGST', AppConstants.formatCurrency(bill.totalCgst), fontRegular),
                          _pdfSummaryRow('Total SGST', AppConstants.formatCurrency(bill.totalSgst), fontRegular),
                        ] else ...[
                          _pdfSummaryRow('Total IGST', AppConstants.formatCurrency(bill.totalIgst), fontRegular),
                        ],
                        pw.Divider(height: 6, thickness: 0.5, color: PdfColors.grey300),
                        _pdfSummaryRow('Total Tax', AppConstants.formatCurrency(bill.totalTax), fontMedium),
                        pw.Divider(height: 8, thickness: 1.5, color: PdfColors.indigo800),
                        _pdfSummaryRow(
                          'GRAND TOTAL',
                          AppConstants.formatCurrency(bill.grandTotal),
                          fontBold,
                          fontSize: 12,
                          color: PdfColors.indigo900,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            pw.Spacer(),

            // ================= FOOTER / SIGNATURE =================
            pw.Divider(thickness: 1, color: PdfColors.grey300),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'Thank you for your business!',
                  style: pw.TextStyle(font: fontItalic, fontSize: 9, color: PdfColors.grey600),
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'For ${profile.shopName}',
                      style: pw.TextStyle(font: fontBold, fontSize: 9),
                    ),
                    pw.SizedBox(height: 32),
                    pw.Text(
                      'Authorized Signatory',
                      style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _pdfSummaryRow(
    String title,
    String value,
    pw.Font font, {
    double fontSize = 9,
    PdfColor color = PdfColors.black,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: fontSize, color: color)),
          pw.Text(
            value,
            style: pw.TextStyle(font: font, fontSize: fontSize, color: color),
          ),
        ],
      ),
    );
  }

  /// Print invoice using native print dialog or web print
  static Future<void> printInvoice({
    required Bill bill,
    required BusinessProfile profile,
  }) async {
    final pdfBytes = await generateInvoicePdf(bill: bill, profile: profile);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'Invoice_${bill.invoiceNo}.pdf',
    );
  }

  /// Share invoice (PDF) via platform share sheet (WhatsApp, Email, etc.)
  static Future<void> shareInvoice({
    required Bill bill,
    required BusinessProfile profile,
  }) async {
    final pdfBytes = await generateInvoicePdf(bill: bill, profile: profile);
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'Invoice_${bill.invoiceNo}.pdf',
    );
  }
}
