import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Text-to-Speech (TTS) Service for Sasthyaloy AI Healthcare Assistant.
/// Delivers natural, clinical-grade voice output in Bengali and English.
class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;

  /// Reactive Notifiers for UI listening state
  final ValueNotifier<bool> isPlayingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<String?> currentMessageIdNotifier = ValueNotifier<String?>(null);

  bool get isPlaying => isPlayingNotifier.value;
  String? get currentSpeakingId => currentMessageIdNotifier.value;

  /// Initialize TTS engine safely
  Future<void> _init() async {
    if (_isInitialized) return;

    // Unit test / headless environment guard
    if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) {
      _isInitialized = true;
      return;
    }

    try {
      _flutterTts = FlutterTts();
      await _flutterTts?.setSpeechRate(0.48);
      await _flutterTts?.setVolume(1.0);
      await _flutterTts?.setPitch(1.0);

      _flutterTts?.setStartHandler(() {
        isPlayingNotifier.value = true;
      });

      _flutterTts?.setCompletionHandler(() {
        isPlayingNotifier.value = false;
        currentMessageIdNotifier.value = null;
      });

      _flutterTts?.setCancelHandler(() {
        isPlayingNotifier.value = false;
        currentMessageIdNotifier.value = null;
      });

      _flutterTts?.setErrorHandler((dynamic err) {
        debugPrint('TtsService playback error: $err');
        isPlayingNotifier.value = false;
        currentMessageIdNotifier.value = null;
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint('TtsService init exception: $e');
      _isInitialized = false;
    }
  }

  /// Speak a given message in the selected language.
  /// If the same message is already speaking, this will stop playback.
  Future<void> toggleSpeak({
    required String messageId,
    required String text,
    required bool isBangla,
  }) async {
    await _init();

    // If currently speaking this message, stop it
    if (isPlayingNotifier.value && currentMessageIdNotifier.value == messageId) {
      await stop();
      return;
    }

    // If speaking a different message, stop first
    if (isPlayingNotifier.value) {
      await stop();
    }

    // In unit test environment
    if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) {
      currentMessageIdNotifier.value = messageId;
      isPlayingNotifier.value = true;
      return;
    }

    try {
      final cleanText = cleanTextForSpeech(text);
      if (cleanText.isEmpty) return;

      currentMessageIdNotifier.value = messageId;
      isPlayingNotifier.value = true;

      // Select locale based on app language
      final langCode = isBangla ? 'bn-BD' : 'en-US';
      await _flutterTts?.setLanguage(langCode);
      await _flutterTts?.speak(cleanText);
    } catch (e) {
      debugPrint('TtsService speak exception: $e');
      isPlayingNotifier.value = false;
      currentMessageIdNotifier.value = null;
    }
  }

  /// Stop any active speech playback
  Future<void> stop() async {
    if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) {
      isPlayingNotifier.value = false;
      currentMessageIdNotifier.value = null;
      return;
    }

    try {
      await _flutterTts?.stop();
    } catch (e) {
      debugPrint('TtsService stop error: $e');
    } finally {
      isPlayingNotifier.value = false;
      currentMessageIdNotifier.value = null;
    }
  }

  /// Strips markdown symbols, asterisks, bullet points and formatting
  /// to ensure natural spoken speech.
  static String cleanTextForSpeech(String raw) {
    var text = raw;
    // Remove markdown headers
    text = text.replaceAll(RegExp(r'#+\s*'), '');
    // Remove bold, italics, code blocks
    text = text.replaceAll(RegExp(r'\*\*|\*|__|_|`'), '');
    // Clean markdown links [label](url) -> label
    text = text.replaceAll(RegExp(r'\[([^\]]+)\]\([^\)]+\)'), r'$1');
    // Clean bullet list markers
    text = text.replaceAll(RegExp(r'^[•\-\*]\s*', multiLine: true), '');
    // Replace multiple newlines or spaces with single space
    text = text.replaceAll(RegExp(r'\n+'), ' ');
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    return text.trim();
  }
}
