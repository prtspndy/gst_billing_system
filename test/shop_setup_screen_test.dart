import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gst_billing_system/core/theme/app_theme.dart';
import 'package:gst_billing_system/providers/business_profile_provider.dart';
import 'package:gst_billing_system/screens/setup/shop_setup_screen.dart';
import 'package:provider/provider.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Widget buildTestWidget({ThemeData? theme}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BusinessProfileProvider()),
      ],
      child: MaterialApp(
        theme: theme ?? AppTheme.lightTheme,
        home: const ShopSetupScreen(),
      ),
    );
  }

  testWidgets('ShopSetupScreen renders all required and optional fields plus Save & Continue CTA',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    // Verify Title & Hero Banner
    expect(find.text('Business Profile Setup'), findsOneWidget);
    expect(find.text('Set Up Your Shop / Business'), findsOneWidget);

    // Verify Required Field Labels
    expect(find.text('Business / Shop Name *'), findsOneWidget);
    expect(find.text('Mobile Number *'), findsOneWidget);
    expect(find.text('Address *'), findsOneWidget);
    expect(find.text('State *'), findsOneWidget);

    // Verify Optional Field Labels
    expect(find.text('GSTIN (Optional)'), findsOneWidget);
    expect(find.text('Email (Optional)'), findsOneWidget);

    // Verify Primary CTA
    expect(find.text('Save & Continue'), findsOneWidget);
  });

  testWidgets('ShopSetupScreen form validation displays error on empty required fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    // Scroll to and tap Save & Continue without filling required fields
    final saveButton = find.text('Save & Continue');
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // Verify validation errors appear
    expect(find.text('Business / Shop Name is required'), findsOneWidget);
    expect(find.text('Mobile number is required'), findsOneWidget);
    expect(find.text('Address is required'), findsOneWidget);
  });

  testWidgets('ShopSetupScreen renders properly in Dark Theme',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(theme: AppTheme.darkTheme));
    await tester.pump();

    expect(find.text('Business Profile Setup'), findsOneWidget);
    expect(find.text('Save & Continue'), findsOneWidget);
  });
}
