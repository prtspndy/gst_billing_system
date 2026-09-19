import 'package:get/get.dart';
import '../models/bill.dart';
import '../services/database_service.dart';

class BillController extends GetxController {
  final DatabaseService _db = DatabaseService.instance;

  final RxList<Bill> _allBills = <Bill>[].obs;
  final RxList<Bill> _filteredBills = <Bill>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final RxBool isLoading = false.obs;
  final Rx<DashboardStats> dashboardStats = const DashboardStats().obs;

  List<Bill> get bills =>
      (searchQuery.isNotEmpty || startDate.value != null || endDate.value != null)
          ? _filteredBills
          : _allBills;

  @override
  void onInit() {
    super.onInit();
    loadBills();
  }

  Future<void> loadBills() async {
    isLoading.value = true;
    try {
      final list = await _db.getBills();
      _allBills.assignAll(list);
      dashboardStats.value = await _db.getDashboardStats();
      _applyFilters();
    } finally {
      isLoading.value = false;
    }
  }

  void searchBills(String query) {
    searchQuery.value = query.trim().toLowerCase();
    _applyFilters();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
    _applyFilters();
  }

  void clearFilters() {
    searchQuery.value = '';
    startDate.value = null;
    endDate.value = null;
    _filteredBills.clear();
  }

  void _applyFilters() {
    final q = searchQuery.value;
    final sDate = startDate.value;
    final eDate = endDate.value;

    _filteredBills.assignAll(
      _allBills.where((b) {
        bool matchesSearch = true;
        if (q.isNotEmpty) {
          final partyMatch = b.partyName.toLowerCase().contains(q);
          final invoiceMatch = b.invoiceNo.toLowerCase().contains(q);
          final gstinMatch = (b.partyGstin ?? '').toLowerCase().contains(q);
          matchesSearch = partyMatch || invoiceMatch || gstinMatch;
        }

        bool matchesDate = true;
        if (sDate != null) {
          final dayStart = DateTime(sDate.year, sDate.month, sDate.day);
          matchesDate = matchesDate && b.date.isAfter(dayStart.subtract(const Duration(milliseconds: 1)));
        }
        if (eDate != null) {
          final dayEnd = DateTime(eDate.year, eDate.month, eDate.day, 23, 59, 59);
          matchesDate = matchesDate && b.date.isBefore(dayEnd.add(const Duration(milliseconds: 1)));
        }

        return matchesSearch && matchesDate;
      }),
    );
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
    } catch (_) {
      return false;
    }
  }

  Future<Bill?> getBillById(String id) async {
    return _db.getBill(id);
  }
}
