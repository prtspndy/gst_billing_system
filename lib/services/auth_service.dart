import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Service managing Firebase Authentication and Google Sign-In,
/// modeled after the reference Firebase Authentication implementation.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream of user authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Current Firebase user.
  User? get currentUser => _auth.currentUser;

  /// Indicates if Google Sign-In is supported on current platform.
  /// Supported on Android, iOS, and Web.
  static bool get isGoogleSignInSupported {
    if (kIsWeb) return true;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Sign in with email and password.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Register a new user with email and password.
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Sign in with Google (Android, iOS, Web).
  Future<UserCredential?> signInWithGoogle() async {
    if (!isGoogleSignInSupported) {
      throw UnsupportedError('Google Sign-In is not supported on this platform.');
    }

    if (kIsWeb) {
      final googleProvider = GoogleAuthProvider();
      return await _auth.signInWithPopup(googleProvider);
    } else {
      await GoogleSignIn.instance.initialize();
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    }
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    if (isGoogleSignInSupported && !kIsWeb) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {
        // Ignore Google sign-out failures
      }
    }
    await _auth.signOut();
  }

  // --- Validation Helpers ---

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }
    if (!_emailRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  // --- Error Translation ---

  static String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'The email address is invalid.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'user-not-found':
          return 'No account found with this email address.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'invalid-credential':
          return 'Invalid email or password. Please verify your credentials.';
        case 'email-already-in-use':
          return 'An account already exists with this email address.';
        case 'operation-not-allowed':
          return 'This sign-in method is currently not enabled.';
        case 'weak-password':
          return 'The password is too weak. Please use at least 6 characters.';
        case 'too-many-requests':
          return 'Too many attempts. Access temporarily disabled. Please try again later.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'account-exists-with-different-credential':
          return 'An account already exists with the same email using a different sign-in method.';
        case 'credential-already-in-use':
          return 'This credential is already linked to another user account.';
        case 'popup-closed-by-user':
          return 'Google sign-in popup was closed before completing.';
        case 'cancelled':
          return 'Sign-in was cancelled.';
        default:
          return error.message ?? 'Authentication failed. Please check your information.';
      }
    }

    if (error is GoogleSignInException) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return 'Google sign-in was cancelled.';
      }
      return 'Google sign-in failed. Please check your configuration and network.';
    }

    if (error is PlatformException) {
      return error.message ?? 'A platform error occurred. Please try again.';
    }

    if (error is FirebaseException) {
      return error.message ?? 'A Firebase error occurred. Please try again.';
    }

    return 'An unexpected error occurred. Please try again.';
  }
}
