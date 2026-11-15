import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import 'location_permission_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool isFromSettings;
  const LanguageSelectionScreen({super.key, this.isFromSettings = false});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late String _selectedLocale;

  @override
  void initState() {
    super.initState();
    _selectedLocale = AppLocaleController.instance.isBangla ? 'bn' : 'en';
  }

  void _onSelectLanguage(String code) {
    setState(() {
      _selectedLocale = code;
    });
    AppLocaleController.instance.setLocale(Locale(code));
  }

  void _proceed() {
    if (widget.isFromSettings) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LocationPermissionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBn = _selectedLocale == 'bn';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: widget.isFromSettings,
        leading: widget.isFromSettings
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primaryNavy),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        actions: [
          TextButton(
            onPressed: _proceed,
            child: Text(
              widget.isFromSettings
                  ? (isBn ? 'সংরক্ষণ' : 'Save')
                  : (isBn ? 'এগিয়ে যান' : 'Skip'),
              style: const TextStyle(
                color: AppColors.brandCyan,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Brand Icon Badge
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primaryNavy.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.translate_rounded,
                  color: AppColors.primaryNavy,
                  size: 28,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                isBn
                    ? 'আপনার পছন্দের ভাষা\nনির্বাচন করুন'
                    : 'Select your preferred\nlanguage',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isBn
                    ? 'আপনি যেকোনো সময় সেটিংস থেকে ভাষা পরিবর্তন করতে পারবেন।'
                    : 'You can change your language anytime in app settings.',
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),

              // Bangla Option Card
              _buildLanguageCard(
                code: 'bn',
                primaryTitle: 'বাংলা',
                secondaryTitle: 'Bengali (Default)',
                flagEmoji: '🇧🇩',
                isSelected: _selectedLocale == 'bn',
              ),

              const SizedBox(height: 16),

              // English Option Card
              _buildLanguageCard(
                code: 'en',
                primaryTitle: 'English',
                secondaryTitle: 'ইংরেজি (International)',
                flagEmoji: '🌐',
                isSelected: _selectedLocale == 'en',
              ),

              const Spacer(),

              // Proceed Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNavy,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _proceed,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.isFromSettings
                            ? (isBn ? 'সংরক্ষণ করুন' : 'Save Preference')
                            : (isBn ? 'নিশ্চিত করুন ও এগিয়ে যান' : 'Confirm & Proceed'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required String code,
    required String primaryTitle,
    required String secondaryTitle,
    required String flagEmoji,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => _onSelectLanguage(code),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F7FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.brandCyan : AppColors.borderLight,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.brandCyan.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.brandCyan.withOpacity(0.15)
                    : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  flagEmoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    primaryTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? AppColors.primaryNavy : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    secondaryTitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.brandCyan : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.brandCyan : AppColors.borderLight,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
