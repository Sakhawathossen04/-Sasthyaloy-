import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../features/auth/domain/models/user_profile_model.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const String _keyOnboardingCompleted = 'sasthyaloy_onboarding_completed';
  static const String _keyIsLoggedIn = 'sasthyaloy_is_logged_in';
  static const String _keyUserProfile = 'sasthyaloy_user_profile_json';

  static final Map<String, dynamic> _memoryCache = {};
  static File? _storageFile;

  static Future<void> init() async {
    try {
      _storageFile = _resolveStorageFile();
      if (_storageFile != null && _storageFile!.existsSync()) {
        final content = _storageFile!.readAsStringSync();
        if (content.isNotEmpty) {
          final Map<String, dynamic> data = jsonDecode(content);
          _memoryCache.addAll(data);
        }
      }
    } catch (e) {
      debugPrint('StorageService init error: $e');
    }
  }

  static File _resolveStorageFile() {
    final candidatePaths = [
      '/data/user/0/com.sasthyaloy/files',
      '/data/data/com.sasthyaloy/files',
      '/data/user/0/com.sasthyaloy.sasthyaloy/files',
      '/data/data/com.sasthyaloy.sasthyaloy/files',
    ];

    for (final path in candidatePaths) {
      try {
        final dir = Directory(path);
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }
        final testFile = File('${dir.path}/.test_storage');
        testFile.writeAsStringSync('1');
        testFile.deleteSync();
        return File('${dir.path}/sasthyaloy_storage.json');
      } catch (_) {}
    }

    // Fallback for tests, desktop, temp environments
    try {
      final tempDir = Directory.systemTemp;
      return File('${tempDir.path}/sasthyaloy_storage.json');
    } catch (_) {
      return File('sasthyaloy_storage.json');
    }
  }

  static void _persistToFile() {
    try {
      _storageFile ??= _resolveStorageFile();
      _storageFile?.writeAsStringSync(jsonEncode(_memoryCache));
    } catch (e) {
      debugPrint('StorageService write error: $e');
    }
  }

  static bool hasCompletedOnboarding() {
    return _memoryCache[_keyOnboardingCompleted] as bool? ?? false;
  }

  static Future<void> setCompletedOnboarding(bool completed) async {
    _memoryCache[_keyOnboardingCompleted] = completed;
    _persistToFile();
  }

  static bool getIsLoggedIn() {
    return _memoryCache[_keyIsLoggedIn] as bool? ?? false;
  }

  static Future<void> saveUserProfile(UserProfileModel user) async {
    _memoryCache[_keyIsLoggedIn] = user.isLoggedIn;
    final jsonStr = jsonEncode(user.toJson());
    _memoryCache[_keyUserProfile] = jsonStr;
    _persistToFile();
  }

  static UserProfileModel? loadUserProfile() {
    try {
      final jsonStr = _memoryCache[_keyUserProfile] as String?;
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final Map<String, dynamic> data = jsonDecode(jsonStr);
        return UserProfileModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
    return null;
  }

  static Future<void> clearAuthSession() async {
    _memoryCache[_keyIsLoggedIn] = false;
    _memoryCache.remove(_keyUserProfile);
    _persistToFile();
  }
}
