import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_shadows.dart';
import '../../models/business_profile.dart';
import '../../providers/business_profile_provider.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/common/glass_app_bar.dart';
import '../../widgets/common/glass_dialog.dart';
import '../../core/theme/theme_controller.dart';

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
  bool _isLoading = false;
  bool _showInvoicePreview = false;

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

  Future<void> _handleSignOut() async {
    final colorScheme = Theme.of(context).colorScheme;
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => GlassAlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure you want to sign out of your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        await AuthService().signOut();
      } catch (e) {
        debugPrint('Error signing out: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed out successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      Get.offAllNamed(AppRoutes.login);
    }
  }

  Widget _buildBusinessHeader(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final shopName = _shopNameController.text.trim().isNotEmpty
        ? _shopNameController.text.trim()
        : 'My Business / Shop';
    final gstin = _gstinController.text.trim().toUpperCase();
    final state = _selectedState ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? const Color(0xFF30363D)
              : colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
        boxShadow: AppShadows.level2(isDark),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shopName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: gstin.isNotEmpty
                                  ? const Color(0xFF2E7D32)
                                      .withValues(alpha: 0.12)
                                  : colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: gstin.isNotEmpty
                                    ? const Color(0xFF2E7D32)
                                        .withValues(alpha: 0.3)
                                    : colorScheme.outlineVariant,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  gstin.isNotEmpty
                                      ? Icons.verified_rounded
                                      : Icons.info_outline_rounded,
                                  size: 13,
                                  color: gstin.isNotEmpty
                                      ? const Color(0xFF2E7D32)
                                      : colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    gstin.isNotEmpty
                                        ? 'GST: $gstin'
                                        : 'Non-GST',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: gstin.isNotEmpty
                                          ? const Color(0xFF2E7D32)
                                          : colorScheme.onSurface
                                              .withValues(alpha: 0.7),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (state.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: colorScheme.primary
                                      .withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.place_rounded,
                                    size: 13,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      state,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.primary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
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
          const Divider(height: 1),
          // Toggle Live Invoice Preview
          InkWell(
            onTap: () {
              setState(() {
                _showInvoicePreview = !_showInvoicePreview;
              });
            },
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    _showInvoicePreview
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _showInvoicePreview
                          ? 'Hide Invoice Header'
                          : 'Preview on Tax Invoice',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _showInvoicePreview
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          if (_showInvoicePreview) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildLiveInvoicePreview(context, isDark),
            ),
          ],
        ],
      ),
    );
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
    final terms = _termsController.text.trim();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F141C) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  shopName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'SAMPLE HEADER',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$address, $state',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              Text(
                'Phone: $phone',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              if (email.isNotEmpty)
                Text(
                  'Email: $email',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            gstin.isNotEmpty ? 'GSTIN: $gstin' : 'GSTIN: Unregistered',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: gstin.isNotEmpty
                  ? const Color(0xFF2E7D32)
                  : colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          if (terms.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 6),
            Text(
              'Terms: $terms',
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? const Color(0xFF30363D)
              : colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
        boxShadow: AppShadows.level1(isDark),
      ),
      padding: const EdgeInsets.all(22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildThemeButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                    ? colorScheme.primary.withValues(alpha: 0.25)
                    : colorScheme.primary.withValues(alpha: 0.15))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
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
          GetBuilder<ThemeController>(
            init: Get.isRegistered<ThemeController>()
                ? Get.find<ThemeController>()
                : Get.put(ThemeController()),
            builder: (themeCtrl) {
              return Obx(() {
                final currentMode = themeCtrl.themeMode;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E2638)
                        : colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF30363D)
                          : colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildThemeButton(
                        context: context,
                        icon: Icons.brightness_auto_rounded,
                        tooltip: 'System Theme',
                        isSelected: currentMode == ThemeMode.system,
                        onPressed: () =>
                            themeCtrl.setThemeMode(ThemeMode.system),
                      ),
                      _buildThemeButton(
                        context: context,
                        icon: Icons.light_mode_rounded,
                        tooltip: 'Light Theme',
                        isSelected: currentMode == ThemeMode.light,
                        onPressed: () =>
                            themeCtrl.setThemeMode(ThemeMode.light),
                      ),
                      _buildThemeButton(
                        context: context,
                        icon: Icons.dark_mode_rounded,
                        tooltip: 'Dark Theme',
                        isSelected: currentMode == ThemeMode.dark,
                        onPressed: () =>
                            themeCtrl.setThemeMode(ThemeMode.dark),
                      ),
                    ],
                  ),
                );
              });
            },
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
                  // Top Hero Profile Header
                  _buildBusinessHeader(context, isDark),

                  // Section 1: Shop & Contact Information
                  _buildSectionCard(
                    context: context,
                    isDark: isDark,
                    icon: Icons.storefront_outlined,
                    title: 'Shop & Contact Information',
                    subtitle:
                        'These details will appear on the header of all your GST invoices.',
                    children: [
                      TextFormField(
                        controller: _shopNameController,
                        textCapitalization: TextCapitalization.words,
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Mobile / Phone Number *',
                          hintText: '10-digit mobile number for invoices',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        onChanged: (_) => setState(() {}),
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
                        onChanged: (_) => setState(() {}),
                        validator: (v) => Validators.email(v, required: false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Section 2: GST & Location Information
                  _buildSectionCard(
                    context: context,
                    isDark: isDark,
                    icon: Icons.location_on_outlined,
                    title: 'GST & Location Information',
                    subtitle:
                        'Your state determines intra-state (CGST + SGST) vs inter-state (IGST) tax calculation.',
                    children: [
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
                        validator: (v) => v == null || v.isEmpty
                            ? 'Please select your state'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _gstinController,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9]')),
                          LengthLimitingTextInputFormatter(15),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'GSTIN (Optional)',
                          hintText: 'e.g. 24AAAAA0000A1Z5',
                          prefixIcon: Icon(Icons.badge_outlined),
                          helperText:
                              'Leave empty if unregistered under GST',
                        ),
                        onChanged: (_) => setState(() {}),
                        validator: (v) =>
                            Validators.gstin(v, required: false),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 2,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Address *',
                          hintText: 'Shop / office address, city, pincode',
                          prefixIcon: Icon(Icons.place_outlined),
                        ),
                        onChanged: (_) => setState(() {}),
                        validator: (v) =>
                            Validators.requiredField(v, 'Address'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Section 3: Invoice Terms & Conditions (NO buttons as requested)
                  _buildSectionCard(
                    context: context,
                    isDark: isDark,
                    icon: Icons.article_outlined,
                    title: 'Invoice Terms & Conditions',
                    subtitle:
                        'These terms appear at the bottom of all generated tax invoices.',
                    children: [
                      TextFormField(
                        controller: _termsController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Terms & Conditions (Optional)',
                          hintText:
                              '1. Goods once sold will not be taken back without bill.\n2. Subject to local court jurisdiction only.\n3. Warranty as per manufacturer terms.',
                          prefixIcon: Icon(Icons.description_outlined),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
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
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Logout CTA
                  OutlinedButton.icon(
                    onPressed: _handleSignOut,
                    icon: Icon(
                      Icons.logout_rounded,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    label: Text(
                      'LOGOUT',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: colorScheme.error,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: colorScheme.error.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
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
