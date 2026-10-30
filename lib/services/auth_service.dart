import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_service.dart';

/// Service wrapping Firebase Authentication with friendly error handling
/// and session persistence.
class AuthService {
  FirebaseAuth? get _auth {
    if (!FirebaseService.isConfigured) return null;
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  /// Stream of authentication state changes.
  /// Emits the current [User] when signed in, or null when signed out.
  Stream<User?> get authStateChanges {
    final auth = _auth;
    if (auth == null) {
      return Stream<User?>.value(null);
    }
    return auth.authStateChanges();
  }

  /// Currently signed in user, if any.
  User? get currentUser => _auth?.currentUser;

  /// True if a user is currently authenticated.
  bool get isAuthenticated => currentUser != null;

  /// Registers a new user with email and password.
  /// Optionally updates the display name on the Firebase user object.
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final auth = _auth;
    if (auth == null) {
      throw FirebaseAuthException(
        code: 'not-configured',
        message:
            'Firebase is not yet configured. Please run `flutterfire configure`.',
      );
    }

    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (displayName != null && displayName.trim().isNotEmpty) {
        await credential.user?.updateDisplayName(displayName.trim());
        await credential.user?.reload();
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: getFriendlyErrorMessage(e),
      );
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown',
        message:
            'Registration failed. Please check your details and try again.',
      );
    }
  }

  /// Signs in an existing user with email and password.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final auth = _auth;
    if (auth == null) {
      throw FirebaseAuthException(
        code: 'not-configured',
        message:
            'Firebase is not yet configured. Please run `flutterfire configure`.',
      );
    }

    try {
      return await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: getFriendlyErrorMessage(e),
      );
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'Login failed. Please check your network and credentials.',
      );
    }
  }

  /// Sends a password reset email to the specified address.
  Future<void> sendPasswordResetEmail(String email) async {
    final auth = _auth;
    if (auth == null) {
      throw FirebaseAuthException(
        code: 'not-configured',
        message:
            'Firebase is not yet configured. Please run `flutterfire configure`.',
      );
    }

    try {
      await auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: getFriendlyErrorMessage(e),
      );
    }
  }

  /// Signs out the currently authenticated user.
  Future<void> signOut() async {
    final auth = _auth;
    if (auth != null) {
      await auth.signOut();
    }
  }

  /// Translates standard Firebase Auth error codes into clear, friendly guidance.
  static String getFriendlyErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No account exists with this email. Please create an account.';
      case 'wrong-password':
        return 'Incorrect password. Please verify and try again.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check your credentials.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled in Firebase Console.';
      case 'weak-password':
        return 'Password should be at least 6 characters long.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many unsuccessful attempts. Please try again shortly.';
      case 'not-configured':
        return e.message ??
            'Firebase is not yet configured. Please run flutterfire configure.';
      default:
        return e.message ?? 'An unexpected authentication error occurred.';
    }
  }
}
