import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_shadows.dart';
import '../../models/party.dart';
import '../../providers/party_provider.dart';
import '../../widgets/common/shimmer_loading.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/search_field.dart';
import '../../widgets/common/glass_app_bar.dart';
import '../../widgets/common/glass_fab.dart';
import 'party_detail_screen.dart';
import 'party_form_screen.dart';

class PartyListScreen extends StatefulWidget {
  final bool isSelectionMode;

  const PartyListScreen({super.key, this.isSelectionMode = false});

  @override
  State<PartyListScreen> createState() => _PartyListScreenState();
}

class _PartyListScreenState extends State<PartyListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final partyProvider = Provider.of<PartyProvider>(context);

    return Scaffold(
      appBar: GlassAppBar(
        title: Text(widget.isSelectionMode ? 'Select Customer' : 'Parties (Customers)'),
      ),
      floatingActionButton: widget.isSelectionMode
          ? GlassFloatingActionButton.extended(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final newParty = await navigator.push<Party>(
                  MaterialPageRoute(builder: (context) => const PartyFormScreen()),
                );
                if (!mounted) return;
                if (widget.isSelectionMode && newParty != null) {
                  navigator.pop(newParty);
                }
              },
              icon: const Icon(Icons.person_add_rounded),
              label: const Text('Add Party'),
            ).animate().scale(duration: 350.ms, curve: Curves.easeOutBack)
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: CustomSearchField(
              controller: _searchController,
              hintText: 'Search by party name, mobile, GSTIN...',
              onChanged: (val) => partyProvider.searchParties(val),
              onClear: () => partyProvider.searchParties(''),
            ),
          ),
          if (!partyProvider.isLoading && partyProvider.parties.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${partyProvider.parties.length} ${partyProvider.parties.length == 1 ? "Customer" : "Customers"}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          Expanded(
            child: partyProvider.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ShimmerCardLoading(count: 6),
                  )
                : partyProvider.parties.isEmpty
                    ? EmptyState(
                        icon: Icons.people_outline_rounded,
                        title: partyProvider.searchQuery.isNotEmpty
                            ? 'No parties found'
                            : 'No parties added yet',
                        description: partyProvider.searchQuery.isNotEmpty
                            ? 'Try searching with another keyword or name.'
                            : 'Add your first customer to get started with GST billing.',
                      )
                    : RefreshIndicator(
                        onRefresh: () => partyProvider.loadParties(),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 100),
                          itemCount: partyProvider.parties.length,
                          itemBuilder: (context, index) {
                            final party = partyProvider.parties[index];
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
                                  vertical: 6,
                                ),
                                onTap: () {
                                  if (widget.isSelectionMode) {
                                    Navigator.pop(context, party);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PartyDetailScreen(partyId: party.id),
                                      ),
                                    );
                                  }
                                },
                                leading: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.7),
                                  child: Text(
                                    party.initials,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  party.name,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.phone_rounded,
                                              size: 13,
                                              color: colorScheme.onSurface.withValues(alpha: 0.45),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              party.mobile,
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: colorScheme.onSurface.withValues(alpha: 0.7),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            party.state,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.secondary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (party.gstin != null && party.gstin!.isNotEmpty) ...[
                                      const SizedBox(height: 3),
                                      Text(
                                        'GSTIN: ${party.gstin}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontFamily: 'monospace',
                                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                trailing: Icon(
                                  Icons.chevron_right_rounded,
                                  color: colorScheme.onSurface.withValues(alpha: 0.4),
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
