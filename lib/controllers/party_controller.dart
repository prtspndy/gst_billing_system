import 'package:get/get.dart';
import '../models/party.dart';
import '../services/database_service.dart';

class PartyController extends GetxController {
  final DatabaseService _db = DatabaseService.instance;

  final RxList<Party> _allParties = <Party>[].obs;
  final RxList<Party> _filteredParties = <Party>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  List<Party> get parties => searchQuery.isEmpty ? _allParties : _filteredParties;

  @override
  void onInit() {
    super.onInit();
    loadParties();
  }

  Future<void> loadParties() async {
    isLoading.value = true;
    try {
      final list = await _db.getParties();
      _allParties.assignAll(list);
      _applySearch();
    } finally {
      isLoading.value = false;
    }
  }

  void searchParties(String query) {
    searchQuery.value = query.trim().toLowerCase();
    _applySearch();
  }

  void _applySearch() {
    if (searchQuery.isEmpty) {
      _filteredParties.clear();
    } else {
      final q = searchQuery.value;
      _filteredParties.assignAll(
        _allParties.where((p) {
          final nameMatch = p.name.toLowerCase().contains(q);
          final mobileMatch = p.mobile.contains(q);
          final gstinMatch = (p.gstin ?? '').toLowerCase().contains(q);
          final stateMatch = p.state.toLowerCase().contains(q);
          return nameMatch || mobileMatch || gstinMatch || stateMatch;
        }),
      );
    }
  }

  Future<bool> addParty(Party party) async {
    try {
      await _db.insertParty(party);
      await loadParties();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateParty(Party party) async {
    try {
      await _db.updateParty(party);
      await loadParties();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteParty(String id) async {
    try {
      await _db.deleteParty(id);
      await loadParties();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Party?> getPartyById(String id) async {
    return _db.getParty(id);
  }
}
