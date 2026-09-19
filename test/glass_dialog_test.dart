import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gst_billing_system/core/theme/app_theme.dart';
import 'package:gst_billing_system/widgets/common/glass_dialog.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('GlassAlertDialog renders with BackdropFilter, title, content and actions',
      (WidgetTester tester) async {
    bool cancelPressed = false;
    bool confirmPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => GlassAlertDialog(
                    title: const Text('Confirm Action'),
                    content: const Text('Are you sure you want to proceed?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          cancelPressed = true;
                          Navigator.pop(ctx);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          confirmPressed = true;
                          Navigator.pop(ctx);
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Open Dialog'),
            ),
          ),
        ),
      ),
    );

    // Tap to open dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Verify BackdropFilter is present for glassmorphic blur
    expect(find.byType(BackdropFilter), findsWidgets);
    final backdropFilter = tester.widget<BackdropFilter>(find.byType(BackdropFilter).first);
    expect(backdropFilter.filter, isNotNull);

    // Verify Title and Content are displayed
    expect(find.text('Confirm Action'), findsOneWidget);
    expect(find.text('Are you sure you want to proceed?'), findsOneWidget);

    // Verify Actions are displayed and interactive
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);

    // Tap Confirm
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(confirmPressed, isTrue);
    expect(cancelPressed, isFalse);
  });

  testWidgets('GlassAlertDialog renders properly in Dark Theme with midnight slate styling',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => const GlassAlertDialog(
                    title: Text('Dark Glass Dialog'),
                    content: Text('Testing dark mode glass appearance.'),
                  ),
                );
              },
              child: const Text('Open Dark Dialog'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Dark Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Dark Glass Dialog'), findsOneWidget);
    expect(find.text('Testing dark mode glass appearance.'), findsOneWidget);
    expect(find.byType(BackdropFilter), findsWidgets);
  });
}
