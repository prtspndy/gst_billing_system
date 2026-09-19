import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gst_billing_system/core/theme/app_theme.dart';
import 'package:gst_billing_system/screens/splash/splash_screen.dart';
import 'package:lottie/lottie.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('SplashScreen displays official app logo and "GST Billing System" with NO animations',
      (WidgetTester tester) async {
    bool loadedCallbackFired = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: SplashScreen(
          minimumDuration: const Duration(milliseconds: 200),
          onLoaded: () {
            loadedCallbackFired = true;
          },
        ),
      ),
    );

    // Initial pump
    await tester.pump();

    // 1. Verify App Logo (Image widget) is present
    expect(find.byType(Image), findsOneWidget);

    // 2. Verify App Name "GST Billing System" is present
    expect(find.text('GST Billing System'), findsOneWidget);

    // 3. STRICT REQUIREMENT: Verify NO Lottie animation exists on the screen
    expect(find.byType(Lottie), findsNothing);

    // 4. Verify no buttons exist
    expect(find.byType(ElevatedButton), findsNothing);
    expect(find.byType(OutlinedButton), findsNothing);
    expect(find.byType(TextButton), findsNothing);
    expect(find.byType(IconButton), findsNothing);

    // Advance past minimum duration
    await tester.pump(const Duration(milliseconds: 300));

    // 5. Verify onLoaded callback fired
    expect(loadedCallbackFired, isTrue);
  });

  testWidgets('SplashScreen renders properly in Dark Theme with midnight background',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: SplashScreen(
          minimumDuration: const Duration(milliseconds: 100),
          onLoaded: () {},
        ),
      ),
    );

    await tester.pump();

    // Verify Scaffold background matches dark theme (#0B0E14)
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, const Color(0xFF0B0E14));

    // Verify Logo and App Name exist in dark theme
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('GST Billing System'), findsOneWidget);
    expect(find.byType(Lottie), findsNothing);

    await tester.pump(const Duration(milliseconds: 200));
  });
}
