import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/constants.dart';
import '../widgets/common/glass_fab.dart';
import 'bill/create_bill_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'party/party_form_screen.dart';
import 'party/party_list_screen.dart';
import 'item/item_form_screen.dart';
import 'item/item_list_screen.dart';
import 'bill/bill_list_screen.dart';
import 'settings/business_profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    PartyListScreen(),
    ItemListScreen(),
    BillListScreen(),
    BusinessProfileScreen(),
  ];

  Widget? _buildFab(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        // Dashboard/Home -> "New Bill"
        return GlassFloatingActionButton.extended(
          key: const ValueKey('fab_dashboard'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateBillScreen()),
            );
          },
          icon: const Icon(Icons.add_shopping_cart_rounded),
          label: const Text('New Bill'),
        ).animate().scale(duration: 350.ms, curve: Curves.easeOutBack);
      case 1:
        // Parties -> "Add Party"
        return GlassFloatingActionButton.extended(
          key: const ValueKey('fab_parties'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PartyFormScreen()),
            );
          },
          icon: const Icon(Icons.person_add_rounded),
          label: const Text('Add Party'),
        ).animate().scale(duration: 350.ms, curve: Curves.easeOutBack);
      case 2:
        // Products/Items -> "Add Product"
        return GlassFloatingActionButton.extended(
          key: const ValueKey('fab_products'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ItemFormScreen()),
            );
          },
          icon: const Icon(Icons.add_box_rounded),
          label: const Text('Add Product'),
        ).animate().scale(duration: 350.ms, curve: Curves.easeOutBack);
      case 3:
        // Bills/Invoices -> "Create Invoice"
        return GlassFloatingActionButton.extended(
          key: const ValueKey('fab_invoices'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateBillScreen()),
            );
          },
          icon: const Icon(Icons.post_add_rounded),
          label: const Text('Create Invoice'),
        ).animate().scale(duration: 350.ms, curve: Curves.easeOutBack);
      default:
        // Business Profile -> no FAB
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= 768;

        if (isWideScreen) {
          // Web / Tablet Wide Layout with Glassmorphic Navigation Rail
          return Scaffold(
            floatingActionButton: _buildFab(context),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: Row(
              children: [
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0B0E14).withValues(alpha: 0.82)
                            : Colors.white.withValues(alpha: 0.85),
                        border: Border(
                          right: BorderSide(
                            color: isDark
                                ? const Color(0xFF232B3E).withValues(alpha: 0.7)
                                : Colors.black.withValues(alpha: 0.08),
                            width: 1,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.3)
                                : Colors.black.withValues(alpha: 0.04),
                            blurRadius: 16,
                            offset: const Offset(3, 0),
                          ),
                        ],
                      ),
                      child: NavigationRail(
                        selectedIndex: _currentIndex,
                        onDestinationSelected: (index) {
                          setState(() => _currentIndex = index);
                        },
                        backgroundColor: Colors.transparent,
                        selectedIconTheme: IconThemeData(color: colorScheme.primary),
                        unselectedIconTheme: IconThemeData(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        selectedLabelTextStyle: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        unselectedLabelTextStyle: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Column(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.primary.withValues(alpha: 0.25),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  AppConstants.appLogo,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      Icons.receipt_long_rounded,
                                      color: colorScheme.primary,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppConstants.appName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        labelType: NavigationRailLabelType.all,
                        destinations: const [
                          NavigationRailDestination(
                            icon: Icon(Icons.dashboard_outlined),
                            selectedIcon: Icon(Icons.dashboard_rounded),
                            label: Text('Dashboard'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.people_outline_rounded),
                            selectedIcon: Icon(Icons.people_rounded),
                            label: Text('Parties'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.inventory_2_outlined),
                            selectedIcon: Icon(Icons.inventory_2_rounded),
                            label: Text('Products'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.receipt_long_outlined),
                            selectedIcon: Icon(Icons.receipt_long_rounded),
                            label: Text('Invoices'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.storefront_outlined),
                            selectedIcon: Icon(Icons.storefront_rounded),
                            label: Text('Profile'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _screens,
                  ),
                ),
              ],
            ),
          );
        }

        // Mobile Layout with Glassmorphic Bottom Navigation Bar
        return Scaffold(
          extendBody: true,
          floatingActionButton: _buildFab(context),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0B0E14).withValues(alpha: 0.82)
                      : Colors.white.withValues(alpha: 0.85),
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? const Color(0xFF232B3E).withValues(alpha: 0.7)
                          : Colors.black.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.4)
                          : Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: NavigationBar(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() => _currentIndex = index);
                  },
                  backgroundColor: Colors.transparent,
                  indicatorColor: isDark
                      ? const Color(0xFF222D42)
                      : colorScheme.primaryContainer,
                  elevation: 0,
                  destinations: [
                    NavigationDestination(
                      icon: const Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard_rounded, color: colorScheme.primary),
                      label: 'Dashboard',
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.people_outline_rounded),
                      selectedIcon: Icon(Icons.people_rounded, color: colorScheme.primary),
                      label: 'Parties',
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.inventory_2_outlined),
                      selectedIcon: Icon(Icons.inventory_2_rounded, color: colorScheme.primary),
                      label: 'Products',
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.receipt_long_outlined),
                      selectedIcon: Icon(Icons.receipt_long_rounded, color: colorScheme.primary),
                      label: 'Invoices',
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.storefront_outlined),
                      selectedIcon: Icon(Icons.storefront_rounded, color: colorScheme.primary),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
