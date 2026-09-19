import 'package:flutter/material.dart';
import '../models/party.dart';
import '../services/database_service.dart';

class PartyProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;

  List<Party> _parties = [];
  List<Party> _filteredParties = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<Party> get parties => _searchQuery.isEmpty ? _parties : _filteredParties;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  Future<void> loadParties() async {
    _isLoading = true;
    notifyListeners();
    try {
      _parties = await _db.getParties();
      _applySearch();
    } catch (e) {
      debugPrint('Error loading parties: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchParties(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredParties = [];
    } else {
      _filteredParties = _parties.where((p) {
        final nameMatch = p.name.toLowerCase().contains(_searchQuery);
        final mobileMatch = p.mobile.contains(_searchQuery);
        final gstinMatch = (p.gstin ?? '').toLowerCase().contains(_searchQuery);
        final stateMatch = p.state.toLowerCase().contains(_searchQuery);
        return nameMatch || mobileMatch || gstinMatch || stateMatch;
      }).toList();
    }
  }

  Future<bool> addParty(Party party) async {
    try {
      await _db.insertParty(party);
      await loadParties();
      return true;
    } catch (e) {
      debugPrint('Error adding party: $e');
      return false;
    }
  }

  Future<bool> updateParty(Party party) async {
    try {
      await _db.updateParty(party);
      await loadParties();
      return true;
    } catch (e) {
      debugPrint('Error updating party: $e');
      return false;
    }
  }

  Future<bool> deleteParty(String id) async {
    try {
      await _db.deleteParty(id);
      await loadParties();
      return true;
    } catch (e) {
      debugPrint('Error deleting party: $e');
      return false;
    }
  }

  Future<Party?> getPartyById(String id) async {
    return _db.getParty(id);
  }
}
