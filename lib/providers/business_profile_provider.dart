import 'package:flutter/material.dart';
import '../models/business_profile.dart';
import '../services/database_service.dart';

class BusinessProfileProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;
  BusinessProfile _profile = const BusinessProfile();
  bool _isLoading = false;

  BusinessProfile get profile => _profile;
  bool get isLoading => _isLoading;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      _profile = await _db.getBusinessProfile();
    } catch (e) {
      debugPrint('Error loading business profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveProfile(BusinessProfile newProfile) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _db.saveBusinessProfile(newProfile);
      _profile = newProfile;
      return true;
    } catch (e) {
      debugPrint('Error saving business profile: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
