import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  bool get isAuthenticated => user.value != null;
  User? get currentUser => user.value;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_authService.authStateChanges);
  }

  Future<bool> signInWithEmail(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _authService.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      errorMessage.value = AuthService.getErrorMessage(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> registerWithEmail(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _authService.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      errorMessage.value = AuthService.getErrorMessage(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signInWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final credential = await _authService.signInWithGoogle();
      return credential != null;
    } catch (e) {
      errorMessage.value = AuthService.getErrorMessage(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    isLoading.value = true;
    try {
      await _authService.signOut();
    } finally {
      isLoading.value = false;
    }
  }
}
