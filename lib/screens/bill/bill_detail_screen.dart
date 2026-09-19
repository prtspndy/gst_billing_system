import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import '../../models/bill.dart';
import '../../providers/bill_provider.dart';
import '../../providers/business_profile_provider.dart';
import '../../services/pdf_service.dart';
import '../../utils/constants.dart';
import '../../widgets/bill_item_tile.dart';
import '../../widgets/gst_summary_card.dart';

class BillDetailScreen extends StatefulWidget {
  final String billId;

  const BillDetailScreen({super.key, required this.billId});

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
  Bill? _bill;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBill();
  }

  Future<void> _loadBill() async {
    setState(() => _isLoading = true);
    final billProvider = Provider.of<BillProvider>(context, listen: false);
    _bill = await billProvider.getBillById(widget.billId);
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sharePdf() async {
    if (_bill == null) return;
    final profile = Provider.of<BusinessProfileProvider>(context, listen: false).profile;
    try {
      await PdfService.shareInvoice(bill: _bill!, profile: profile);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing invoice: $e')),
        );
      }
    }
  }

  Future<void> _printOrDownloadPdf() async {
    if (_bill == null) return;
    final profile = Provider.of<BusinessProfileProvider>(context, listen: false).profile;
    try {
      await PdfService.printInvoice(bill: _bill!, profile: profile);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error printing invoice: $e')),
        );
      }
    }
  }

  void _previewPdf() {
    if (_bill == null) return;
    final profile = Provider.of<BusinessProfileProvider>(context, listen: false).profile;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('PDF Preview - ${_bill!.invoiceNo}'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: PdfPreview(
            build: (format) => PdfService.generateInvoicePdf(
              bill: _bill!,
              profile: profile,
            ),
            canChangeOrientation: false,
            canChangePageFormat: false,
            canDebug: false,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_bill == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Invoice Not Found')),
        body: const Center(child: Text('This invoice could not be loaded.')),
      );
    }

    final bill = _bill!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(bill.invoiceNo),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Preview PDF',
            onPressed: _previewPdf,
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined),
            tooltip: 'Print / Download PDF',
            onPressed: _printOrDownloadPdf,
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Invoice',
            onPressed: _sharePdf,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Status Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AppColors.outline),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bill.invoiceNo,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppConstants.invoiceDateTimeFormat.format(bill.date),
                                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: bill.paymentStatus == 'Paid'
                                    ? AppColors.success.withOpacity(0.12)
                                    : bill.paymentStatus == 'Unpaid'
                                        ? AppColors.error.withOpacity(0.12)
                                        : AppColors.warning.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                bill.paymentStatus.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: bill.paymentStatus == 'Paid'
                                      ? AppColors.success
                                      : bill.paymentStatus == 'Unpaid'
                                          ? AppColors.error
                                          : AppColors.warning,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24, color: AppColors.divider),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Supply Type:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: bill.isInterState ? AppColors.igstColor.withOpacity(0.12) : AppColors.cgstColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                bill.isInterState ? 'Inter-State (IGST)' : 'Intra-State (CGST + SGST)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: bill.isInterState ? AppColors.igstColor : AppColors.cgstColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Customer Details Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AppColors.outline),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bill To Customer',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bill.partyName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        if (bill.partyAddress.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            bill.partyAddress,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          'State: ${bill.partyState} | Mobile: ${bill.partyMobile}',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        if (bill.partyGstin != null && bill.partyGstin!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'GSTIN: ${bill.partyGstin}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Line Items
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AppColors.outline),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Itemized Products (${bill.items.length})',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: bill.items.length,
                          itemBuilder: (context, index) {
                            final item = bill.items[index];
                            return BillItemTile(
                              item: item,
                              isInterState: bill.isInterState,
                              isEditable: false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // GST Totals Summary
                GstSummaryCard(
                  subtotal: bill.subtotal,
                  totalCgst: bill.totalCgst,
                  totalSgst: bill.totalSgst,
                  totalIgst: bill.totalIgst,
                  totalTax: bill.totalTax,
                  grandTotal: bill.grandTotal,
                  isInterState: bill.isInterState,
                ),

                if (bill.notes != null && bill.notes!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: AppColors.outline),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Remarks / Notes',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bill.notes!,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Action Buttons: Share & Print
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _previewPdf,
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('PREVIEW PDF'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _sharePdf,
                        icon: const Icon(Icons.share),
                        label: const Text('SHARE PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
