import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_shadows.dart';
import '../../providers/bill_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/common/shimmer_loading.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/common/tax_type_chip.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/search_field.dart';
import '../../widgets/common/glass_app_bar.dart';
import 'bill_detail_screen.dart';

class BillListScreen extends StatefulWidget {
  const BillListScreen({super.key});

  @override
  State<BillListScreen> createState() => _BillListScreenState();
}

class _BillListScreenState extends State<BillListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final billProvider = Provider.of<BillProvider>(context, listen: false);
    final initialDateRange = DateTimeRange(
      start: billProvider.startDate ?? DateTime.now().subtract(const Duration(days: 30)),
      end: billProvider.endDate ?? DateTime.now(),
    );

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: initialDateRange,
    );

    if (picked != null) {
      billProvider.setDateRange(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final billProvider = Provider.of<BillProvider>(context);

    final hasActiveDateFilter = billProvider.startDate != null || billProvider.endDate != null;

    return Scaffold(
      appBar: GlassAppBar(
        title: const Text('Invoices & Bill History'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.date_range_rounded,
              color: hasActiveDateFilter ? colorScheme.primary : null,
            ),
            tooltip: 'Filter by Date Range',
            onPressed: _pickDateRange,
          ),
          if (hasActiveDateFilter)
            IconButton(
              icon: const Icon(Icons.filter_alt_off_rounded),
              tooltip: 'Clear Date Filter',
              onPressed: () => billProvider.setDateRange(null, null),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                CustomSearchField(
                  controller: _searchController,
                  hintText: 'Search by customer name, invoice no...',
                  onChanged: (val) => billProvider.searchBills(val),
                  onClear: () => billProvider.searchBills(''),
                ),
                if (hasActiveDateFilter) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.event_rounded, size: 14, color: colorScheme.primary),
                            const SizedBox(width: 4),
                            Text(
                              '${AppConstants.invoiceDateFormat.format(billProvider.startDate!)} - ${AppConstants.invoiceDateFormat.format(billProvider.endDate!)}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => billProvider.setDateRange(null, null),
                              child: Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (!billProvider.isLoading && billProvider.bills.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${billProvider.bills.length} ${billProvider.bills.length == 1 ? "Invoice" : "Invoices"}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          Expanded(
            child: billProvider.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ShimmerCardLoading(count: 6),
                  )
                : billProvider.bills.isEmpty
                    ? EmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: billProvider.searchQuery.isNotEmpty || hasActiveDateFilter
                            ? 'No invoices found'
                            : 'No bills generated yet',
                        description: billProvider.searchQuery.isNotEmpty || hasActiveDateFilter
                            ? 'Try adjusting your search query or date range filter.'
                            : 'Create your first GST invoice using the button below.',
                      )
                    : RefreshIndicator(
                        onRefresh: () => billProvider.loadBills(),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 100),
                          itemCount: billProvider.bills.length,
                          itemBuilder: (context, index) {
                            final bill = billProvider.bills[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: colorScheme.outline),
                                boxShadow: AppShadows.level1(isDark),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BillDetailScreen(billId: bill.id),
                                    ),
                                  );
                                },
                                leading: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.receipt_rounded,
                                      color: colorScheme.primary,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        bill.invoiceNo,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        AppConstants.formatCurrency(bill.grandTotal),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 3),
                                    Text(
                                      bill.partyName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Wrap(
                                      alignment: WrapAlignment.spaceBetween,
                                      runSpacing: 4,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          AppConstants.invoiceDateFormat.format(bill.date),
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            fontSize: 11,
                                            color: colorScheme.onSurface.withValues(alpha: 0.55),
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TaxTypeChip(
                                              isInterState: bill.isInterState,
                                              isCompact: true,
                                            ),
                                            const SizedBox(width: 6),
                                            StatusBadge(
                                              status: bill.paymentStatus,
                                              fontSize: 9,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(delay: (index * 30).ms, duration: 250.ms)
                                .slideX(begin: 0.04, end: 0);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
