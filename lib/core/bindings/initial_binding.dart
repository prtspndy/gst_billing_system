import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/bill_controller.dart';
import '../../controllers/business_profile_controller.dart';
import '../../controllers/item_controller.dart';
import '../../controllers/party_controller.dart';
import '../theme/theme_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<BusinessProfileController>(BusinessProfileController(), permanent: true);
    Get.put<PartyController>(PartyController(), permanent: true);
    Get.put<ItemController>(ItemController(), permanent: true);
    Get.put<BillController>(BillController(), permanent: true);
  }
}
