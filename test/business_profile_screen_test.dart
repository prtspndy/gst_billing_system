import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gst_billing_system/core/theme/app_theme.dart';
import 'package:gst_billing_system/core/theme/theme_controller.dart';
import 'package:gst_billing_system/providers/business_profile_provider.dart';
import 'package:gst_billing_system/screens/settings/business_profile_screen.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    Get.put<ThemeController>(ThemeController(), permanent: true);
  });

  Widget buildTestWidget({ThemeData? theme}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BusinessProfileProvider()),
      ],
      child: MaterialApp(
        theme: theme ?? AppTheme.lightTheme,
        home: const BusinessProfileScreen(),
      ),
    );
  }

  testWidgets('BusinessProfileScreen renders as dedicated Business Profile screen with all fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // 1. Verify Title in GlassAppBar
    expect(find.text('Business Profile'), findsOneWidget);

    // 2. Verify Business Profile Header & Sections
    expect(find.text('Shop & Contact Information'), findsOneWidget);
    expect(find.text('GST & Location Information'), findsOneWidget);
    expect(find.text('Invoice Terms & Conditions'), findsOneWidget);

    // 3. Verify Required and Optional Fields
    expect(find.text('Business / Shop Name *'), findsOneWidget);
    expect(find.text('Mobile / Phone Number *'), findsOneWidget);
    expect(find.text('Email Address (Optional)'), findsOneWidget);
    expect(find.text('State *'), findsOneWidget);
    expect(find.text('GSTIN (Optional)'), findsOneWidget);
    expect(find.text('Address *'), findsOneWidget);
    expect(find.text('Terms & Conditions (Optional)'), findsOneWidget);

    // 4. Verify Primary Save CTA
    expect(find.text('SAVE BUSINESS PROFILE'), findsOneWidget);
    expect(find.text('SAVE'), findsOneWidget);
  });

  testWidgets('BusinessProfileScreen renders properly in Dark Theme',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(theme: AppTheme.darkTheme));
    await tester.pumpAndSettle();

    expect(find.text('Business Profile'), findsOneWidget);
    expect(find.text('Shop & Contact Information'), findsOneWidget);
    expect(find.text('GST & Location Information'), findsOneWidget);
    expect(find.text('SAVE BUSINESS PROFILE'), findsOneWidget);
  });
}
