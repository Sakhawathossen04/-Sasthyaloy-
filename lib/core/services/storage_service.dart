import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../features/auth/domain/models/user_profile_model.dart';
import '../../features/voice_ai/domain/models/symptom_triage_model.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const String _keyOnboardingCompleted = 'sasthyaloy_onboarding_completed';
  static const String _keyIsLoggedIn = 'sasthyaloy_is_logged_in';
  static const String _keyUserProfile = 'sasthyaloy_user_profile_json';

  static final Map<String, dynamic> _memoryCache = {};
  static File? _storageFile;

  static bool get _isTestEnv {
    try {
      return Platform.environment.containsKey('FLUTTER_TEST');
    } catch (_) {
      return false;
    }
  }

  static Future<void> init() async {
    if (kIsWeb || _isTestEnv) return;
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

  static File? _resolveStorageFile() {
    if (kIsWeb || _isTestEnv) return null;

    try {
      if (Platform.isAndroid) {
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
      }

      // Fallback for desktop / other environments
      final tempDir = Directory.systemTemp;
      return File('${tempDir.path}/sasthyaloy_storage.json');
    } catch (_) {
      return null;
    }
  }

  static void _persistToFile() {
    if (kIsWeb || _isTestEnv) return;
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

  // --- Persistent Chat Session Storage (OpenAI / Gemini style) ---
  static const String _keyChatSessions = 'sasthyaloy_chat_sessions_json';

  static List<ChatSessionModel> getChatSessions() {
    final raw = _memoryCache[_keyChatSessions];
    if (raw == null) return [];
    try {
      if (raw is List) {
        return raw
            .map((e) => ChatSessionModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      } else if (raw is String && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        return decoded
            .map((e) => ChatSessionModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    } catch (e) {
      debugPrint('Error reading chat sessions: $e');
    }
    return [];
  }

  static Future<void> saveChatSession(ChatSessionModel session) async {
    final sessions = getChatSessions();
    final idx = sessions.indexWhere((s) => s.id == session.id);
    if (idx >= 0) {
      sessions[idx] = session;
    } else {
      sessions.insert(0, session);
    }
    _memoryCache[_keyChatSessions] = sessions.map((s) => s.toJson()).toList();
    _persistToFile();
  }

  static Future<void> deleteChatSession(String sessionId) async {
    final sessions = getChatSessions();
    sessions.removeWhere((s) => s.id == sessionId);
    _memoryCache[_keyChatSessions] = sessions.map((s) => s.toJson()).toList();
    _persistToFile();
  }

  static Future<void> clearAllChatSessions() async {
    _memoryCache.remove(_keyChatSessions);
    _persistToFile();
  }
}
