import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/business_profile.dart';
import '../../providers/business_profile_provider.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _shopNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _gstinController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _termsController;

  String? _selectedState;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<BusinessProfileProvider>(context, listen: false).profile;
    _shopNameController = TextEditingController(text: profile.shopName);
    _addressController = TextEditingController(text: profile.address);
    _gstinController = TextEditingController(text: profile.gstin);
    _phoneController = TextEditingController(text: profile.phone);
    _emailController = TextEditingController(text: profile.email);
    _termsController = TextEditingController(text: profile.terms);
    _selectedState = profile.state.isNotEmpty ? profile.state : 'Gujarat';
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _addressController.dispose();
    _gstinController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedState == null || _selectedState!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your business state')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final provider = Provider.of<BusinessProfileProvider>(context, listen: false);
    final updatedProfile = BusinessProfile(
      shopName: _shopNameController.text.trim(),
      address: _addressController.text.trim(),
      state: _selectedState!,
      gstin: _gstinController.text.trim().toUpperCase(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      terms: _termsController.text.trim(),
    );

    final success = await provider.saveProfile(updatedProfile);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Business profile saved successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save profile. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Business Profile & Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : _saveProfile,
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
                            'Shop / Business Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'This information appears on the header of all generated PDF tax invoices.',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _shopNameController,
                            decoration: const InputDecoration(
                              labelText: 'Shop / Company Name *',
                              hintText: 'e.g. Apex Electronics & Services',
                              prefixIcon: Icon(Icons.store_outlined),
                            ),
                            validator: (v) => Validators.requiredField(v, 'Shop name'),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _addressController,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'Business Address *',
                              hintText: 'Full address, City, Pincode',
                              prefixIcon: Icon(Icons.location_on_outlined),
                            ),
                            validator: (v) => Validators.requiredField(v, 'Address'),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedState,
                            decoration: const InputDecoration(
                              labelText: 'Business State *',
                              prefixIcon: Icon(Icons.map_outlined),
                              helperText: 'CRITICAL: Invoices to this state split into CGST + SGST. Invoices to other states use IGST.',
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
                                v == null || v.isEmpty ? 'Please select your state' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _gstinController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: const InputDecoration(
                              labelText: 'GSTIN *',
                              hintText: 'e.g. 24AAAAA0000A1Z5',
                              prefixIcon: Icon(Icons.badge_outlined),
                            ),
                            validator: (v) => Validators.gstin(v, required: true),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Business Phone Number',
                              hintText: 'Contact number for invoices',
                              prefixIcon: Icon(Icons.phone_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Business Email Address',
                              hintText: 'Email for invoices',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (v) => Validators.email(v, required: false),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _termsController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Terms & Conditions',
                              hintText: 'Invoice footer terms and conditions',
                              prefixIcon: Icon(Icons.article_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
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
                        : const Text(
                            'SAVE BUSINESS PROFILE',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
