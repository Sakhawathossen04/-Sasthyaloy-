import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service dedicated to handling emergency phone calls and native dialer actions.
class EmergencyCallService {
  EmergencyCallService._();
  static final EmergencyCallService instance = EmergencyCallService._();

  /// Clean raw phone number (removes dashes, spaces, brackets, but retains leading +)
  static String cleanPhoneNumber(String rawNumber) {
    final trimmed = rawNumber.trim();
    final hasPlus = trimmed.startsWith('+');
    final digits = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
    return hasPlus ? '+$digits' : digits;
  }

  /// Launch the native phone dialer with prefilled number.
  /// Uses LaunchMode.externalApplication so that the phone dialer app opens
  /// directly with the number loaded onto the keypad.
  Future<bool> launchDialer(String phoneNumber) async {
    final clean = cleanPhoneNumber(phoneNumber);
    if (clean.isEmpty) return false;

    final Uri dialUri = Uri(
      scheme: 'tel',
      path: clean,
    );

    try {
      // 1. Try launching in external application (native phone dialer)
      final launched = await launchUrl(
        dialUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        // 2. Fallback to platform default launch mode
        return await launchUrl(dialUri);
      }
      return launched;
    } catch (e) {
      debugPrint('EmergencyCallService: Failed to launch dialer: $e');
      try {
        return await launchUrl(dialUri);
      } catch (inner) {
        debugPrint('EmergencyCallService: Fallback launch failed: $inner');
        return false;
      }
    }
  }

  /// Open dialer for emergency call, and notify user if dialer could not be reached.
  Future<void> makeEmergencyCall({
    required BuildContext context,
    required String phoneNumber,
    required bool isBangla,
  }) async {
    final success = await launchDialer(phoneNumber);
    if (!context.mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Text(
            isBangla
                ? 'ডায়াল প্যাড চালু করা যায়নি। অনুগ্রহ করে ম্যানুয়ালি $phoneNumber নম্বরে কল করুন।'
                : 'Could not open phone dialer. Please call $phoneNumber manually.',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
