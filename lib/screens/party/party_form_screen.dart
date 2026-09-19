import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_shadows.dart';
import '../../models/party.dart';
import '../../providers/party_provider.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/common/glass_app_bar.dart';

class PartyFormScreen extends StatefulWidget {
  final Party? partyToEdit;

  const PartyFormScreen({super.key, this.partyToEdit});

  @override
  State<PartyFormScreen> createState() => _PartyFormScreenState();
}

class _PartyFormScreenState extends State<PartyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _addressController;
  late final TextEditingController _gstinController;
  late final TextEditingController _emailController;

  String? _selectedState;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.partyToEdit;
    _nameController = TextEditingController(text: p?.name ?? '');
    _mobileController = TextEditingController(text: p?.mobile ?? '');
    _addressController = TextEditingController(text: p?.address ?? '');
    _gstinController = TextEditingController(text: p?.gstin ?? '');
    _emailController = TextEditingController(text: p?.email ?? '');
    _selectedState = p?.state ?? 'Gujarat';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _gstinController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveParty() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedState == null || _selectedState!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a state')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final partyProvider = Provider.of<PartyProvider>(context, listen: false);

    final isEditing = widget.partyToEdit != null;
    final party = Party(
      id: widget.partyToEdit?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      mobile: _mobileController.text.trim(),
      address: _addressController.text.trim(),
      state: _selectedState!,
      gstin: _gstinController.text.trim().isNotEmpty
          ? _gstinController.text.trim().toUpperCase()
          : null,
      email: _emailController.text.trim().isNotEmpty
          ? _emailController.text.trim().toLowerCase()
          : null,
      createdAt: widget.partyToEdit?.createdAt,
    );

    final success = isEditing
        ? await partyProvider.updateParty(party)
        : await partyProvider.addParty(party);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'Party updated successfully' : 'Party added successfully'),
          ),
        );
        Navigator.pop(context, party);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to save party. Please try again.'),
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
    final isEditing = widget.partyToEdit != null;

    return Scaffold(
      appBar: GlassAppBar(
        title: Text(isEditing ? 'Edit Party' : 'Add New Party'),
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : _saveParty,
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
                          'Party Details',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Party / Customer Name *',
                            hintText: 'e.g. Raj Electronics',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (v) => Validators.requiredField(v, 'Party name'),
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Mobile Number *',
                            hintText: '10-digit mobile number',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          validator: Validators.mobile,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _addressController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Address *',
                            hintText: 'Shop / Office / Street address',
                            prefixIcon: Icon(Icons.location_on_outlined),
                          ),
                          validator: (v) => Validators.requiredField(v, 'Address'),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: _selectedState,
                          decoration: InputDecoration(
                            labelText: 'State *',
                            prefixIcon: const Icon(Icons.map_outlined),
                            helperText: 'Determines CGST/SGST vs IGST calculation',
                            helperMaxLines: 2,
                            helperStyle: TextStyle(
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          items: AppConstants.indianStates.map((state) {
                            return DropdownMenuItem<String>(
                              value: state,
                              child: Text(state),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() => _selectedState = val);
                          },
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Please select state' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _gstinController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            labelText: 'GSTIN (Optional)',
                            hintText: '15-digit GSTIN (e.g. 24AAAAA0000A1Z5)',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                          validator: (v) => Validators.gstin(v, required: false),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email Address (Optional)',
                            hintText: 'e.g. customer@example.com',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (v) => Validators.email(v, required: false),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveParty,
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
                            isEditing ? 'UPDATE PARTY' : 'SAVE PARTY',
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
