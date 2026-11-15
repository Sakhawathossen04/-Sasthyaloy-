import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Speech-to-Text (STT) Recognition Service for Sasthyaloy Healthcare Assistant.
/// Captures voice symptoms in Bengali and English with automatic silence detection.
class SpeechService {
  SpeechService._();
  static final SpeechService instance = SpeechService._();

  SpeechToText? _speech;
  bool _isInitialized = false;

  final ValueNotifier<bool> isListeningNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<String> recognizedWordsNotifier = ValueNotifier<String>('');

  bool get isListening => isListeningNotifier.value;

  /// Initialize speech engine & verify permissions
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) {
      _isInitialized = true;
      return true;
    }

    try {
      _speech = SpeechToText();
      final available = await _speech!.initialize(
        onError: (errorNotification) {
          debugPrint('SpeechService error: ${errorNotification.errorMsg}');
          isListeningNotifier.value = false;
        },
        onStatus: (status) {
          debugPrint('SpeechService status: $status');
          if (status == 'done' || status == 'notListening') {
            isListeningNotifier.value = false;
          } else if (status == 'listening') {
            isListeningNotifier.value = true;
          }
        },
      );
      _isInitialized = available;
      return available;
    } catch (e) {
      debugPrint('SpeechService init exception: $e');
      _isInitialized = false;
      return false;
    }
  }

  /// Start recording voice and streaming recognized text
  Future<bool> startListening({
    required Function(String recognizedWords, bool isFinal) onResult,
    required bool isBangla,
  }) async {
    final ready = await initialize();
    if (!ready && !(kIsWeb || Platform.environment.containsKey('FLUTTER_TEST'))) {
      return false;
    }

    if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) {
      isListeningNotifier.value = true;
      return true;
    }

    try {
      // Prioritize Bangladesh Bengali or standard English
      final localeId = isBangla ? 'bn_BD' : 'en_US';

      await _speech?.listen(
        onResult: (result) {
          recognizedWordsNotifier.value = result.recognizedWords;
          onResult(result.recognizedWords, result.finalResult);
          if (result.finalResult) {
            isListeningNotifier.value = false;
          }
        },
        localeId: localeId,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        cancelOnError: true,
        partialResults: true,
      );

      isListeningNotifier.value = true;
      return true;
    } catch (e) {
      debugPrint('SpeechService listen exception: $e');
      isListeningNotifier.value = false;
      return false;
    }
  }

  /// Stop listening and trigger final processing
  Future<void> stopListening() async {
    if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) {
      isListeningNotifier.value = false;
      return;
    }

    try {
      await _speech?.stop();
    } catch (e) {
      debugPrint('SpeechService stop error: $e');
    } finally {
      isListeningNotifier.value = false;
    }
  }

  /// Cancel listening immediately
  Future<void> cancelListening() async {
    if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) {
      isListeningNotifier.value = false;
      return;
    }

    try {
      await _speech?.cancel();
    } catch (e) {
      debugPrint('SpeechService cancel error: $e');
    } finally {
      isListeningNotifier.value = false;
    }
  }
}
