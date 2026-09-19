import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_shadows.dart';
import '../../models/bill.dart';
import '../../providers/bill_provider.dart';
import '../../providers/business_profile_provider.dart';
import '../../services/pdf_service.dart';
import '../../utils/constants.dart';
import '../../widgets/bill_item_tile.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/common/tax_type_chip.dart';
import '../../widgets/gst_summary_card.dart';
import '../../widgets/common/glass_app_bar.dart';

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
          appBar: GlassAppBar(
            title: Text('PDF Preview - ${_bill!.invoiceNo}'),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_bill == null) {
      return const Scaffold(
        appBar: GlassAppBar(title: Text('Invoice Not Found')),
        body: Center(child: Text('This invoice could not be loaded.')),
      );
    }

    final bill = _bill!;

    return Scaffold(
      appBar: GlassAppBar(
        title: Text(bill.invoiceNo),
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
          const SizedBox(width: 8),
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
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.outline),
                    boxShadow: AppShadows.level1(isDark),
                  ),
                  padding: const EdgeInsets.all(18.0),
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
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppConstants.invoiceDateTimeFormat.format(bill.date),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  color: colorScheme.onSurface.withValues(alpha: 0.55),
                                ),
                              ),
                            ],
                          ),
                          StatusBadge(status: bill.paymentStatus),
                        ],
                      ),
                      Divider(height: 24, color: colorScheme.outlineVariant),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Supply Type:',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                              color: colorScheme.onSurface.withValues(alpha: 0.65),
                            ),
                          ),
                          TaxTypeChip(isInterState: bill.isInterState),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Customer Details Card
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.outline),
                    boxShadow: AppShadows.level1(isDark),
                  ),
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bill To Customer',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        bill.partyName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      if (bill.partyAddress.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          bill.partyAddress,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        'State: ${bill.partyState} | Mobile: ${bill.partyMobile}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      if (bill.partyGstin != null && bill.partyGstin!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'GSTIN: ${bill.partyGstin}',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Line Items
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.outline),
                    boxShadow: AppShadows.level1(isDark),
                  ),
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Itemized Products (${bill.items.length})',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
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
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.outline),
                      boxShadow: AppShadows.level1(isDark),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Remarks / Notes',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bill.notes!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
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
                        icon: const Icon(Icons.picture_as_pdf_outlined),
                        label: const Text('PREVIEW PDF'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
                        icon: const Icon(Icons.share_outlined),
                        label: const Text('SHARE PDF'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
