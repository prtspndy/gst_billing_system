import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bill_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/search_field.dart';
import 'bill_detail_screen.dart';
import 'create_bill_screen.dart';

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
    final billProvider = Provider.of<BillProvider>(context);

    final hasActiveDateFilter = billProvider.startDate != null || billProvider.endDate != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Invoices & Bill History'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Icons.date_range,
              color: hasActiveDateFilter ? Colors.amberAccent : Colors.white,
            ),
            tooltip: 'Filter by Date Range',
            onPressed: _pickDateRange,
          ),
          if (hasActiveDateFilter)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              tooltip: 'Clear Date Filter',
              onPressed: () => billProvider.setDateRange(null, null),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateBillScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Create Bill'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.event, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              '${AppConstants.invoiceDateFormat.format(billProvider.startDate!)} - ${AppConstants.invoiceDateFormat.format(billProvider.endDate!)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => billProvider.setDateRange(null, null),
                              child: const Icon(Icons.close, size: 14, color: AppColors.primary),
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
          Expanded(
            child: billProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : billProvider.bills.isEmpty
                    ? EmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: billProvider.searchQuery.isNotEmpty || hasActiveDateFilter
                            ? 'No invoices found'
                            : 'No bills generated yet',
                        description: billProvider.searchQuery.isNotEmpty || hasActiveDateFilter
                            ? 'Try adjusting your search query or date range filter.'
                            : 'Create your first GST invoice using the button below.',
                        buttonText: (billProvider.searchQuery.isEmpty && !hasActiveDateFilter)
                            ? 'Create Invoice'
                            : null,
                        onButtonPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CreateBillScreen()),
                          );
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: () => billProvider.loadBills(),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                          itemCount: billProvider.bills.length,
                          itemBuilder: (context, index) {
                            final bill = billProvider.bills[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: const BorderSide(color: AppColors.outline),
                              ),
                              color: Colors.white,
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
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: bill.isInterState
                                        ? AppColors.igstColor.withOpacity(0.12)
                                        : AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.receipt,
                                      color: bill.isInterState
                                          ? AppColors.igstColor
                                          : AppColors.primary,
                                    ),
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      bill.invoiceNo,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      AppConstants.formatCurrency(bill.grandTotal),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      bill.partyName,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppConstants.invoiceDateFormat.format(bill.date),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: bill.isInterState
                                                    ? AppColors.igstColor.withOpacity(0.1)
                                                    : AppColors.cgstColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                bill.isInterState ? 'IGST' : 'CGST+SGST',
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w600,
                                                  color: bill.isInterState
                                                      ? AppColors.igstColor
                                                      : AppColors.cgstColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: AppColors.success.withOpacity(0.12),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                bill.paymentStatus,
                                                style: const TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.success,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
