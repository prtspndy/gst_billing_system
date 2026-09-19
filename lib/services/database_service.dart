import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart' as p;
import '../models/business_profile.dart';
import '../models/party.dart';
import '../models/item.dart';
import '../models/bill.dart';

class DashboardStats {
  final double totalSalesToday;
  final double totalSalesThisMonth;
  final double totalTaxToday;
  final double totalTaxThisMonth;
  final int totalBillsToday;
  final int totalBillsThisMonth;
  final int totalPartiesCount;
  final int totalItemsCount;

  const DashboardStats({
    this.totalSalesToday = 0.0,
    this.totalSalesThisMonth = 0.0,
    this.totalTaxToday = 0.0,
    this.totalTaxThisMonth = 0.0,
    this.totalBillsToday = 0,
    this.totalBillsThisMonth = 0,
    this.totalPartiesCount = 0,
    this.totalItemsCount = 0,
  });
}

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  sqflite.Database? _sqliteDb;
  SharedPreferences? _prefs;
  bool _isInitialized = false;

  Future<void> init({bool force = false}) async {
    if (_isInitialized && !force) return;

    _prefs = await SharedPreferences.getInstance();

    if (!kIsWeb) {
      try {
        final dbPath = await sqflite.getDatabasesPath();
        final path = p.join(dbPath, 'gst_billing.db');

        _sqliteDb = await sqflite.openDatabase(
          path,
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE parties (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                mobile TEXT NOT NULL,
                address TEXT NOT NULL,
                state TEXT NOT NULL,
                gstin TEXT,
                email TEXT,
                createdAt TEXT NOT NULL
              )
            ''');

            await db.execute('''
              CREATE TABLE items (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                hsnCode TEXT,
                unitPrice REAL NOT NULL,
                gstPercent REAL NOT NULL,
                createdAt TEXT NOT NULL
              )
            ''');

            await db.execute('''
              CREATE TABLE bills (
                id TEXT PRIMARY KEY,
                invoiceNo TEXT NOT NULL,
                date TEXT NOT NULL,
                partyId TEXT NOT NULL,
                partyName TEXT NOT NULL,
                partyMobile TEXT,
                partyAddress TEXT,
                partyState TEXT NOT NULL,
                partyGstin TEXT,
                items TEXT NOT NULL,
                subtotal REAL NOT NULL,
                totalCgst REAL NOT NULL,
                totalSgst REAL NOT NULL,
                totalIgst REAL NOT NULL,
                totalTax REAL NOT NULL,
                grandTotal REAL NOT NULL,
                isInterState INTEGER NOT NULL,
                paymentStatus TEXT NOT NULL,
                notes TEXT,
                createdAt TEXT NOT NULL
              )
            ''');

            await db.execute('''
              CREATE TABLE business_profile (
                id INTEGER PRIMARY KEY DEFAULT 1,
                shopName TEXT,
                address TEXT,
                state TEXT,
                gstin TEXT,
                phone TEXT,
                email TEXT,
                terms TEXT
              )
            ''');
          },
        );
      } catch (e) {
        debugPrint('SQLite initialization failed, falling back to SharedPreferences: $e');
        _sqliteDb = null;
      }
    }

    _isInitialized = true;
    await _cleanupLegacyMockData();
  }

  // ==================== LEGACY MOCK DATA CLEANUP ====================

  /// Purges any legacy mock parties or items that were previously seeded
  Future<void> _cleanupLegacyMockData() async {
    const legacyPartyIds = {'party_1', 'party_2', 'party_3', 'party_4'};
    const legacyItemIds = {'item_1', 'item_2', 'item_3', 'item_4', 'item_5', 'item_6'};

    try {
      if (_sqliteDb != null) {
        for (final id in legacyPartyIds) {
          await _sqliteDb!.delete('parties', where: 'id = ?', whereArgs: [id]);
        }
        for (final id in legacyItemIds) {
          await _sqliteDb!.delete('items', where: 'id = ?', whereArgs: [id]);
        }
      }

      final prefsParties = _prefs?.getStringList('parties_list');
      if (prefsParties != null) {
        final filtered = prefsParties.where((raw) {
          try {
            final map = jsonDecode(raw) as Map<String, dynamic>;
            return !legacyPartyIds.contains(map['id']);
          } catch (_) {
            return true;
          }
        }).toList();
        await _prefs?.setStringList('parties_list', filtered);
      }

      final prefsItems = _prefs?.getStringList('items_list');
      if (prefsItems != null) {
        final filtered = prefsItems.where((raw) {
          try {
            final map = jsonDecode(raw) as Map<String, dynamic>;
            return !legacyItemIds.contains(map['id']);
          } catch (_) {
            return true;
          }
        }).toList();
        await _prefs?.setStringList('items_list', filtered);
      }
    } catch (e) {
      debugPrint('Error cleaning up legacy mock data: $e');
    }
  }

  // ==================== BUSINESS PROFILE ====================

  Future<BusinessProfile> getBusinessProfile() async {
    if (_sqliteDb != null) {
      final result = await _sqliteDb!.query('business_profile', limit: 1);
      if (result.isNotEmpty) {
        final profile = BusinessProfile.fromMap(result.first);
        if (profile.shopName == 'My Business / Shop') {
          return const BusinessProfile();
        }
        return profile;
      }
    }

    final raw = _prefs?.getString('business_profile');
    if (raw != null) {
      final profile = BusinessProfile.fromMap(jsonDecode(raw) as Map<String, dynamic>);
      if (profile.shopName == 'My Business / Shop') {
        return const BusinessProfile();
      }
      return profile;
    }

    return const BusinessProfile();
  }

  Future<bool> isShopSetupCompleted() async {
    final completed = _prefs?.getBool('is_shop_setup_completed');
    if (completed != null) return completed;

    // Check if the business profile was already customized previously
    if (_sqliteDb != null) {
      final result = await _sqliteDb!.query('business_profile', limit: 1);
      if (result.isNotEmpty) {
        final profile = BusinessProfile.fromMap(result.first);
        if (profile.shopName.isNotEmpty &&
            profile.shopName != 'My Business / Shop') {
          await setShopSetupCompleted(true);
          return true;
        }
      }
    }

    final raw = _prefs?.getString('business_profile');
    if (raw != null) {
      final profile = BusinessProfile.fromMap(jsonDecode(raw) as Map<String, dynamic>);
      if (profile.shopName.isNotEmpty &&
          profile.shopName != 'My Business / Shop') {
        await setShopSetupCompleted(true);
        return true;
      }
    }

    return false;
  }

  Future<void> setShopSetupCompleted(bool completed) async {
    await _prefs?.setBool('is_shop_setup_completed', completed);
  }

  Future<void> saveBusinessProfile(BusinessProfile profile) async {
    if (_sqliteDb != null) {
      final map = profile.toMap();
      map['id'] = 1;
      await _sqliteDb!.insert(
        'business_profile',
        map,
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
      );
    }
    await _prefs?.setString('business_profile', jsonEncode(profile.toMap()));
    await setShopSetupCompleted(true);
  }

  // ==================== PARTIES ====================

  Future<List<Party>> getParties() async {
    if (_sqliteDb != null) {
      final rows = await _sqliteDb!.query('parties', orderBy: 'createdAt DESC');
      return rows.map((r) => Party.fromMap(r)).toList();
    }

    final rawList = _prefs?.getStringList('parties_list') ?? [];
    final parties = rawList
        .map((str) => Party.fromMap(jsonDecode(str) as Map<String, dynamic>))
        .toList();
    parties.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return parties;
  }

  Future<Party?> getParty(String id) async {
    if (_sqliteDb != null) {
      final rows = await _sqliteDb!.query(
        'parties',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (rows.isNotEmpty) return Party.fromMap(rows.first);
      return null;
    }

    final parties = await getParties();
    try {
      return parties.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> insertParty(Party party) async {
    if (_sqliteDb != null) {
      await _sqliteDb!.insert(
        'parties',
        party.toMap(),
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
      );
    }

    final parties = await getParties();
    parties.removeWhere((p) => p.id == party.id);
    parties.add(party);
    await _prefs?.setStringList(
      'parties_list',
      parties.map((p) => jsonEncode(p.toMap())).toList(),
    );
  }

  Future<void> updateParty(Party party) async {
    await insertParty(party);
  }

  Future<void> deleteParty(String id) async {
    if (_sqliteDb != null) {
      await _sqliteDb!.delete(
        'parties',
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    final parties = await getParties();
    parties.removeWhere((p) => p.id == id);
    await _prefs?.setStringList(
      'parties_list',
      parties.map((p) => jsonEncode(p.toMap())).toList(),
    );
  }

  // ==================== ITEMS ====================

  Future<List<Item>> getItems() async {
    if (_sqliteDb != null) {
      final rows = await _sqliteDb!.query('items', orderBy: 'createdAt DESC');
      return rows.map((r) => Item.fromMap(r)).toList();
    }

    final rawList = _prefs?.getStringList('items_list') ?? [];
    final items = rawList
        .map((str) => Item.fromMap(jsonDecode(str) as Map<String, dynamic>))
        .toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Future<Item?> getItem(String id) async {
    if (_sqliteDb != null) {
      final rows = await _sqliteDb!.query(
        'items',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (rows.isNotEmpty) return Item.fromMap(rows.first);
      return null;
    }

    final items = await getItems();
    try {
      return items.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> insertItem(Item item) async {
    if (_sqliteDb != null) {
      await _sqliteDb!.insert(
        'items',
        item.toMap(),
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
      );
    }

    final items = await getItems();
    items.removeWhere((i) => i.id == item.id);
    items.add(item);
    await _prefs?.setStringList(
      'items_list',
      items.map((i) => jsonEncode(i.toMap())).toList(),
    );
  }

  Future<void> updateItem(Item item) async {
    await insertItem(item);
  }

  Future<void> deleteItem(String id) async {
    if (_sqliteDb != null) {
      await _sqliteDb!.delete(
        'items',
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    final items = await getItems();
    items.removeWhere((i) => i.id == id);
    await _prefs?.setStringList(
      'items_list',
      items.map((i) => jsonEncode(i.toMap())).toList(),
    );
  }

  // ==================== BILLS ====================

  Future<List<Bill>> getBills() async {
    if (_sqliteDb != null) {
      final rows = await _sqliteDb!.query('bills', orderBy: 'date DESC');
      return rows.map((r) => Bill.fromMap(r)).toList();
    }

    final rawList = _prefs?.getStringList('bills_list') ?? [];
    final bills = rawList
        .map((str) => Bill.fromMap(jsonDecode(str) as Map<String, dynamic>))
        .toList();
    bills.sort((a, b) => b.date.compareTo(a.date));
    return bills;
  }

  Future<Bill?> getBill(String id) async {
    if (_sqliteDb != null) {
      final rows = await _sqliteDb!.query(
        'bills',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (rows.isNotEmpty) return Bill.fromMap(rows.first);
      return null;
    }

    final bills = await getBills();
    try {
      return bills.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Bill>> getBillsByParty(String partyId) async {
    if (_sqliteDb != null) {
      final rows = await _sqliteDb!.query(
        'bills',
        where: 'partyId = ?',
        whereArgs: [partyId],
        orderBy: 'date DESC',
      );
      return rows.map((r) => Bill.fromMap(r)).toList();
    }

    final bills = await getBills();
    return bills.where((b) => b.partyId == partyId).toList();
  }

  /// Bills cannot be edited after creation per GST requirements
  Future<void> insertBill(Bill bill) async {
    if (_sqliteDb != null) {
      await _sqliteDb!.insert(
        'bills',
        bill.toMap(),
        conflictAlgorithm: sqflite.ConflictAlgorithm.abort,
      );
    }

    final bills = await getBills();
    bills.insert(0, bill);
    await _prefs?.setStringList(
      'bills_list',
      bills.map((b) => jsonEncode(b.toMap())).toList(),
    );
  }

  // ==================== INVOICE NUMBER GENERATION ====================

  /// Generates sequential unique invoice numbers in format: INV-YYYYMM-NNNN
  Future<String> generateNextInvoiceNumber() async {
    final now = DateTime.now();
    final prefix = 'INV-${DateFormat('yyyyMM').format(now)}-';

    final bills = await getBills();
    int maxSeq = 0;

    for (final bill in bills) {
      if (bill.invoiceNo.startsWith(prefix)) {
        final seqPart = bill.invoiceNo.replaceFirst(prefix, '');
        final parsed = int.tryParse(seqPart);
        if (parsed != null && parsed > maxSeq) {
          maxSeq = parsed;
        }
      }
    }

    final nextSeq = maxSeq + 1;
    return '$prefix${nextSeq.toString().padLeft(4, '0')}';
  }

  // ==================== DASHBOARD STATS ====================

  Future<DashboardStats> getDashboardStats() async {
    final bills = await getBills();
    final parties = await getParties();
    final items = await getItems();

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 1);

    double salesToday = 0.0;
    double salesThisMonth = 0.0;
    double taxToday = 0.0;
    double taxThisMonth = 0.0;
    int billsToday = 0;
    int billsThisMonth = 0;

    for (final b in bills) {
      final bDate = b.date;
      final isToday = bDate.isAfter(todayStart.subtract(const Duration(milliseconds: 1))) &&
          bDate.isBefore(todayEnd);
      final isThisMonth = bDate.isAfter(monthStart.subtract(const Duration(milliseconds: 1))) &&
          bDate.isBefore(monthEnd);

      if (isToday) {
        salesToday += b.grandTotal;
        taxToday += b.totalTax;
        billsToday++;
      }

      if (isThisMonth) {
        salesThisMonth += b.grandTotal;
        taxThisMonth += b.totalTax;
        billsThisMonth++;
      }
    }

    return DashboardStats(
      totalSalesToday: salesToday,
      totalSalesThisMonth: salesThisMonth,
      totalTaxToday: taxToday,
      totalTaxThisMonth: taxThisMonth,
      totalBillsToday: billsToday,
      totalBillsThisMonth: billsThisMonth,
      totalPartiesCount: parties.length,
      totalItemsCount: items.length,
    );
  }
}
