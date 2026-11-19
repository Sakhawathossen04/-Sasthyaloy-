import 'dart:io';
import 'package:flutter/foundation.dart';

/// Platform utility helper to safely detect runtime environment
/// without throwing UnsupportedError on Android or iOS devices.
class PlatformUtils {
  PlatformUtils._();

  /// Safely check whether the code is executing within a Flutter test runner.
  /// On Android and iOS, Platform.environment is unsupported and throws UnsupportedError.
  /// This getter safely catches any errors and returns false on mobile devices.
  static bool get isFlutterTest {
    if (kIsWeb) return false;
    try {
      return Platform.environment.containsKey('FLUTTER_TEST');
    } catch (_) {
      return false;
    }
  }
}
