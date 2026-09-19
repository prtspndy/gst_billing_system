import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/item.dart';
import '../../providers/item_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/search_field.dart';
import 'item_form_screen.dart';

class ItemListScreen extends StatefulWidget {
  final bool isSelectionMode;

  const ItemListScreen({super.key, this.isSelectionMode = false});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDelete(Item item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item?'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final provider = Provider.of<ItemProvider>(context, listen: false);
              await provider.deleteItem(item.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item deleted')),
                );
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
    final itemProvider = Provider.of<ItemProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.isSelectionMode ? 'Select Product' : 'Products & Items'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newItem = await Navigator.push<Item>(
            context,
            MaterialPageRoute(builder: (context) => const ItemFormScreen()),
          );
          if (mounted && widget.isSelectionMode && newItem != null) {
            Navigator.pop(context, newItem);
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchField(
              controller: _searchController,
              hintText: 'Search products by name or HSN code...',
              onChanged: (val) => itemProvider.searchItems(val),
              onClear: () => itemProvider.searchItems(''),
            ),
          ),
          Expanded(
            child: itemProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : itemProvider.items.isEmpty
                    ? EmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: itemProvider.searchQuery.isNotEmpty
                            ? 'No items found'
                            : 'No items added yet',
                        description: itemProvider.searchQuery.isNotEmpty
                            ? 'Try searching with another keyword.'
                            : 'Add products to quickly include them in GST bills without retyping.',
                        buttonText: itemProvider.searchQuery.isEmpty ? 'Add Item' : null,
                        onButtonPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ItemFormScreen()),
                          );
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: () => itemProvider.loadItems(),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                          itemCount: itemProvider.items.length,
                          itemBuilder: (context, index) {
                            final item = itemProvider.items[index];
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
                                  if (widget.isSelectionMode) {
                                    Navigator.pop(context, item);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ItemFormScreen(itemToEdit: item),
                                      ),
                                    );
                                  }
                                },
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.shopping_bag_outlined,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        if (item.hsnCode != null && item.hsnCode!.isNotEmpty) ...[
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              'HSN: ${item.hsnCode}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                        ],
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondaryLight,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            'GST: ${item.gstPercent.toStringAsFixed(0)}%',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.secondaryDark,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: widget.isSelectionMode
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            AppConstants.formatCurrency(item.unitPrice),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryDark,
                                            ),
                                          ),
                                          const Text(
                                            'Select',
                                            style: TextStyle(fontSize: 11, color: AppColors.primary),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            AppConstants.formatCurrency(item.unitPrice),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryDark,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          PopupMenuButton<String>(
                                            icon: const Icon(Icons.more_vert, size: 20, color: AppColors.textMuted),
                                            onSelected: (action) {
                                              if (action == 'edit') {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ItemFormScreen(itemToEdit: item),
                                                  ),
                                                );
                                              } else if (action == 'delete') {
                                                _confirmDelete(item);
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                value: 'edit',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit_outlined, size: 18),
                                                    SizedBox(width: 8),
                                                    Text('Edit'),
                                                  ],
                                                ),
                                              ),
                                              const PopupMenuItem(
                                                value: 'delete',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                                                    SizedBox(width: 8),
                                                    Text('Delete', style: TextStyle(color: AppColors.error)),
                                                  ],
                                                ),
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
