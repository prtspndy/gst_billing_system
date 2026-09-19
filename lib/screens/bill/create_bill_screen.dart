import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_shadows.dart';
import '../../models/bill.dart';
import '../../models/bill_item.dart';
import '../../models/item.dart';
import '../../models/party.dart';
import '../../providers/bill_provider.dart';
import '../../providers/business_profile_provider.dart';
import '../../services/gst_calculator.dart';
import '../../utils/constants.dart';
import '../../widgets/bill_item_tile.dart';
import '../../widgets/common/tax_type_chip.dart';
import '../../widgets/gst_summary_card.dart';
import '../item/item_list_screen.dart';
import '../party/party_form_screen.dart';
import '../party/party_list_screen.dart';
import 'bill_detail_screen.dart';
import '../../widgets/common/glass_app_bar.dart';
import '../../widgets/common/glass_dialog.dart';

class CreateBillScreen extends StatefulWidget {
  final Party? preselectedParty;

  const CreateBillScreen({super.key, this.preselectedParty});

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  Party? _selectedParty;
  final List<BillItem> _billItems = [];
  String _invoiceNo = 'Loading...';
  final DateTime _invoiceDate = DateTime.now();
  String _paymentStatus = 'Paid';
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedParty = widget.preselectedParty;
    _fetchNextInvoiceNo();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _fetchNextInvoiceNo() async {
    final billProvider = Provider.of<BillProvider>(context, listen: false);
    final nextNo = await billProvider.getNextInvoiceNumber();
    if (mounted) {
      setState(() => _invoiceNo = nextNo);
    }
  }

  String get _shopState {
    final profileProvider = Provider.of<BusinessProfileProvider>(context, listen: false);
    return profileProvider.profile.state;
  }

  bool get _isInterState {
    if (_selectedParty == null) return false;
    return _selectedParty!.state.trim().toLowerCase() != _shopState.trim().toLowerCase();
  }

  void _recalculateAllItems() {
    if (_selectedParty == null) return;
    for (int i = 0; i < _billItems.length; i++) {
      final current = _billItems[i];
      final dummyItem = Item(
        id: current.itemId,
        name: current.name,
        hsnCode: current.hsnCode,
        unitPrice: current.rate,
        gstPercent: current.gstPercent,
      );
      _billItems[i] = GstCalculator.calculateLineItem(
        item: dummyItem,
        quantity: current.qty,
        rate: current.rate,
        partyState: _selectedParty!.state,
        shopState: _shopState,
        customGstPercent: current.gstPercent,
      );
    }
    setState(() {});
  }

  Future<void> _pickParty() async {
    final picked = await Navigator.push<Party>(
      context,
      MaterialPageRoute(
        builder: (context) => const PartyListScreen(isSelectionMode: true),
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedParty = picked;
      });
      _recalculateAllItems();
    }
  }

  Future<void> _quickAddParty() async {
    final newParty = await Navigator.push<Party>(
      context,
      MaterialPageRoute(
        builder: (context) => const PartyFormScreen(),
      ),
    );
    if (newParty != null && mounted) {
      setState(() {
        _selectedParty = newParty;
      });
      _recalculateAllItems();
    }
  }

  Future<void> _addItemFromInventory() async {
    if (_selectedParty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer/party first')),
      );
      return;
    }

    final selectedItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (context) => const ItemListScreen(isSelectionMode: true),
      ),
    );

    if (selectedItem != null && mounted) {
      _showQuantityDialog(selectedItem);
    }
  }

  void _showQuantityDialog(Item item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    int qty = 1;
    double rate = item.unitPrice;
    final qtyController = TextEditingController(text: '1');
    final rateController = TextEditingController(text: item.unitPrice.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return GlassAlertDialog(
            title: Text(item.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GST Rate: ${AppConstants.formatGstRate(item.gstPercent)}${item.hsnCode != null ? ' | HSN: ${item.hsnCode}' : ''}',
                  style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: rateController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Rate (₹)',
                    prefixText: '₹ ',
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null && parsed > 0) {
                      rate = parsed;
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Quantity: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline_rounded, color: colorScheme.primary),
                      onPressed: qty > 1
                          ? () {
                              setDialogState(() {
                                qty--;
                                qtyController.text = qty.toString();
                              });
                            }
                          : null,
                    ),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (val) {
                          final parsed = int.tryParse(val);
                          if (parsed != null && parsed > 0) {
                            qty = parsed;
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline_rounded, color: colorScheme.primary),
                      onPressed: () {
                        setDialogState(() {
                          qty++;
                          qtyController.text = qty.toString();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final lineItem = GstCalculator.calculateLineItem(
                    item: item,
                    quantity: qty,
                    rate: rate,
                    partyState: _selectedParty!.state,
                    shopState: _shopState,
                  );

                  setState(() {
                    _billItems.add(lineItem);
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Add to Bill'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onQuantityChanged(int index, int newQty) {
    if (_selectedParty == null) return;
    final current = _billItems[index];
    final dummyItem = Item(
      id: current.itemId,
      name: current.name,
      hsnCode: current.hsnCode,
      unitPrice: current.rate,
      gstPercent: current.gstPercent,
    );
    setState(() {
      _billItems[index] = GstCalculator.calculateLineItem(
        item: dummyItem,
        quantity: newQty,
        rate: current.rate,
        partyState: _selectedParty!.state,
        shopState: _shopState,
        customGstPercent: current.gstPercent,
      );
    });
  }

  void _removeItem(int index) {
    setState(() {
      _billItems.removeAt(index);
    });
  }

  Future<void> _saveAndGenerateBill() async {
    if (_selectedParty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer/party for this bill')),
      );
      return;
    }

    if (_billItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item to the bill')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final totals = GstCalculator.calculateBillTotals(
      items: _billItems,
      partyState: _selectedParty!.state,
      shopState: _shopState,
    );

    final bill = Bill(
      id: const Uuid().v4(),
      invoiceNo: _invoiceNo,
      date: _invoiceDate,
      partyId: _selectedParty!.id,
      partyName: _selectedParty!.name,
      partyMobile: _selectedParty!.mobile,
      partyAddress: _selectedParty!.address,
      partyState: _selectedParty!.state,
      partyGstin: _selectedParty!.gstin,
      items: _billItems,
      subtotal: totals.subtotal,
      totalCgst: totals.totalCgst,
      totalSgst: totals.totalSgst,
      totalIgst: totals.totalIgst,
      totalTax: totals.totalTax,
      grandTotal: totals.grandTotal,
      isInterState: totals.isInterState,
      paymentStatus: _paymentStatus,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
    );

    final billProvider = Provider.of<BillProvider>(context, listen: false);
    final success = await billProvider.createBill(bill);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bill generated successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BillDetailScreen(billId: bill.id),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to save bill. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final totals = _selectedParty != null
        ? GstCalculator.calculateBillTotals(
            items: _billItems,
            partyState: _selectedParty!.state,
            shopState: _shopState,
          )
        : null;

    return Scaffold(
      appBar: const GlassAppBar(
        title: Text('Create GST Bill'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Invoice Header Card
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.outline),
                    boxShadow: AppShadows.level1(isDark),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Invoice Number',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.55),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _invoiceNo,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Invoice Date',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.55),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppConstants.invoiceDateFormat.format(_invoiceDate),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Step 1: Party Selection
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '1. Customer / Bill To',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_selectedParty != null)
                            TextButton(
                              onPressed: _pickParty,
                              child: const Text('Change Party'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_selectedParty == null)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _pickParty,
                                icon: const Icon(Icons.people_outline_rounded),
                                label: const Text('Select Customer'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _quickAddParty,
                              icon: const Icon(Icons.person_add_rounded),
                              tooltip: 'Quick Add Party',
                              style: IconButton.styleFrom(
                                backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.6),
                                foregroundColor: colorScheme.primary,
                              ),
                            ),
                          ],
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorScheme.outlineVariant),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _selectedParty!.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  TaxTypeChip(isInterState: _isInterState),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'State: ${_selectedParty!.state} | Mobile: ${_selectedParty!.mobile}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                              if (_selectedParty!.gstin != null && _selectedParty!.gstin!.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  'GSTIN: ${_selectedParty!.gstin}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Step 2: Line Items
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '2. Bill Items (${_billItems.length})',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _addItemFromInventory,
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Add Product'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_billItems.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 28),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 44,
                                color: colorScheme.onSurface.withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No items added to bill yet.',
                                style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: _addItemFromInventory,
                                icon: const Icon(Icons.add_rounded),
                                label: const Text('Add Products from Inventory'),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _billItems.length,
                          itemBuilder: (context, index) {
                            final item = _billItems[index];
                            return BillItemTile(
                              item: item,
                              isInterState: _isInterState,
                              isEditable: true,
                              onQuantityChanged: (newQty) => _onQuantityChanged(index, newQty),
                              onRemove: () => _removeItem(index),
                            );
                          },
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Step 3: GST Summary & Totals
                if (totals != null) ...[
                  GstSummaryCard(
                    subtotal: totals.subtotal,
                    totalCgst: totals.totalCgst,
                    totalSgst: totals.totalSgst,
                    totalIgst: totals.totalIgst,
                    totalTax: totals.totalTax,
                    grandTotal: totals.grandTotal,
                    isInterState: totals.isInterState,
                  ),
                  const SizedBox(height: 16),
                ],

                // Payment Status & Optional Notes
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
                        'Payment Status',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: ['Paid', 'Unpaid', 'Partial'].map((status) {
                          final isSelected = _paymentStatus == status;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(status),
                              selected: isSelected,
                              selectedColor: colorScheme.primary,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : colorScheme.onSurface,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              onSelected: (bool selected) {
                                if (selected) {
                                  setState(() => _paymentStatus = status);
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes / Remarks (Optional)',
                          hintText: 'e.g. Delivered by carrier, payment via UPI',
                          prefixIcon: Icon(Icons.note_alt_outlined),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Save & Generate Invoice Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveAndGenerateBill,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'SAVE & GENERATE INVOICE',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                          ),
                        ),
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
