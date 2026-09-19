import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gst_billing_system/core/theme/app_theme.dart';
import 'package:gst_billing_system/core/theme/theme_controller.dart';
import 'package:gst_billing_system/providers/bill_provider.dart';
import 'package:gst_billing_system/providers/business_profile_provider.dart';
import 'package:gst_billing_system/providers/item_provider.dart';
import 'package:gst_billing_system/providers/party_provider.dart';
import 'package:gst_billing_system/screens/home_shell.dart';
import 'package:gst_billing_system/widgets/common/glass_fab.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    Get.put<ThemeController>(ThemeController(), permanent: true);
  });

  Widget buildShellTestWidget({ThemeData? theme}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BillProvider()),
        ChangeNotifierProvider(create: (_) => PartyProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => BusinessProfileProvider()),
      ],
      child: MaterialApp(
        theme: theme ?? AppTheme.lightTheme,
        home: const HomeShell(),
      ),
    );
  }

  group('HomeShell Floating Action Button Tests', () {
    testWidgets(
        'shows correct FABs on mobile for Dashboard, Parties, Products, and Invoices',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildShellTestWidget());
      await tester.pumpAndSettle();

      // 1. Tab 0: Dashboard -> "New Bill" FAB
      expect(find.byType(GlassFloatingActionButton), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(GlassFloatingActionButton),
          matching: find.text('New Bill'),
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.add_shopping_cart_rounded), findsOneWidget);

      // 2. Tab 1: Parties -> "Add Party" FAB
      await tester.tap(find.byIcon(Icons.people_outline_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(GlassFloatingActionButton), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(GlassFloatingActionButton),
          matching: find.text('Add Party'),
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.person_add_rounded), findsOneWidget);

      // 3. Tab 2: Products -> "Add Product" FAB
      await tester.tap(find.byIcon(Icons.inventory_2_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(GlassFloatingActionButton), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(GlassFloatingActionButton),
          matching: find.text('Add Product'),
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.add_box_rounded), findsOneWidget);

      // 4. Tab 3: Invoices -> "Create Invoice" FAB
      await tester.tap(find.byIcon(Icons.receipt_long_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(GlassFloatingActionButton), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(GlassFloatingActionButton),
          matching: find.text('Create Invoice'),
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.post_add_rounded), findsOneWidget);

      // 5. Tab 4: Profile -> No FAB
      await tester.tap(find.byIcon(Icons.storefront_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(GlassFloatingActionButton), findsNothing);
    });

    testWidgets('renders FAB properly in Dark Theme',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildShellTestWidget(theme: AppTheme.darkTheme));
      await tester.pumpAndSettle();

      // Verify FAB in Dark Theme on Dashboard
      expect(find.byType(GlassFloatingActionButton), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(GlassFloatingActionButton),
          matching: find.text('New Bill'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders FAB on Wide Screen (Tablet / Desktop) layout',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildShellTestWidget());
      await tester.pumpAndSettle();

      // NavigationRail is present on wide screens
      expect(find.byType(NavigationRail), findsOneWidget);

      // Verify FAB is present on wide screen
      expect(find.byType(GlassFloatingActionButton), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(GlassFloatingActionButton),
          matching: find.text('New Bill'),
        ),
        findsOneWidget,
      );
    });
  });
}
