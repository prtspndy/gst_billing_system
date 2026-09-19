import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gst_billing_system/models/item.dart';
import 'package:gst_billing_system/providers/item_provider.dart';
import 'package:gst_billing_system/screens/item/item_form_screen.dart';
import 'package:provider/provider.dart';

class MockItemProvider extends ChangeNotifier implements ItemProvider {
  Item? lastSavedItem;

  @override
  List<Item> get items => [];

  @override
  bool get isLoading => false;

  @override
  String get searchQuery => '';

  @override
  Future<void> loadItems() async {}

  @override
  Future<bool> addItem(Item item) async {
    lastSavedItem = item;
    return true;
  }

  @override
  Future<bool> updateItem(Item item) async {
    lastSavedItem = item;
    return true;
  }

  @override
  Future<bool> deleteItem(String id) async => true;

  @override
  Future<List<Item>> searchItems(String query) async => [];

  @override
  Future<Item?> getItemById(String id) async => null;
}

void main() {
  Widget buildTestWidget({Item? itemToEdit, required MockItemProvider provider}) {
    return MaterialApp(
      home: ChangeNotifierProvider<ItemProvider>.value(
        value: provider,
        child: ItemFormScreen(itemToEdit: itemToEdit),
      ),
    );
  }

  group('ItemFormScreen Custom GST Rate Tests', () {
    testWidgets('renders all standard slabs and the Custom chip', (tester) async {
      final mockProvider = MockItemProvider();
      await tester.pumpWidget(buildTestWidget(provider: mockProvider));
      await tester.pumpAndSettle();

      expect(find.text('0% GST'), findsOneWidget);
      expect(find.text('5% GST'), findsOneWidget);
      expect(find.text('12% GST'), findsOneWidget);
      expect(find.text('18% GST'), findsOneWidget);
      expect(find.text('28% GST'), findsOneWidget);
      expect(find.text('Custom'), findsOneWidget);

      // By default, custom input field is not visible
      expect(find.byType(TextFormField), findsNWidgets(3)); // Name, HSN, Price
    });

    testWidgets('tapping Custom chip reveals custom GST rate input field', (tester) async {
      final mockProvider = MockItemProvider();
      await tester.pumpWidget(buildTestWidget(provider: mockProvider));
      await tester.pumpAndSettle();

      // Tap Custom chip
      await tester.tap(find.text('Custom'));
      await tester.pumpAndSettle();

      // Custom input field should now be visible
      expect(find.text('Custom GST Rate (%) *'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4)); // Name, HSN, Price, Custom GST
    });

    testWidgets('entering valid custom GST rate saves item with that rate', (tester) async {
      final mockProvider = MockItemProvider();
      await tester.pumpWidget(buildTestWidget(provider: mockProvider));
      await tester.pumpAndSettle();

      // Enter Name
      await tester.enterText(find.widgetWithText(TextFormField, 'Item / Product Name *'), 'Special Gold Alloy');
      // Enter Price
      await tester.enterText(find.widgetWithText(TextFormField, 'Unit Price (₹) *'), '5000');

      // Tap Custom chip
      await tester.tap(find.text('Custom'));
      await tester.pumpAndSettle();

      // Enter Custom GST
      await tester.enterText(find.widgetWithText(TextFormField, 'Custom GST Rate (%) *'), '3');
      await tester.pumpAndSettle();

      // Chip label updates
      expect(find.text('Custom (3%)'), findsOneWidget);

      // Scroll to and tap SAVE ITEM button
      await tester.ensureVisible(find.text('SAVE ITEM'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('SAVE ITEM'));
      await tester.pumpAndSettle();

      expect(mockProvider.lastSavedItem, isNotNull);
      expect(mockProvider.lastSavedItem!.gstPercent, equals(3.0));
      expect(mockProvider.lastSavedItem!.name, equals('Special Gold Alloy'));
    });

    testWidgets('editing item with custom GST rate pre-selects Custom and fills field', (tester) async {
      final mockProvider = MockItemProvider();
      final item = Item(
        id: 'test-1',
        name: 'Diamond Cut Ring',
        unitPrice: 15000,
        gstPercent: 0.25,
      );

      await tester.pumpWidget(buildTestWidget(itemToEdit: item, provider: mockProvider));
      await tester.pumpAndSettle();

      // Custom chip should show Custom (0.25%)
      expect(find.text('Custom (0.25%)'), findsOneWidget);
      // Custom text field should be present and prefilled with 0.25
      expect(find.text('0.25'), findsOneWidget);
    });

    testWidgets('selecting standard slab after Custom hides the custom input', (tester) async {
      final mockProvider = MockItemProvider();
      await tester.pumpWidget(buildTestWidget(provider: mockProvider));
      await tester.pumpAndSettle();

      // Tap Custom
      await tester.tap(find.text('Custom'));
      await tester.pumpAndSettle();
      expect(find.text('Custom GST Rate (%) *'), findsOneWidget);

      // Tap 12% GST
      await tester.tap(find.text('12% GST'));
      await tester.pumpAndSettle();

      // Custom input field should disappear
      expect(find.text('Custom GST Rate (%) *'), findsNothing);
      expect(find.text('Custom'), findsOneWidget);
    });
  });
}
