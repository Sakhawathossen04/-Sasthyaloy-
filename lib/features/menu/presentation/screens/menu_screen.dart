import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../onboarding/presentation/screens/language_selection_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          isBn ? 'মেনু ও সেটিংস' : 'Menu',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Sign In Banner Card
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lock_outline, color: AppColors.primaryNavy, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          isBn ? 'এগিয়ে যেতে সাইন-ইন করুন' : 'Sign in to proceed',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isBn
                          ? 'সকল স্বাস্থ্যসেবা ও ব্যক্তিগত মেডিকেল রেকর্ড দেখতে আপনার একাউন্টে প্রবেশ করুন।'
                          : 'Please sign in to access full services and personal health records.',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 18),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryNavy,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.phone_android_rounded, color: Colors.white),
                        label: Text(
                          isBn ? 'ফোন নম্বর দিয়ে সাইন-ইন' : 'Sign in with Phone OTP',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => _showLoginBottomSheet(context, isBn),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Terms text
                    Center(
                      child: Text(
                        isBn
                            ? 'এগিয়ে যাওয়ার মাধ্যমে আপনি শর্তাবলী ও গোপনীয়তা নীতি মেনে নিচ্ছেন।'
                            : 'By continuing you agree to the Terms & Conditions & Privacy Policy',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 2. Details Section
              _buildSectionHeader(isBn ? 'সেবাসমূহ (Details)' : 'Details'),
              _buildMenuTile(
                title: isBn ? 'প্রাথমিক স্বাস্থ্যসেবা' : 'Primary Care',
                onTap: () {},
              ),

              const SizedBox(height: 20),

              // 3. Manage Section
              _buildSectionHeader(isBn ? 'ব্যবস্থাপনা (Manage)' : 'Manage'),
              _buildMenuTile(
                title: isBn ? 'ভাষা নির্বাচন (Language)' : 'Language',
                trailingText: isBn ? 'বাংলা' : 'English',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
                  );
                },
              ),
              _buildMenuTile(
                title: isBn ? 'অ্যাপ সেটিংস' : 'Settings',
                onTap: () {},
              ),

              const SizedBox(height: 20),

              // 4. Policies & Terms
              _buildSectionHeader(isBn ? 'নীতিমালা ও শর্তাবলী' : 'Policies & Terms'),
              _buildMenuTile(
                title: isBn ? 'স্বাস্থ্যালয় সম্পর্কে' : 'About Sasthyaloy',
                onTap: () {},
              ),
              _buildMenuTile(
                title: isBn ? 'গোপনীয়তা নীতিমালা' : 'Privacy Policy',
                onTap: () {},
              ),

              const SizedBox(height: 20),

              // 5. Get in Touch
              _buildSectionHeader(isBn ? 'যোগাযোগ ও সাপোর্ট' : 'Get in Touch'),
              _buildMenuTile(
                title: isBn ? 'গ্রাহক সহায়তা ও হেল্পলাইন' : 'Support',
                onTap: () {},
              ),

              const SizedBox(height: 32),

              // 6. Footer & Medical Disclaimer
              Center(
                child: Column(
                  children: [
                    Text(
                      'Sasthyaloy v 1.0.0 (30883)\n© 2026 Department of Digital Health. All rights reserved.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        isBn ? AppStrings.disclaimerBn : AppStrings.disclaimerEn,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: const TextStyle(color: AppColors.brandCyan, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(width: 6),
            ],
            const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  void _showLoginBottomSheet(BuildContext context, bool isBn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isBn ? 'স্বাস্থ্যালয়ে সাইন-ইন করুন' : 'Sign in to Sasthyaloy',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
              ),
              const SizedBox(height: 6),
              Text(
                isBn ? 'আপনার ১১ ডিজিটের মোবাইল নম্বরটি লিখুন:' : 'Enter your 11-digit mobile number:',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('+880', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
                        SizedBox(width: 8),
                        VerticalDivider(width: 1, indent: 14, endIndent: 14),
                      ],
                    ),
                  ),
                  hintText: '1700000000',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isBn ? 'ওটিপি কোড পাঠানো হয়েছে।' : 'OTP sent successfully.'),
                        backgroundColor: AppColors.emeraldGreen,
                      ),
                    );
                  },
                  child: Text(
                    isBn ? 'ওটিপি (OTP) কোড পাঠান' : 'Send OTP Code',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
