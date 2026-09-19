import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/database_service.dart';

class ItemProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;

  List<Item> _items = [];
  List<Item> _filteredItems = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<Item> get items => _searchQuery.isEmpty ? _items : _filteredItems;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await _db.getItems();
      _applySearch();
    } catch (e) {
      debugPrint('Error loading items: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchItems(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredItems = [];
    } else {
      _filteredItems = _items.where((item) {
        final nameMatch = item.name.toLowerCase().contains(_searchQuery);
        final hsnMatch = (item.hsnCode ?? '').toLowerCase().contains(_searchQuery);
        return nameMatch || hsnMatch;
      }).toList();
    }
  }

  Future<bool> addItem(Item item) async {
    try {
      await _db.insertItem(item);
      await loadItems();
      return true;
    } catch (e) {
      debugPrint('Error adding item: $e');
      return false;
    }
  }

  Future<bool> updateItem(Item item) async {
    try {
      await _db.updateItem(item);
      await loadItems();
      return true;
    } catch (e) {
      debugPrint('Error updating item: $e');
      return false;
    }
  }

  Future<bool> deleteItem(String id) async {
    try {
      await _db.deleteItem(id);
      await loadItems();
      return true;
    } catch (e) {
      debugPrint('Error deleting item: $e');
      return false;
    }
  }

  Future<Item?> getItemById(String id) async {
    return _db.getItem(id);
  }
}
