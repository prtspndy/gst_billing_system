import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../providers/bill_provider.dart';
import '../../providers/business_profile_provider.dart';
import '../../providers/item_provider.dart';
import '../../providers/party_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/common/tax_type_chip.dart';
import '../../widgets/common/glass_app_bar.dart';
import '../../services/database_service.dart';
import '../bill/bill_detail_screen.dart';
import '../bill/bill_list_screen.dart';
import '../bill/create_bill_screen.dart';
import '../item/item_list_screen.dart';
import '../party/party_list_screen.dart';
import '../settings/business_profile_screen.dart';
import '../setup/shop_setup_screen.dart';

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

  Future<void> _openBusinessProfileOrShopSetup() async {
    try {
      final isSetupDone = await DatabaseService.instance.isShopSetupCompleted();
      if (!mounted) return;
      if (!isSetupDone) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ShopSetupScreen(),
          ),
        );
        return;
      }
    } catch (_) {
      // Fallback for tests / offline
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BusinessProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final taxColors = context.taxColors;

    final billProvider = Provider.of<BillProvider>(context);
    final profileProvider = Provider.of<BusinessProfileProvider>(context);
    final stats = billProvider.dashboardStats;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        flexibleSpace: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _openBusinessProfileOrShopSetup,
          child: const GlassFlexibleSpace(opacity: 0.65, blurSigma: 16),
        ),
        leadingWidth: 58,
        titleSpacing: 10,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _openBusinessProfileOrShopSetup,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                AppConstants.appLogo,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _openBusinessProfileOrShopSetup,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profileProvider.profile.shopName.isNotEmpty
                    ? profileProvider.profile.shopName
                    : AppConstants.appName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (profileProvider.profile.state.isNotEmpty)
                Text(
                  '${profileProvider.profile.state}${profileProvider.profile.gstin.isNotEmpty ? " • ${profileProvider.profile.gstin}" : ""}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront_outlined),
            tooltip: 'Business Profile',
            onPressed: _openBusinessProfileOrShopSetup,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAllData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            16.0,
            MediaQuery.paddingOf(context).top + kToolbarHeight + 12.0,
            16.0,
            100.0,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome Banner
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF161B26), const Color(0xFF222D42)]
                            : [const Color(0xFF3F51B5), const Color(0xFF303F9F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: isDark ? Border.all(color: const Color(0xFF232B3E)) : null,
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.35)
                              : const Color(0xFF3F51B5).withValues(alpha: 0.25),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to GST Billing 👋',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Fast, Accurate & GST Compliant',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Automatic CGST, SGST, IGST calculations & professional PDF invoices.',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
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
                              MaterialPageRoute(
                                builder: (context) => const CreateBillScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('New Bill'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF303F9F),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),

                  const SizedBox(height: 20),

                  // Stats Grid (Responsive 2x2 or 4x1)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 700;
                      if (isWide) {
                        return Row(
                          children: [
                            Expanded(
                              child: _statCard(
                                context,
                                title: "Today's Sales",
                                value: AppConstants.formatCurrency(stats.totalSalesToday),
                                subValue: '${stats.totalBillsToday} bills today',
                                icon: Icons.today_rounded,
                                iconColor: colorScheme.primary,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _statCard(
                                context,
                                title: "This Month",
                                value: AppConstants.formatCurrency(stats.totalSalesThisMonth),
                                subValue: '${stats.totalBillsThisMonth} bills this month',
                                icon: Icons.calendar_month_rounded,
                                iconColor: colorScheme.secondary,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _statCard(
                                context,
                                title: "Tax Today",
                                value: AppConstants.formatCurrency(stats.totalTaxToday),
                                subValue: 'CGST + SGST / IGST',
                                icon: Icons.account_balance_rounded,
                                iconColor: taxColors.cgst,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _statCard(
                                context,
                                title: "Tax Month",
                                value: AppConstants.formatCurrency(stats.totalTaxThisMonth),
                                subValue: AppConstants.monthYearFormat.format(DateTime.now()),
                                icon: Icons.pie_chart_rounded,
                                iconColor: taxColors.igst,
                                isDark: isDark,
                              ),
                            ),
                          ],
                        );
                      }

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
                                  icon: Icons.today_rounded,
                                  iconColor: colorScheme.primary,
                                  isDark: isDark,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _statCard(
                                  context,
                                  title: "This Month",
                                  value: AppConstants.formatCurrency(stats.totalSalesThisMonth),
                                  subValue: '${stats.totalBillsThisMonth} bills this month',
                                  icon: Icons.calendar_month_rounded,
                                  iconColor: colorScheme.secondary,
                                  isDark: isDark,
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
                                  title: "Tax Today",
                                  value: AppConstants.formatCurrency(stats.totalTaxToday),
                                  subValue: 'CGST + SGST / IGST',
                                  icon: Icons.account_balance_rounded,
                                  iconColor: taxColors.cgst,
                                  isDark: isDark,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _statCard(
                                  context,
                                  title: "Tax Month",
                                  value: AppConstants.formatCurrency(stats.totalTaxThisMonth),
                                  subValue: AppConstants.monthYearFormat.format(DateTime.now()),
                                  icon: Icons.pie_chart_rounded,
                                  iconColor: taxColors.igst,
                                  isDark: isDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ).animate().fadeIn(delay: 100.ms, duration: 350.ms),

                  const SizedBox(height: 24),

                  // Quick Actions
                  SectionHeader(
                    title: 'Quick Actions',
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _actionButton(
                        context,
                        title: 'Parties',
                        subtitle: '${stats.totalPartiesCount} Saved',
                        icon: Icons.people_alt_rounded,
                        color: colorScheme.primary,
                        isDark: isDark,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PartyListScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _actionButton(
                        context,
                        title: 'Products',
                        subtitle: '${stats.totalItemsCount} Items',
                        icon: Icons.inventory_2_rounded,
                        color: colorScheme.secondary,
                        isDark: isDark,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ItemListScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _actionButton(
                        context,
                        title: 'History',
                        subtitle: 'All Bills',
                        icon: Icons.receipt_long_rounded,
                        color: taxColors.partial,
                        isDark: isDark,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BillListScreen(),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 150.ms, duration: 350.ms),

                  const SizedBox(height: 24),

                  // Recent Bills Section
                  SectionHeader(
                    title: 'Recent Invoices',
                    actionLabel: 'View All',
                    actionIcon: Icons.arrow_forward_rounded,
                    onAction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BillListScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),

                  if (billProvider.bills.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colorScheme.outline),
                        boxShadow: AppShadows.level1(isDark),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.receipt_outlined,
                                size: 40,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No bills generated yet',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Create your first GST invoice in seconds.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CreateBillScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add_rounded, size: 18),
                              label: const Text('Create First Bill'),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms)
                  else
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: billProvider.bills.length > 5
                          ? 5
                          : billProvider.bills.length,
                      itemBuilder: (context, index) {
                        final bill = billProvider.bills[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: colorScheme.outline),
                            boxShadow: AppShadows.level1(isDark),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BillDetailScreen(billId: bill.id),
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
                                child: Text(
                                  bill.invoiceNo.split('-').last,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              bill.partyName,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              '${bill.invoiceNo} • ${AppConstants.invoiceDateFormat.format(bill.date)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                                color: colorScheme.onSurface.withValues(alpha: 0.55),
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  AppConstants.formatCurrency(bill.grandTotal),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TaxTypeChip(
                                      isInterState: bill.isInterState,
                                      isCompact: true,
                                    ),
                                    const SizedBox(width: 4),
                                    StatusBadge(
                                      status: bill.paymentStatus,
                                      fontSize: 9,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: (200 + index * 40).ms, duration: 300.ms)
                            .slideX(begin: 0.05, end: 0);
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
    required bool isDark,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline),
        boxShadow: AppShadows.level1(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subValue,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            boxShadow: AppShadows.level1(isDark),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(icon, size: 20, color: color),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
