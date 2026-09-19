import 'package:get/get.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/bill/bill_list_screen.dart';
import '../../screens/bill/create_bill_screen.dart';
import '../../screens/home_shell.dart';
import '../../screens/item/item_form_screen.dart';
import '../../screens/item/item_list_screen.dart';
import '../../screens/party/party_form_screen.dart';
import '../../screens/party/party_list_screen.dart';
import '../../screens/settings/business_profile_screen.dart';
import '../middleware/auth_middleware.dart';
import 'app_routes.dart';

class AppPages {
  static const String initial = AppRoutes.home;

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeShell(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: AppRoutes.parties,
      page: () => const PartyListScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.partyForm,
      page: () => const PartyFormScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.items,
      page: () => const ItemListScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.itemForm,
      page: () => const ItemFormScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.createBill,
      page: () => const CreateBillScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.bills,
      page: () => const BillListScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const BusinessProfileScreen(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
