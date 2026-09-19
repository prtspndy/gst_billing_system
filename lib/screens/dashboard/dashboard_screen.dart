import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bill_provider.dart';
import '../../providers/business_profile_provider.dart';
import '../../providers/item_provider.dart';
import '../../providers/party_provider.dart';
import '../../utils/constants.dart';
import '../bill/bill_detail_screen.dart';
import '../bill/bill_list_screen.dart';
import '../bill/create_bill_screen.dart';
import '../item/item_list_screen.dart';
import '../party/party_list_screen.dart';
import '../settings/business_profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAllData();
    });
  }

  Future<void> _refreshAllData() async {
    await Future.wait([
      Provider.of<BillProvider>(context, listen: false).loadBills(),
      Provider.of<PartyProvider>(context, listen: false).loadParties(),
      Provider.of<ItemProvider>(context, listen: false).loadItems(),
      Provider.of<BusinessProfileProvider>(context, listen: false).loadProfile(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final billProvider = Provider.of<BillProvider>(context);
    final profileProvider = Provider.of<BusinessProfileProvider>(context);
    final stats = billProvider.dashboardStats;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profileProvider.profile.shopName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '${profileProvider.profile.state} (GSTIN: ${profileProvider.profile.gstin})',
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Business Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BusinessProfileScreen()),
              );
            },
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
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Create Bill'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAllData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'GST Billing System',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Manage customers, stock & create GST invoices with automatic tax calculation.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CreateBillScreen()),
                            );
                          },
                          icon: const Icon(Icons.receipt, size: 18),
                          label: const Text('New Bill'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stats Grid
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _statCard(
                                  context,
                                  title: "Today's Sales",
                                  value: AppConstants.formatCurrency(stats.totalSalesToday),
                                  subValue: '${stats.totalBillsToday} bills today',
                                  icon: Icons.today,
                                  iconColor: AppColors.primary,
                                  bgColor: AppColors.primaryLight.withValues(alpha: 0.4),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _statCard(
                                  context,
                                  title: "This Month Sales",
                                  value: AppConstants.formatCurrency(stats.totalSalesThisMonth),
                                  subValue: '${stats.totalBillsThisMonth} bills this month',
                                  icon: Icons.calendar_month,
                                  iconColor: AppColors.secondary,
                                  bgColor: AppColors.secondaryLight.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _statCard(
                                  context,
                                  title: "Tax Collected (Today)",
                                  value: AppConstants.formatCurrency(stats.totalTaxToday),
                                  subValue: 'CGST / SGST / IGST',
                                  icon: Icons.account_balance,
                                  iconColor: AppColors.cgstColor,
                                  bgColor: AppColors.primaryLight.withValues(alpha: 0.2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _statCard(
                                  context,
                                  title: "Tax Collected (Month)",
                                  value: AppConstants.formatCurrency(stats.totalTaxThisMonth),
                                  subValue: 'Total GST for ${AppConstants.monthYearFormat.format(DateTime.now())}',
                                  icon: Icons.pie_chart_outline,
                                  iconColor: AppColors.igstColor,
                                  bgColor: AppColors.secondaryLight.withValues(alpha: 0.2),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Quick Action Buttons
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _actionButton(
                        context,
                        title: 'Parties',
                        subtitle: '${stats.totalPartiesCount} Saved',
                        icon: Icons.people_outline,
                        color: AppColors.primary,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PartyListScreen()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _actionButton(
                        context,
                        title: 'Products',
                        subtitle: '${stats.totalItemsCount} Items',
                        icon: Icons.inventory_2_outlined,
                        color: AppColors.secondary,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ItemListScreen()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _actionButton(
                        context,
                        title: 'History',
                        subtitle: 'All Bills',
                        icon: Icons.receipt_long_outlined,
                        color: AppColors.warning,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BillListScreen()),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Recent Bills Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Invoices',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BillListScreen()),
                          );
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (billProvider.bills.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outline),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.receipt_outlined, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            const Text(
                              'No bills generated yet',
                              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CreateBillScreen()),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Create First Bill'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: billProvider.bills.length > 5 ? 5 : billProvider.bills.length,
                      itemBuilder: (context, index) {
                        final bill = billProvider.bills[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: AppColors.outline),
                          ),
                          color: Colors.white,
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BillDetailScreen(billId: bill.id),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primaryLight,
                              child: Text(
                                bill.invoiceNo.split('-').last,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            title: Text(
                              bill.partyName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            subtitle: Text(
                              '${bill.invoiceNo} • ${AppConstants.invoiceDateFormat.format(bill.date)}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  AppConstants.formatCurrency(bill.grandTotal),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
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
                                      fontWeight: FontWeight.bold,
                                      color: bill.isInterState ? AppColors.igstColor : AppColors.cgstColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subValue,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subValue,
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withValues(alpha: 0.12),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
