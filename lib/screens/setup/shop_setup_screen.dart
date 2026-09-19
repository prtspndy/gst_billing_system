import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_shadows.dart';
import '../../models/business_profile.dart';
import '../../providers/business_profile_provider.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/common/glass_app_bar.dart';

/// Professional Business Profile / Shop Setup screen for the GST Billing System.
///
/// Prompts the user to configure their shop and GST business information
/// immediately after authentication, with primary CTA "Save & Continue".
class ShopSetupScreen extends StatefulWidget {
  const ShopSetupScreen({super.key});

  @override
  State<ShopSetupScreen> createState() => _ShopSetupScreenState();
}

class _ShopSetupScreenState extends State<ShopSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _shopNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _gstinController;
  late final TextEditingController _emailController;

  String? _selectedState;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<BusinessProfileProvider>(context, listen: false).profile;
    // Use existing profile values if they are custom, or prefill email from auth
    String? userEmail;
    try {
      userEmail = AuthService().currentUser?.email;
    } catch (_) {
      // Gracefully handle uninitialized Firebase in tests
    }

    final isCustomShop = profile.shopName.isNotEmpty && profile.shopName != 'My Business / Shop';
    _shopNameController = TextEditingController(text: isCustomShop ? profile.shopName : '');
    _phoneController = TextEditingController(text: isCustomShop ? profile.phone : '');
    _addressController = TextEditingController(text: isCustomShop ? profile.address : '');
    _gstinController = TextEditingController(text: isCustomShop ? profile.gstin : '');
    _emailController = TextEditingController(
      text: isCustomShop && profile.email.isNotEmpty ? profile.email : (userEmail ?? ''),
    );
    _selectedState = profile.state.isNotEmpty ? profile.state : 'Gujarat';
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _gstinController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveAndContinue() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedState == null || _selectedState!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your business state')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final provider = Provider.of<BusinessProfileProvider>(context, listen: false);
      final existingProfile = provider.profile;

      final updatedProfile = BusinessProfile(
        shopName: _shopNameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        state: _selectedState!,
        gstin: _gstinController.text.trim().toUpperCase(),
        email: _emailController.text.trim(),
        terms: existingProfile.terms.isNotEmpty
            ? existingProfile.terms
            : '1. Goods once sold will not be taken back.\n2. Subject to local jurisdiction.',
      );

      final success = await provider.saveProfile(updatedProfile);
      if (success) {
        await DatabaseService.instance.setShopSetupCompleted(true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Business profile configured successfully!'),
              backgroundColor: Color(0xFF2E7D32),
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Navigate to Home/Dashboard
          Get.offAllNamed(AppRoutes.home);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to save profile. Please try again.'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const GlassAppBar(
        title: Text('Business Profile Setup'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Banner Card
                    Container(
                      padding: const EdgeInsets.all(18.0),
                      decoration: BoxDecoration(
                        color: isDark
                            ? colorScheme.primaryContainer.withValues(alpha: 0.35)
                            : colorScheme.primaryContainer.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: isDark ? 0.35 : 0.25),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.storefront_rounded,
                              size: 28,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Set Up Your Shop / Business',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Enter your details below to appear on your official GST invoices. You can always edit these later in Settings.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Main Form Surface Card
                    Container(
                      padding: const EdgeInsets.all(22.0),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: colorScheme.outline),
                        boxShadow: AppShadows.level1(isDark),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Business Information',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Business / Shop Name *
                          TextFormField(
                            controller: _shopNameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Business / Shop Name *',
                              hintText: 'e.g. Apex Electronics & Services',
                              prefixIcon: Icon(Icons.store_rounded),
                            ),
                            validator: (v) => Validators.requiredField(v, 'Business / Shop Name'),
                          ),
                          const SizedBox(height: 16),

                          // Mobile Number *
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Mobile Number *',
                              hintText: '10-digit phone number',
                              prefixIcon: Icon(Icons.phone_rounded),
                            ),
                            validator: (v) => Validators.phone(v, required: true),
                          ),
                          const SizedBox(height: 16),

                          // Address *
                          TextFormField(
                            controller: _addressController,
                            maxLines: 2,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              labelText: 'Address *',
                              hintText: 'Shop/Office address, Area, City, Pincode',
                              prefixIcon: Icon(Icons.location_on_rounded),
                            ),
                            validator: (v) => Validators.requiredField(v, 'Address'),
                          ),
                          const SizedBox(height: 16),

                          // State *
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            initialValue: _selectedState,
                            decoration: InputDecoration(
                              labelText: 'State *',
                              prefixIcon: const Icon(Icons.map_rounded),
                              helperText: 'Sales within this state use CGST + SGST. Outside uses IGST.',
                              helperMaxLines: 2,
                              helperStyle: TextStyle(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                                fontSize: 11,
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
                                v == null || v.isEmpty ? 'Please select your state' : null,
                          ),
                          const SizedBox(height: 20),

                          const Divider(),
                          const SizedBox(height: 16),

                          // Optional Fields Header
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 16,
                                color: colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Optional GST & Contact Information',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // GSTIN (Optional)
                          TextFormField(
                            controller: _gstinController,
                            textCapitalization: TextCapitalization.characters,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                              LengthLimitingTextInputFormatter(15),
                            ],
                            decoration: InputDecoration(
                              labelText: 'GSTIN (Optional)',
                              hintText: 'e.g. 24AAAAA0000A1Z5',
                              prefixIcon: const Icon(Icons.badge_rounded),
                              helperText: 'Leave empty if your business is not registered under GST',
                              helperStyle: TextStyle(
                                color: colorScheme.onSurface.withValues(alpha: 0.55),
                                fontSize: 11,
                              ),
                            ),
                            validator: (v) => Validators.gstin(v, required: false),
                          ),
                          const SizedBox(height: 16),

                          // Email (Optional)
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email (Optional)',
                              hintText: 'e.g. contact@business.com',
                              prefixIcon: Icon(Icons.email_rounded),
                            ),
                            validator: (v) => Validators.email(v, required: false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Primary CTA: Save & Continue
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleSaveAndContinue,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Save & Continue',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 20),
                              ],
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Helper note
                    Center(
                      child: Text(
                        'You can update these details anytime from Profile / Settings.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
