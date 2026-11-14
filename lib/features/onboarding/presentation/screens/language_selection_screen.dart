import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import 'location_permission_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Select your preferred\nlanguage',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'আপনার পছন্দের ভাষা নির্বাচন করুন',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),

              // Bangla Option
              _buildLanguageTile(
                context: context,
                title: 'বাংলা',
                subtitle: 'Bengali',
                isCurrent: AppLocaleController.instance.isBangla,
                onTap: () {
                  AppLocaleController.instance.setLocale(const Locale('bn'));
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LocationPermissionScreen()),
                  );
                },
              ),
              const Divider(height: 1, color: AppColors.borderLight),

              // English Option
              _buildLanguageTile(
                context: context,
                title: 'English',
                subtitle: 'ইংরেজি',
                isCurrent: !AppLocaleController.instance.isBangla,
                onTap: () {
                  AppLocaleController.instance.setLocale(const Locale('en'));
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LocationPermissionScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool isCurrent,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
