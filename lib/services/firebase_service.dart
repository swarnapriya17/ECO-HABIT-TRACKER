import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

/// Manages Firebase core initialization and availability detection.
class FirebaseService {
  static bool _isConfigured = false;

  /// Returns true if Firebase has been initialized successfully.
  static bool get isConfigured => _isConfigured || Firebase.apps.isNotEmpty;

  /// Attempts to initialize Firebase.
  /// Uses DefaultFirebaseOptions.currentPlatform when available,
  /// and catches any platform/configuration exceptions gracefully
  /// so that non-configured platforms or widget tests can run smoothly.
  static Future<bool> initialize() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        _isConfigured = true;
        return true;
      }

      // Initialize with platform-specific FirebaseOptions
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isConfigured = true;
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          'FirebaseService: Firebase initialization skipped or options missing for this platform.\n'
          'Details: $e',
        );
      }
      _isConfigured = false;
      return false;
    }
  }
}
