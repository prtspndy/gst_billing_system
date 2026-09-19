import 'package:get/get.dart';
import '../models/item.dart';
import '../services/database_service.dart';

class ItemController extends GetxController {
  final DatabaseService _db = DatabaseService.instance;

  final RxList<Item> _allItems = <Item>[].obs;
  final RxList<Item> _filteredItems = <Item>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  List<Item> get items => searchQuery.isEmpty ? _allItems : _filteredItems;

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  Future<void> loadItems() async {
    isLoading.value = true;
    try {
      final list = await _db.getItems();
      _allItems.assignAll(list);
      _applySearch();
    } finally {
      isLoading.value = false;
    }
  }

  void searchItems(String query) {
    searchQuery.value = query.trim().toLowerCase();
    _applySearch();
  }

  void _applySearch() {
    if (searchQuery.isEmpty) {
      _filteredItems.clear();
    } else {
      final q = searchQuery.value;
      _filteredItems.assignAll(
        _allItems.where((i) {
          final nameMatch = i.name.toLowerCase().contains(q);
          final hsnMatch = (i.hsnCode ?? '').toLowerCase().contains(q);
          return nameMatch || hsnMatch;
        }),
      );
    }
  }

  Future<bool> addItem(Item item) async {
    try {
      await _db.insertItem(item);
      await loadItems();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateItem(Item item) async {
    try {
      await _db.updateItem(item);
      await loadItems();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteItem(String id) async {
    try {
      await _db.deleteItem(id);
      await loadItems();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Item?> getItemById(String id) async {
    return _db.getItem(id);
  }
}
