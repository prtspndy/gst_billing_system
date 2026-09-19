import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/item.dart';
import '../../providers/item_provider.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';

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
    _selectedGstPercent = item?.gstPercent ?? 18.0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hsnController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final itemProvider = Provider.of<ItemProvider>(context, listen: false);
    final isEditing = widget.itemToEdit != null;

    final item = Item(
      id: widget.itemToEdit?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      hsnCode: _hsnController.text.trim().isNotEmpty ? _hsnController.text.trim() : null,
      unitPrice: double.parse(_priceController.text.trim()),
      gstPercent: _selectedGstPercent,
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
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, item);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save item. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.itemToEdit != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Item' : 'Add New Item'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : _saveItem,
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text(
              'SAVE',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.outline),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Item Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
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
                            decoration: const InputDecoration(
                              labelText: 'HSN / SAC Code (Optional)',
                              hintText: 'e.g. 8528',
                              prefixIcon: Icon(Icons.tag),
                              helperText: 'Harmonized System of Nomenclature code',
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
                              prefixIcon: Icon(Icons.currency_rupee),
                            ),
                            validator: (v) => Validators.positiveNumber(v, 'Unit price'),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'GST Rate (%) *',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
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
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
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
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
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
