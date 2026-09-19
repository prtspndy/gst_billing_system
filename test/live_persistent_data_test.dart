import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:gst_billing_system/controllers/bill_controller.dart';
import 'package:gst_billing_system/controllers/business_profile_controller.dart';
import 'package:gst_billing_system/controllers/item_controller.dart';
import 'package:gst_billing_system/controllers/party_controller.dart';
import 'package:gst_billing_system/models/bill.dart';
import 'package:gst_billing_system/models/bill_item.dart';
import 'package:gst_billing_system/models/business_profile.dart';
import 'package:gst_billing_system/models/item.dart';
import 'package:gst_billing_system/models/party.dart';
import 'package:gst_billing_system/providers/bill_provider.dart';
import 'package:gst_billing_system/providers/business_profile_provider.dart';
import 'package:gst_billing_system/providers/item_provider.dart';
import 'package:gst_billing_system/providers/party_provider.dart';
import 'package:gst_billing_system/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    Get.reset();
    await DatabaseService.instance.init(force: true);
  });

  group('Live Persistent Data - Clean State & Mock Data Removal', () {
    test('Fresh initialization contains NO mock or static data', () async {
      final db = DatabaseService.instance;

      final parties = await db.getParties();
      final items = await db.getItems();
      final bills = await db.getBills();
      final profile = await db.getBusinessProfile();

      expect(parties, isEmpty, reason: 'Parties must be empty on fresh install (no mock seed)');
      expect(items, isEmpty, reason: 'Items must be empty on fresh install (no mock seed)');
      expect(bills, isEmpty, reason: 'Bills must be empty on fresh install (no mock seed)');
      expect(profile.shopName, isEmpty, reason: 'Business profile must not have mock shop name');
      expect(profile.gstin, isEmpty, reason: 'Business profile must not have mock GSTIN');
      expect(profile.phone, isEmpty, reason: 'Business profile must not have mock phone');
    });

    test('Legacy mock data cleanup purges sampleParties and sampleItems if present', () async {
      // Simulate an existing database/storage that had legacy mock data
      SharedPreferences.setMockInitialValues({
        'parties_list': [
          '{"id":"party_1","name":"Raj Electronics","mobile":"9876543210","address":"MG Road","state":"Gujarat"}',
          '{"id":"real_party_1","name":"Real Customer","mobile":"9999999999","address":"Ring Road","state":"Gujarat"}',
        ],
        'items_list': [
          '{"id":"item_1","name":"LED Smart TV","unitPrice":24500.0,"gstPercent":18.0}',
          '{"id":"real_item_1","name":"Real Product","unitPrice":150.0,"gstPercent":12.0}',
        ],
        'business_profile': '{"shopName":"My Business / Shop","state":"Gujarat"}',
      });

      await DatabaseService.instance.init(force: true);

      final parties = await DatabaseService.instance.getParties();
      final items = await DatabaseService.instance.getItems();
      final profile = await DatabaseService.instance.getBusinessProfile();

      // Verify legacy mock items are purged, but real items are preserved
      expect(parties.any((p) => p.id == 'party_1'), isFalse);
      expect(parties.any((p) => p.id == 'real_party_1'), isTrue);

      expect(items.any((i) => i.id == 'item_1'), isFalse);
      expect(items.any((i) => i.id == 'real_item_1'), isTrue);

      // Verify legacy dummy shop name 'My Business / Shop' is treated as empty
      expect(profile.shopName, isEmpty);
    });
  });

  group('Live Persistent Data - Party CRUD Operations', () {
    test('PartyProvider and PartyController create, read, update, delete live parties', () async {
      final provider = PartyProvider();
      await provider.loadParties();
      expect(provider.parties, isEmpty);

      // CREATE
      final newParty = Party(
        id: 'cust_101',
        name: 'Alpha Traders',
        mobile: '9123456789',
        address: '101 Commercial Hub',
        state: 'Gujarat',
        gstin: '24ABCDE1234F1Z5',
        email: 'alpha@traders.com',
      );
      final addResult = await provider.addParty(newParty);
      expect(addResult, isTrue);
      expect(provider.parties.length, 1);
      expect(provider.parties.first.name, 'Alpha Traders');

      // READ via Controller
      final controller = Get.put(PartyController());
      await controller.loadParties();
      expect(controller.parties.length, 1);
      expect(controller.parties.first.id, 'cust_101');

      // UPDATE
      final updatedParty = newParty.copyWith(name: 'Alpha Traders Pvt Ltd');
      final updateResult = await provider.updateParty(updatedParty);
      expect(updateResult, isTrue);
      expect(provider.parties.first.name, 'Alpha Traders Pvt Ltd');

      // DELETE
      final deleteResult = await provider.deleteParty('cust_101');
      expect(deleteResult, isTrue);
      expect(provider.parties, isEmpty);

      await controller.loadParties();
      expect(controller.parties, isEmpty);
    });
  });

  group('Live Persistent Data - Item CRUD Operations', () {
    test('ItemProvider and ItemController create, read, update, delete live items', () async {
      final provider = ItemProvider();
      await provider.loadItems();
      expect(provider.items, isEmpty);

      // CREATE
      final newItem = Item(
        id: 'prod_201',
        name: 'Industrial Bolt M10',
        hsnCode: '7318',
        unitPrice: 45.0,
        gstPercent: 18.0,
      );
      final addResult = await provider.addItem(newItem);
      expect(addResult, isTrue);
      expect(provider.items.length, 1);
      expect(provider.items.first.name, 'Industrial Bolt M10');

      // READ via Controller
      final controller = Get.put(ItemController());
      await controller.loadItems();
      expect(controller.items.length, 1);
      expect(controller.items.first.id, 'prod_201');

      // UPDATE
      final updatedItem = newItem.copyWith(unitPrice: 50.0);
      final updateResult = await provider.updateItem(updatedItem);
      expect(updateResult, isTrue);
      expect(provider.items.first.unitPrice, 50.0);

      // DELETE
      final deleteResult = await provider.deleteItem('prod_201');
      expect(deleteResult, isTrue);
      expect(provider.items, isEmpty);

      await controller.loadItems();
      expect(controller.items, isEmpty);
    });
  });

  group('Live Persistent Data - Bill & Invoice Operations', () {
    test('BillProvider and BillController persist bills and update DashboardStats dynamically', () async {
      final billProvider = BillProvider();
      await billProvider.loadBills();
      expect(billProvider.bills, isEmpty);
      expect(billProvider.dashboardStats.totalBillsToday, 0);
      expect(billProvider.dashboardStats.totalSalesToday, 0.0);

      // CREATE BILL
      final bill = Bill(
        id: 'bill_301',
        invoiceNo: 'INV-202609-0001',
        date: DateTime.now(),
        partyId: 'cust_101',
        partyName: 'Alpha Traders',
        partyMobile: '9123456789',
        partyAddress: '101 Commercial Hub',
        partyState: 'Gujarat',
        isInterState: false,
        subtotal: 1000.0,
        totalCgst: 90.0,
        totalSgst: 90.0,
        totalIgst: 0.0,
        totalTax: 180.0,
        grandTotal: 1180.0,
        paymentStatus: 'Paid',
        items: const [
          BillItem(
            itemId: 'prod_201',
            name: 'Industrial Bolt M10',
            rate: 50.0,
            qty: 20,
            gstPercent: 18.0,
            taxableAmount: 1000.0,
            cgst: 90.0,
            sgst: 90.0,
            igst: 0.0,
            lineTotal: 1180.0,
          ),
        ],
      );

      final success = await billProvider.createBill(bill);
      expect(success, isTrue);
      expect(billProvider.bills.length, 1);
      expect(billProvider.bills.first.invoiceNo, 'INV-202609-0001');
      expect(billProvider.dashboardStats.totalBillsToday, 1);
      expect(billProvider.dashboardStats.totalSalesToday, 1180.0);
      expect(billProvider.dashboardStats.totalTaxToday, 180.0);

      // READ via Controller
      final controller = Get.put(BillController());
      await controller.loadBills();
      expect(controller.bills.length, 1);
      expect(controller.dashboardStats.value.totalBillsToday, 1);

      // Sequential Invoice Number generation
      final nextInvoiceNo = await billProvider.getNextInvoiceNumber();
      expect(nextInvoiceNo, contains('0002'));
    });
  });

  group('Live Persistent Data - Business Profile Operations', () {
    test('BusinessProfileProvider and Controller save and retrieve custom business profile', () async {
      final provider = BusinessProfileProvider();
      await provider.loadProfile();
      expect(provider.profile.shopName, isEmpty);

      final newProfile = const BusinessProfile(
        shopName: 'Omkar Enterprises',
        address: '404 Industrial Area',
        state: 'Gujarat',
        gstin: '24ABCDE9999Z1Z8',
        phone: '9876500000',
        email: 'omkar@enterprises.com',
      );

      final saved = await provider.saveProfile(newProfile);
      expect(saved, isTrue);
      expect(provider.profile.shopName, 'Omkar Enterprises');

      // Verify Controller loads the updated profile
      final controller = Get.put(BusinessProfileController());
      await controller.loadProfile();
      expect(controller.profile.value.shopName, 'Omkar Enterprises');
      expect(controller.profile.value.gstin, '24ABCDE9999Z1Z8');
    });
  });
}
