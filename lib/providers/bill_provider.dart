import 'package:flutter/material.dart';
import '../models/bill.dart';
import '../services/database_service.dart';

class BillProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;

  List<Bill> _bills = [];
  List<Bill> _filteredBills = [];
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;
  DashboardStats _dashboardStats = const DashboardStats();

  List<Bill> get bills =>
      (_searchQuery.isNotEmpty || _startDate != null || _endDate != null)
          ? _filteredBills
          : _bills;

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  DashboardStats get dashboardStats => _dashboardStats;

  Future<void> loadBills() async {
    _isLoading = true;
    notifyListeners();
    try {
      _bills = await _db.getBills();
      _dashboardStats = await _db.getDashboardStats();
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading bills: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchBills(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _startDate = null;
    _endDate = null;
    _filteredBills = [];
    notifyListeners();
  }

  void _applyFilters() {
    _filteredBills = _bills.where((bill) {
      // Party name / invoice no match
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final partyMatch = bill.partyName.toLowerCase().contains(_searchQuery);
        final invoiceMatch = bill.invoiceNo.toLowerCase().contains(_searchQuery);
        final gstinMatch = (bill.partyGstin ?? '').toLowerCase().contains(_searchQuery);
        matchesSearch = partyMatch || invoiceMatch || gstinMatch;
      }

      // Date range match
      bool matchesDate = true;
      if (_startDate != null) {
        final dayStart = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
        matchesDate = matchesDate && bill.date.isAfter(dayStart.subtract(const Duration(milliseconds: 1)));
      }
      if (_endDate != null) {
        final dayEnd = DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);
        matchesDate = matchesDate && bill.date.isBefore(dayEnd.add(const Duration(milliseconds: 1)));
      }

      return matchesSearch && matchesDate;
    }).toList();
  }

  Future<List<Bill>> getBillsByParty(String partyId) async {
    return _db.getBillsByParty(partyId);
  }

  Future<String> getNextInvoiceNumber() async {
    return _db.generateNextInvoiceNumber();
  }

  Future<bool> createBill(Bill bill) async {
    try {
      await _db.insertBill(bill);
      await loadBills();
      return true;
    } catch (e) {
      debugPrint('Error saving bill: $e');
      return false;
    }
  }

  Future<Bill?> getBillById(String id) async {
    return _db.getBill(id);
  }
}
