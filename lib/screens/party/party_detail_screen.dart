import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_shadows.dart';
import '../../models/bill.dart';
import '../../models/party.dart';
import '../../providers/bill_provider.dart';
import '../../providers/party_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/status_badge.dart';
import '../bill/bill_detail_screen.dart';
import '../bill/create_bill_screen.dart';
import 'party_form_screen.dart';
import '../../widgets/common/glass_app_bar.dart';
import '../../widgets/common/glass_dialog.dart';

class PartyDetailScreen extends StatefulWidget {
  final String partyId;

  const PartyDetailScreen({super.key, required this.partyId});

  @override
  State<PartyDetailScreen> createState() => _PartyDetailScreenState();
}

class _PartyDetailScreenState extends State<PartyDetailScreen> {
  Party? _party;
  List<Bill> _partyBills = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final partyProvider = Provider.of<PartyProvider>(context, listen: false);
    final billProvider = Provider.of<BillProvider>(context, listen: false);

    _party = await partyProvider.getPartyById(widget.partyId);
    _partyBills = await billProvider.getBillsByParty(widget.partyId);

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _confirmDelete() {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => GlassAlertDialog(
        title: const Text('Delete Party?'),
        content: Text(
          'Are you sure you want to delete "${_party?.name}"? '
          'Existing bills for this customer will be preserved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final provider = Provider.of<PartyProvider>(context, listen: false);
              await provider.deleteParty(widget.partyId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Party deleted')),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Delete'),
          ),
        ],
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

    if (_party == null) {
      return Scaffold(
        appBar: const GlassAppBar(title: Text('Party Not Found')),
        body: const Center(child: Text('This party does not exist.')),
      );
    }

    final party = _party!;

    return Scaffold(
      appBar: GlassAppBar(
        title: Text(party.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Party',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PartyFormScreen(partyToEdit: party),
                ),
              );
              _loadData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Delete Party',
            onPressed: _confirmDelete,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Card
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorScheme.outline),
                      boxShadow: AppShadows.level1(isDark),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.7),
                              child: Text(
                                party.initials,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    party.name,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: colorScheme.secondaryContainer.withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      party.state,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 28, color: colorScheme.outlineVariant),
                        _infoRow(
                          context,
                          Icons.phone_outlined,
                          'Mobile',
                          party.mobile,
                        ),
                        const SizedBox(height: 12),
                        _infoRow(
                          context,
                          Icons.location_on_outlined,
                          'Address',
                          party.address,
                        ),
                        if (party.gstin != null && party.gstin!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _infoRow(
                            context,
                            Icons.badge_outlined,
                            'GSTIN',
                            party.gstin!,
                          ),
                        ],
                        if (party.email != null && party.email!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _infoRow(
                            context,
                            Icons.email_outlined,
                            'Email',
                            party.email!,
                          ),
                        ],
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms),

                  const SizedBox(height: 20),

                  // Quick Action to Create Bill
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateBillScreen(preselectedParty: party),
                        ),
                      );
                      _loadData();
                    },
                    icon: const Icon(Icons.receipt_long_rounded),
                    label: const Text('CREATE BILL FOR THIS CUSTOMER'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 300.ms),

                  const SizedBox(height: 24),

                  // Party Bill History Section
                  SectionHeader(
                    title: 'Bill History (${_partyBills.length})',
                  ),
                  const SizedBox(height: 8),

                  if (_partyBills.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colorScheme.outline),
                        boxShadow: AppShadows.level1(isDark),
                      ),
                      child: Center(
                        child: Text(
                          'No bills generated for this customer yet.',
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 150.ms)
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _partyBills.length,
                      itemBuilder: (context, index) {
                        final bill = _partyBills[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: colorScheme.outline),
                            boxShadow: AppShadows.level1(isDark),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BillDetailScreen(billId: bill.id),
                                ),
                              );
                            },
                            title: Text(
                              bill.invoiceNo,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              AppConstants.invoiceDateFormat.format(bill.date),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 12,
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                StatusBadge(status: bill.paymentStatus, fontSize: 9),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: (150 + index * 30).ms, duration: 250.ms);
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurface.withValues(alpha: 0.55)),
        const SizedBox(width: 10),
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
