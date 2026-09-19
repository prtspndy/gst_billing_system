import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gst_billing_system/core/theme/app_theme.dart';
import 'package:gst_billing_system/widgets/common/glass_fab.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('GlassFloatingActionButton Tests', () {
    testWidgets('renders extended with BackdropFilter, icon and label in Light Theme',
        (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            floatingActionButton: GlassFloatingActionButton.extended(
              onPressed: () => pressed = true,
              icon: const Icon(Icons.add_shopping_cart_rounded),
              label: const Text('New Bill'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Verify text and icon
      expect(find.text('New Bill'), findsOneWidget);
      expect(find.byIcon(Icons.add_shopping_cart_rounded), findsOneWidget);

      // 2. Verify BackdropFilter is present for glassmorphic effect
      expect(find.byType(BackdropFilter), findsOneWidget);
      final backdropFilter = tester.widget<BackdropFilter>(find.byType(BackdropFilter));
      expect(backdropFilter.filter, equals(ImageFilter.blur(sigmaX: 14, sigmaY: 14)));

      // 3. Verify tapping calls onPressed
      await tester.tap(find.text('New Bill'));
      expect(pressed, isTrue);
    });

    testWidgets('renders extended in Dark Theme with high contrast',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            floatingActionButton: GlassFloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.person_add_rounded),
              label: const Text('Add Party'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Add Party'), findsOneWidget);
      expect(find.byIcon(Icons.person_add_rounded), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('renders icon-only GlassFloatingActionButton properly',
        (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            floatingActionButton: GlassFloatingActionButton(
              onPressed: () => pressed = true,
              icon: const Icon(Icons.add_box_rounded),
              tooltip: 'Add Product',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add_box_rounded), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
      expect(find.byType(Tooltip), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add_box_rounded));
      expect(pressed, isTrue);
    });

    testWidgets('renders Create Invoice FAB label correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            floatingActionButton: GlassFloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.post_add_rounded),
              label: const Text('Create Invoice'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Create Invoice'), findsOneWidget);
      expect(find.byIcon(Icons.post_add_rounded), findsOneWidget);
    });
  });
}
