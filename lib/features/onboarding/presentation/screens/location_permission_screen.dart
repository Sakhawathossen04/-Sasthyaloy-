import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import 'onboarding_carousel_screen.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F3E6D), Color(0xFF0A2E52), Color(0xFF061E36)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Language Switcher Pill
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      AppLocaleController.instance.toggleLanguage();
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.language, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            isBn ? 'English' : 'বাংলা',
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Big Location Graphic
                Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.25), width: 8),
                      color: Colors.white.withOpacity(0.08),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 72,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Title
                Text(
                  isBn 
                      ? 'আপনার অবস্থান আমাদের দ্রুত সেবা দিতে সাহায্য করে'
                      : 'Your location helps us\nserve you better',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  isBn ? 'লোকেশন সুবিধা অন করলে:' : 'Enable location to:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 16),

                // Bullets
                _buildBullet(
                  isBn 
                      ? 'নিকটস্থ হাসপাতাল ও স্বাস্থ্যকেন্দ্র খুঁজে পাবেন।'
                      : 'Find nearby healthcare facilities.',
                ),
                _buildBullet(
                  isBn 
                      ? 'দূরত্ব ও দ্রুততম পৌঁছানোর ম্যাপ ন্যাভিগেশন পাবেন।'
                      : 'Navigate easily with distance information.',
                ),
                _buildBullet(
                  isBn 
                      ? 'আপনার স্বাস্থ্য তথ্য সম্পূর্ণ নিরাপদ ও সুরক্ষিত থাকবে।'
                      : 'Your data stays secure for personalised recommendations.',
                ),

                const Spacer(),

                // Proceed Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryNavy,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const OnboardingCarouselScreen()),
                      );
                    },
                    child: Text(
                      isBn ? 'এগিয়ে যান (Proceed)' : 'Proceed',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Skip for now
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const OnboardingCarouselScreen()),
                      );
                    },
                    child: Text(
                      isBn ? 'এখন বাদ দিন (Skip for Now)' : 'Skip for Now',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 12),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.brandCyan,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
