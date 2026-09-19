import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_shadows.dart';
import '../../models/item.dart';
import '../../providers/item_provider.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/common/glass_app_bar.dart';

class ItemFormScreen extends StatefulWidget {
  final Item? itemToEdit;

  const ItemFormScreen({super.key, this.itemToEdit});

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _hsnController;
  late final TextEditingController _priceController;

  double _selectedGstPercent = 18.0;
  bool _isCustomGst = false;
  late final TextEditingController _customGstController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final item = widget.itemToEdit;
    _nameController = TextEditingController(text: item?.name ?? '');
    _hsnController = TextEditingController(text: item?.hsnCode ?? '');
    _priceController = TextEditingController(
      text: item != null ? item.unitPrice.toStringAsFixed(2) : '',
    );
    if (item != null) {
      _selectedGstPercent = item.gstPercent;
      if (!AppConstants.gstSlabs.contains(item.gstPercent)) {
        _isCustomGst = true;
        _customGstController = TextEditingController(
          text: item.gstPercent % 1 == 0
              ? item.gstPercent.toInt().toString()
              : item.gstPercent.toString(),
        );
      } else {
        _isCustomGst = false;
        _customGstController = TextEditingController();
      }
    } else {
      _selectedGstPercent = 18.0;
      _isCustomGst = false;
      _customGstController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hsnController.dispose();
    _priceController.dispose();
    _customGstController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final itemProvider = Provider.of<ItemProvider>(context, listen: false);
    final isEditing = widget.itemToEdit != null;

    final double gstPercent;
    if (_isCustomGst) {
      final parsed = double.tryParse(_customGstController.text.trim());
      if (parsed == null || parsed < 0 || parsed > 100) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please enter a valid custom GST percentage (0% to 100%)'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
      gstPercent = parsed;
    } else {
      gstPercent = _selectedGstPercent;
    }

    final item = Item(
      id: widget.itemToEdit?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      hsnCode: _hsnController.text.trim().isNotEmpty ? _hsnController.text.trim() : null,
      unitPrice: double.parse(_priceController.text.trim()),
      gstPercent: gstPercent,
      createdAt: widget.itemToEdit?.createdAt,
    );

    final success = isEditing
        ? await itemProvider.updateItem(item)
        : await itemProvider.addItem(item);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'Item updated successfully' : 'Item added successfully'),
          ),
        );
        Navigator.pop(context, item);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to save item. Please try again.'),
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
    final isEditing = widget.itemToEdit != null;

    return Scaffold(
      appBar: GlassAppBar(
        title: Text(isEditing ? 'Edit Item' : 'Add New Item'),
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : _saveItem,
            icon: Icon(Icons.check_rounded, color: colorScheme.primary),
            label: Text(
              'SAVE',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.outline),
                      boxShadow: AppShadows.level1(isDark),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Item Details',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Item / Product Name *',
                            hintText: 'e.g. LED Smart TV 43"',
                            prefixIcon: Icon(Icons.inventory_2_outlined),
                          ),
                          validator: (v) => Validators.requiredField(v, 'Item name'),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _hsnController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'HSN / SAC Code (Optional)',
                            hintText: 'e.g. 8528',
                            prefixIcon: const Icon(Icons.tag_rounded),
                            helperText: 'Harmonized System of Nomenclature code',
                            helperStyle: TextStyle(
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          validator: Validators.hsnCode,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Unit Price (₹) *',
                            hintText: '0.00',
                            prefixText: '₹ ',
                            prefixIcon: Icon(Icons.currency_rupee_rounded),
                          ),
                          validator: (v) => Validators.positiveNumber(v, 'Unit price'),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'GST Rate (%) *',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: AppConstants.gstSlabs.map((slab) {
                            final isSelected = _selectedGstPercent == slab;
                            return ChoiceChip(
                              label: Text('${slab.toStringAsFixed(0)}% GST'),
                              selected: isSelected,
                              selectedColor: colorScheme.primary,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : colorScheme.onSurface,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              onSelected: (bool selected) {
                                if (selected) {
                                  setState(() => _selectedGstPercent = slab);
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveItem,
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
                        : Text(
                            isEditing ? 'UPDATE ITEM' : 'SAVE ITEM',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
