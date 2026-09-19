import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gst_billing_system/app.dart';
import 'package:gst_billing_system/providers/bill_provider.dart';
import 'package:gst_billing_system/providers/business_profile_provider.dart';
import 'package:gst_billing_system/providers/item_provider.dart';
import 'package:gst_billing_system/providers/party_provider.dart';
import 'package:gst_billing_system/services/database_service.dart';

void main() {
  testWidgets('App loads and displays dashboard title smoke test', (WidgetTester tester) async {
    await DatabaseService.instance.init();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BusinessProfileProvider()),
          ChangeNotifierProvider(create: (_) => PartyProvider()),
          ChangeNotifierProvider(create: (_) => ItemProvider()),
          ChangeNotifierProvider(create: (_) => BillProvider()),
        ],
        child: const GstBillingApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('GST Billing System'), findsWidgets);
    expect(find.text('Dashboard'), findsWidgets);
  });
}
