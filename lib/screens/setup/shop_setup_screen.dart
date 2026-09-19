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

  Widget _buildLiveInvoicePreview(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final shopName = _shopNameController.text.trim().isNotEmpty
        ? _shopNameController.text.trim()
        : 'Your Business / Shop Name';
    final phone = _phoneController.text.trim().isNotEmpty
        ? _phoneController.text.trim()
        : 'Phone Number';
    final email = _emailController.text.trim();
    final address = _addressController.text.trim().isNotEmpty
        ? _addressController.text.trim()
        : 'Shop / Office Address, City';
    final state = _selectedState ?? 'State';
    final gstin = _gstinController.text.trim().toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1.5,
        ),
        boxShadow: AppShadows.level2(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Ribbon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Icon(Icons.visibility_outlined, size: 16, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'LIVE INVOICE PREVIEW',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'TAX INVOICE',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Preview Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shopName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '$address, $state',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 13,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          phone,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    if (email.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 13,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: gstin.isNotEmpty
                        ? const Color(0xFF2E7D32).withValues(alpha: 0.12)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: gstin.isNotEmpty
                          ? const Color(0xFF2E7D32).withValues(alpha: 0.3)
                          : colorScheme.outlineVariant,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        gstin.isNotEmpty ? Icons.verified_rounded : Icons.info_outline_rounded,
                        size: 13,
                        color: gstin.isNotEmpty
                            ? const Color(0xFF2E7D32)
                            : colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        gstin.isNotEmpty ? 'GSTIN: $gstin' : 'Unregistered (Composition / Non-GST)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: gstin.isNotEmpty
                              ? const Color(0xFF2E7D32)
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                        gradient: LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF161B22), const Color(0xFF1F2937)]
                              : [
                                  colorScheme.primaryContainer.withValues(alpha: 0.7),
                                  colorScheme.surface,
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF30363D)
                              : colorScheme.outlineVariant,
                        ),
                        boxShadow: AppShadows.level1(isDark),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: colorScheme.primary.withValues(alpha: 0.3),
                              ),
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
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'STEP 1 OF 1 • ONBOARDING',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.6,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Set Up Your Shop / Business',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
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

                    // Live Invoice Header Preview
                    _buildLiveInvoicePreview(context, isDark),

                    // Card 1: Shop & Contact Information
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
                          Row(
                            children: [
                              Icon(Icons.storefront_rounded, size: 20, color: colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Shop & Contact Information',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.primary,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
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
                            onChanged: (_) => setState(() {}),
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
                            onChanged: (_) => setState(() {}),
                            validator: (v) => Validators.phone(v, required: true),
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
                            onChanged: (_) => setState(() {}),
                            validator: (v) => Validators.email(v, required: false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Card 2: GST & Location Details
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
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded, size: 20, color: colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                'GST & Location Details',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.primary,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
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
                          const SizedBox(height: 16),

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
                            onChanged: (_) => setState(() {}),
                            validator: (v) => Validators.gstin(v, required: false),
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
                            onChanged: (_) => setState(() {}),
                            validator: (v) => Validators.requiredField(v, 'Address'),
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
