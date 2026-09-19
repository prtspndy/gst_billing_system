import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/party.dart';
import '../../providers/party_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/search_field.dart';
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
    final partyProvider = Provider.of<PartyProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.isSelectionMode ? 'Select Customer' : 'Parties (Customers)'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newParty = await Navigator.push<Party>(
            context,
            MaterialPageRoute(builder: (context) => const PartyFormScreen()),
          );
          if (mounted && widget.isSelectionMode && newParty != null) {
            Navigator.pop(context, newParty);
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: const Text('Add Party'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchField(
              controller: _searchController,
              hintText: 'Search by party name, mobile, GSTIN...',
              onChanged: (val) => partyProvider.searchParties(val),
              onClear: () => partyProvider.searchParties(''),
            ),
          ),
          Expanded(
            child: partyProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : partyProvider.parties.isEmpty
                    ? EmptyState(
                        icon: Icons.people_outline,
                        title: partyProvider.searchQuery.isNotEmpty
                            ? 'No parties found'
                            : 'No parties added yet',
                        description: partyProvider.searchQuery.isNotEmpty
                            ? 'Try searching with another keyword or name.'
                            : 'Add your first customer to get started with GST billing.',
                        buttonText: partyProvider.searchQuery.isEmpty ? 'Add Party' : null,
                        onButtonPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PartyFormScreen()),
                          );
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: () => partyProvider.loadParties(),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                          itemCount: partyProvider.parties.length,
                          itemBuilder: (context, index) {
                            final party = partyProvider.parties[index];
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
                                  radius: 24,
                                  backgroundColor: AppColors.primaryLight,
                                  child: Text(
                                    party.initials,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  party.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone, size: 13, color: AppColors.textMuted),
                                        const SizedBox(width: 4),
                                        Text(
                                          party.mobile,
                                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                        ),
                                        const SizedBox(width: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondaryLight,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            party.state,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.secondaryDark,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (party.gstin != null && party.gstin!.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        'GSTIN: ${party.gstin}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontFamily: 'monospace',
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right,
                                  color: AppColors.textMuted,
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
