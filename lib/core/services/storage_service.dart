import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/domain/models/user_profile_model.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const String _keyOnboardingCompleted = 'sasthyaloy_onboarding_completed';
  static const String _keyIsLoggedIn = 'sasthyaloy_is_logged_in';
  static const String _keyUserProfile = 'sasthyaloy_user_profile_json';

  static SharedPreferences? _prefs;
  static final Map<String, dynamic> _memoryCache = {};

  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('StorageService SharedPreferences fallback to memory cache: $e');
    }
  }

  static bool hasCompletedOnboarding() {
    if (_prefs != null) {
      return _prefs!.getBool(_keyOnboardingCompleted) ?? false;
    }
    return _memoryCache[_keyOnboardingCompleted] as bool? ?? false;
  }

  static Future<void> setCompletedOnboarding(bool completed) async {
    _memoryCache[_keyOnboardingCompleted] = completed;
    try {
      await _prefs?.setBool(_keyOnboardingCompleted, completed);
    } catch (e) {
      debugPrint('Error saving onboarding state: $e');
    }
  }

  static bool getIsLoggedIn() {
    if (_prefs != null) {
      return _prefs!.getBool(_keyIsLoggedIn) ?? false;
    }
    return _memoryCache[_keyIsLoggedIn] as bool? ?? false;
  }

  static Future<void> saveUserProfile(UserProfileModel user) async {
    _memoryCache[_keyIsLoggedIn] = user.isLoggedIn;
    final jsonStr = jsonEncode(user.toJson());
    _memoryCache[_keyUserProfile] = jsonStr;

    try {
      await _prefs?.setBool(_keyIsLoggedIn, user.isLoggedIn);
      await _prefs?.setString(_keyUserProfile, jsonStr);
    } catch (e) {
      debugPrint('Error saving user profile to storage: $e');
    }
  }

  static UserProfileModel? loadUserProfile() {
    try {
      String? jsonStr;
      if (_prefs != null) {
        jsonStr = _prefs!.getString(_keyUserProfile);
      }
      jsonStr ??= _memoryCache[_keyUserProfile] as String?;

      if (jsonStr != null && jsonStr.isNotEmpty) {
        final Map<String, dynamic> data = jsonDecode(jsonStr);
        return UserProfileModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('Error loading user profile from storage: $e');
    }
    return null;
  }

  static Future<void> clearAuthSession() async {
    _memoryCache[_keyIsLoggedIn] = false;
    _memoryCache.remove(_keyUserProfile);
    try {
      await _prefs?.setBool(_keyIsLoggedIn, false);
      await _prefs?.remove(_keyUserProfile);
    } catch (e) {
      debugPrint('Error clearing auth session: $e');
    }
  }
}
