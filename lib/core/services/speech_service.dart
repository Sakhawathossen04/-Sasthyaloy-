import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../utils/platform_utils.dart';

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
    if (_isInitialized && _speech != null) return true;

    if (kIsWeb || PlatformUtils.isFlutterTest) {
      _isInitialized = true;
      return true;
    }

    try {
      // 1. Explicitly verify & request runtime microphone permission
      final micStatus = await Permission.microphone.status;
      if (!micStatus.isGranted) {
        final reqResult = await Permission.microphone.request();
        if (!reqResult.isGranted) {
          debugPrint('SpeechService: Microphone permission denied by user.');
          return false;
        }
      }

      // 2. Initialize native speech recognizer
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
    if (!ready && !(kIsWeb || PlatformUtils.isFlutterTest)) {
      return false;
    }

    if (kIsWeb || PlatformUtils.isFlutterTest) {
      isListeningNotifier.value = true;
      return true;
    }

    try {
      // Prioritize Bangladesh Bengali or standard English based on device locales
      String? targetLocaleId;
      try {
        final locales = await _speech?.locales();
        if (locales != null && locales.isNotEmpty) {
          if (isBangla) {
            final found = locales.firstWhere(
              (l) => l.localeId.toLowerCase().startsWith('bn'),
              orElse: () => locales.first,
            );
            targetLocaleId = found.localeId;
          } else {
            final found = locales.firstWhere(
              (l) => l.localeId.toLowerCase().startsWith('en'),
              orElse: () => locales.first,
            );
            targetLocaleId = found.localeId;
          }
        }
      } catch (e) {
        debugPrint('SpeechService locales lookup error: $e');
      }

      targetLocaleId ??= (isBangla ? 'bn_BD' : 'en_US');

      await _speech?.listen(
        onResult: (result) {
          recognizedWordsNotifier.value = result.recognizedWords;
          onResult(result.recognizedWords, result.finalResult);
          if (result.finalResult) {
            isListeningNotifier.value = false;
          }
        },
        localeId: targetLocaleId,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
        cancelOnError: false,
        partialResults: true,
        listenMode: ListenMode.confirmation,
      );

      isListeningNotifier.value = true;
      return true;
    } catch (e) {
      debugPrint('SpeechService listen exception: $e');
      // Retry once with device default locale without forcing bn_BD
      try {
        await _speech?.listen(
          onResult: (result) {
            recognizedWordsNotifier.value = result.recognizedWords;
            onResult(result.recognizedWords, result.finalResult);
            if (result.finalResult) {
              isListeningNotifier.value = false;
            }
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 4),
          cancelOnError: false,
          partialResults: true,
        );
        isListeningNotifier.value = true;
        return true;
      } catch (retryError) {
        debugPrint('SpeechService retry failed: $retryError');
        isListeningNotifier.value = false;
        return false;
      }
    }
  }

  /// Stop listening and trigger final processing
  Future<void> stopListening() async {
    if (kIsWeb || PlatformUtils.isFlutterTest) {
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
    if (kIsWeb || PlatformUtils.isFlutterTest) {
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
