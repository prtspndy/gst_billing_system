import 'package:get/get.dart';
import '../models/business_profile.dart';
import '../services/database_service.dart';

class BusinessProfileController extends GetxController {
  final DatabaseService _db = DatabaseService.instance;

  final Rx<BusinessProfile> profile = const BusinessProfile().obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final p = await _db.getBusinessProfile();
      profile.value = p;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveProfile(BusinessProfile newProfile) async {
    isLoading.value = true;
    try {
      await _db.saveBusinessProfile(newProfile);
      profile.value = newProfile;
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
