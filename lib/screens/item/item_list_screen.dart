import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_shadows.dart';
import '../../models/item.dart';
import '../../providers/item_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/common/shimmer_loading.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/search_field.dart';
import '../../widgets/common/glass_app_bar.dart';
import '../../widgets/common/glass_dialog.dart';
import '../../widgets/common/glass_fab.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => GlassAlertDialog(
        title: const Text('Delete Item?'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final itemProvider = Provider.of<ItemProvider>(context);

    return Scaffold(
      appBar: GlassAppBar(
        title: Text(widget.isSelectionMode ? 'Select Product' : 'Products & Items'),
      ),
      floatingActionButton: widget.isSelectionMode
          ? GlassFloatingActionButton.extended(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final newItem = await navigator.push<Item>(
                  MaterialPageRoute(builder: (context) => const ItemFormScreen()),
                );
                if (!mounted) return;
                if (widget.isSelectionMode && newItem != null) {
                  navigator.pop(newItem);
                }
              },
              icon: const Icon(Icons.add_box_rounded),
              label: const Text('Add Product'),
            ).animate().scale(duration: 350.ms, curve: Curves.easeOutBack)
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: CustomSearchField(
              controller: _searchController,
              hintText: 'Search products by name or HSN code...',
              onChanged: (val) => itemProvider.searchItems(val),
              onClear: () => itemProvider.searchItems(''),
            ),
          ),
          if (!itemProvider.isLoading && itemProvider.items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${itemProvider.items.length} ${itemProvider.items.length == 1 ? "Product" : "Products"}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          Expanded(
            child: itemProvider.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ShimmerCardLoading(count: 6),
                  )
                : itemProvider.items.isEmpty
                    ? EmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: itemProvider.searchQuery.isNotEmpty
                            ? 'No items found'
                            : 'No items added yet',
                        description: itemProvider.searchQuery.isNotEmpty
                            ? 'Try searching with another keyword.'
                            : 'Add products to quickly include them in GST bills without retyping.',
                      )
                    : RefreshIndicator(
                        onRefresh: () => itemProvider.loadItems(),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 100),
                          itemCount: itemProvider.items.length,
                          itemBuilder: (context, index) {
                            final item = itemProvider.items[index];
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
                                  horizontal: 12,
                                  vertical: 6,
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
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.inventory_2_rounded,
                                      color: colorScheme.primary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  item.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 4,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        if (item.hsnCode != null && item.hsnCode!.isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: colorScheme.surfaceContainerHighest,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              'HSN: ${item.hsnCode}',
                                              style: TextStyle(
                                                fontSize: 10.5,
                                                color: colorScheme.onSurface.withValues(alpha: 0.7),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: colorScheme.secondaryContainer.withValues(alpha: 0.6),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            'GST: ${AppConstants.formatGstRate(item.gstPercent)}',
                                            style: TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.secondary,
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
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              AppConstants.formatCurrency(item.unitPrice),
                                              style: TextStyle(
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w800,
                                                color: colorScheme.primary,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Select',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              AppConstants.formatCurrency(item.unitPrice),
                                              style: TextStyle(
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w800,
                                                color: colorScheme.primary,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          PopupMenuButton<String>(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: Icon(
                                              Icons.more_vert_rounded,
                                              size: 20,
                                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                                            ),
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
                                              PopupMenuItem(
                                                value: 'delete',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.delete_outline, size: 18, color: colorScheme.error),
                                                    const SizedBox(width: 8),
                                                    Text('Delete', style: TextStyle(color: colorScheme.error)),
                                                  ],
                                                ),
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
