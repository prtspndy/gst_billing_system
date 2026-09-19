import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/theme_controller.dart';
import '../../models/business_profile.dart';
import '../../providers/business_profile_provider.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/common/glass_app_bar.dart';
import '../../widgets/common/glass_dialog.dart';

/// Dedicated Business Profile screen for the GST Billing System.
///
/// Manages shop name, business contact details, GSTIN, address, state,
/// and invoice terms that appear on all generated GST tax invoices.
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
  String? _userEmail;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profile =
        Provider.of<BusinessProfileProvider>(context, listen: false).profile;
    _shopNameController = TextEditingController(text: profile.shopName);
    _addressController = TextEditingController(text: profile.address);
    _gstinController = TextEditingController(text: profile.gstin);
    _phoneController = TextEditingController(text: profile.phone);
    _emailController = TextEditingController(text: profile.email);
    _termsController = TextEditingController(text: profile.terms);
    _selectedState = profile.state.isNotEmpty ? profile.state : 'Gujarat';
    try {
      _userEmail = AuthService().currentUser?.email;
    } catch (_) {
      _userEmail = null;
    }
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

    final provider =
        Provider.of<BusinessProfileProvider>(context, listen: false);
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
          const SnackBar(content: Text('Business profile saved successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to save profile. Please try again.'),
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

    return Scaffold(
      appBar: GlassAppBar(
        title: const Text('Business Profile'),
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : _saveProfile,
            icon: Icon(Icons.check_rounded, color: colorScheme.primary),
            label: Text(
              'SAVE',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Business Profile Header Card
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF161B26), const Color(0xFF222D42)]
                            : [
                                colorScheme.primaryContainer.withValues(alpha: 0.6),
                                colorScheme.surface,
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF232B3E)
                            : colorScheme.outlineVariant,
                      ),
                      boxShadow: AppShadows.level1(isDark),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Icon(
                            Icons.storefront_rounded,
                            color: colorScheme.primary,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _shopNameController.text.isNotEmpty
                                    ? _shopNameController.text
                                    : 'My Business / Shop',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _gstinController.text.isNotEmpty
                                          ? colorScheme.primary.withValues(alpha: 0.15)
                                          : colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      _gstinController.text.isNotEmpty
                                          ? 'GST: ${_gstinController.text}'
                                          : 'Unregistered / No GSTIN',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: _gstinController.text.isNotEmpty
                                            ? colorScheme.primary
                                            : colorScheme.onSurface.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ),
                                  if (_selectedState != null &&
                                      _selectedState!.isNotEmpty)
                                    Text(
                                      '• $_selectedState',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Business / Shop Details Card
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
                        Row(
                          children: [
                            Icon(
                              Icons.business_rounded,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Shop & Contact Information',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'These details will appear on the header of all your GST invoices.',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _shopNameController,
                          decoration: const InputDecoration(
                            labelText: 'Business / Shop Name *',
                            hintText: 'e.g. Apex Electronics & Services',
                            prefixIcon: Icon(Icons.storefront_outlined),
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (v) =>
                              Validators.requiredField(v, 'Business / Shop name'),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Mobile / Phone Number *',
                            hintText: '10-digit mobile number for invoices',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          validator: (v) => Validators.phone(v, required: true),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email Address (Optional)',
                            hintText: 'e.g. contact@apexshop.com',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (v) => Validators.email(v, required: false),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // GST & Address Information Card
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
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'GST & Location Information',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your state determines intra-state (CGST + SGST) vs inter-state (IGST) tax calculation.',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: _selectedState,
                          decoration: InputDecoration(
                            labelText: 'State *',
                            prefixIcon: const Icon(Icons.map_outlined),
                            helperText:
                                'Invoices in this state split into CGST + SGST. Other states use IGST.',
                            helperMaxLines: 2,
                            helperStyle: TextStyle(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
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
                          validator: (v) => v == null || v.isEmpty
                              ? 'Please select your state'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _gstinController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            labelText: 'GSTIN (Optional)',
                            hintText: 'e.g. 24AAAAA0000A1Z5',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (v) =>
                              Validators.gstin(v, required: false),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _addressController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Address *',
                            hintText: 'Shop / office address, city, pincode',
                            prefixIcon: Icon(Icons.place_outlined),
                          ),
                          validator: (v) =>
                              Validators.requiredField(v, 'Address'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Invoice Terms & Conditions Card
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
                        Row(
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Invoice Terms & Conditions',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'These terms appear at the bottom of all generated tax invoices.',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _termsController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Terms & Conditions (Optional)',
                            hintText:
                                '1. Goods once sold will not be taken back.\n2. Subject to local jurisdiction.',
                            prefixIcon: Icon(Icons.description_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Profile CTA
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _saveProfile,
                    icon: _isLoading
                        ? const SizedBox.shrink()
                        : const Icon(Icons.check_circle_outline_rounded),
                    label: _isLoading
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
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Secondary Preferences & Session Card
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.outline),
                      boxShadow: AppShadows.level1(isDark),
                    ),
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'App Preferences & Account',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Appearance / Theme',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GetBuilder<ThemeController>(
                          init: Get.find<ThemeController>(),
                          builder: (themeCtrl) {
                            return Obx(() {
                              final current = themeCtrl.themeMode;
                              return SegmentedButton<ThemeMode>(
                                segments: const [
                                  ButtonSegment(
                                    value: ThemeMode.system,
                                    icon: Icon(
                                      Icons.brightness_auto_rounded,
                                      size: 18,
                                    ),
                                    label: Text('System'),
                                  ),
                                  ButtonSegment(
                                    value: ThemeMode.light,
                                    icon: Icon(
                                      Icons.light_mode_rounded,
                                      size: 18,
                                    ),
                                    label: Text('Light'),
                                  ),
                                  ButtonSegment(
                                    value: ThemeMode.dark,
                                    icon: Icon(
                                      Icons.dark_mode_rounded,
                                      size: 18,
                                    ),
                                    label: Text('Dark'),
                                  ),
                                ],
                                selected: {current},
                                onSelectionChanged: (newSelection) {
                                  themeCtrl.setThemeMode(newSelection.first);
                                },
                              );
                            });
                          },
                        ),
                        const SizedBox(height: 18),
                        const Divider(height: 1),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Session',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.8),
                                    ),
                                  ),
                                  Text(
                                    _userEmail ?? 'Active Session',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final shouldLogout = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => GlassAlertDialog(
                                    title: const Text('Sign Out'),
                                    content: const Text(
                                      'Are you sure you want to sign out?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: colorScheme.error,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        child: const Text('Sign Out'),
                                      ),
                                    ],
                                  ),
                                );
                                if (shouldLogout == true) {
                                  try {
                                    await AuthService().signOut();
                                  } catch (_) {}
                                }
                              },
                              icon: Icon(
                                Icons.logout_rounded,
                                color: colorScheme.error,
                                size: 18,
                              ),
                              label: Text(
                                'Sign Out',
                                style: TextStyle(color: colorScheme.error),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: colorScheme.error
                                      .withValues(alpha: 0.5),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      '${AppConstants.appName} v1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
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
