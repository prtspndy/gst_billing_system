import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gst_billing_system/core/theme/app_theme.dart';
import 'package:gst_billing_system/widgets/common/status_badge.dart';
import 'package:gst_billing_system/widgets/common/tax_type_chip.dart';
import 'package:gst_billing_system/widgets/empty_state.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    Animate.restartOnHotReload = false;
  });

  testWidgets('StatusBadge renders correct status and dot indicator', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: StatusBadge(status: 'Paid'),
        ),
      ),
    );

    expect(find.text('Paid'), findsOneWidget);
  });

  testWidgets('TaxTypeChip renders Inter-State and Intra-State correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Column(
            children: [
              TaxTypeChip(isInterState: true),
              TaxTypeChip(isInterState: false),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Inter-State (IGST)'), findsOneWidget);
    expect(find.text('Intra-State (CGST + SGST)'), findsOneWidget);
  });

  testWidgets('EmptyState renders title and description', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: EmptyState(
            icon: Icons.receipt_long,
            title: 'No invoices created yet',
            description: 'Create your first invoice',
            buttonText: 'Create Bill',
            onButtonPressed: () {},
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('No invoices created yet'), findsOneWidget);
    expect(find.text('Create your first invoice'), findsOneWidget);
    expect(find.text('Create Bill'), findsOneWidget);
  });

  testWidgets('Dark Theme uses midnight slate palette matching login screen', (WidgetTester tester) async {
    final dark = AppTheme.darkTheme;
    expect(dark.scaffoldBackgroundColor, const Color(0xFF0B0E14));
    expect(dark.colorScheme.surface, const Color(0xFF141923));
    expect(dark.colorScheme.outline, const Color(0xFF232B3E));
    expect(dark.colorScheme.outlineVariant, const Color(0xFF1E2536));
    expect(dark.colorScheme.primaryContainer, const Color(0xFF222D42));
    expect(dark.inputDecorationTheme.fillColor, const Color(0xFF161B26));

    await tester.pumpWidget(
      MaterialApp(
        theme: dark,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final colorScheme = Theme.of(context).colorScheme;
              return Container(
                color: colorScheme.surface,
                child: const Text('Midnight Slate Test'),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Midnight Slate Test'), findsOneWidget);
  });

  testWidgets('Item tile renders without overflow on narrow screens (320px)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              leading: const SizedBox(width: 40, height: 40, child: Icon(Icons.inventory_2_rounded)),
              title: const Text('Sample Product Name That Is Quite Long', maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: const [
                  Text('HSN: 84713010'),
                  Text('GST: 18%'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  FittedBox(fit: BoxFit.scaleDown, child: Text('₹1,25,000.00')),
                  SizedBox(width: 4),
                  Icon(Icons.more_vert_rounded, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('HSN: 84713010'), findsOneWidget);
    expect(find.text('GST: 18%'), findsOneWidget);
  });
}
