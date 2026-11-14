import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import 'onboarding_carousel_screen.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isRequesting = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _proceedDirectly() {
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const OnboardingCarouselScreen()),
    );
  }

  Future<void> _handleLocationPermission() async {
    final isBn = AppLocaleController.instance.isBangla;
    setState(() => _isRequesting = true);

    // Realistic brief simulated geolocation detection
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryNavy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.emeraldGreen, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isBn
                    ? 'অবস্থান নিশ্চিত করা হয়েছে: ঢাকা, বাংলাদেশ'
                    : 'Location confirmed: Dhaka, Bangladesh',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 1400),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _isRequesting = false);
      _proceedDirectly();
    }
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row with Skip & Language
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _proceedDirectly,
                      child: Text(
                        isBn ? 'বাদ দিন' : 'Skip',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          AppLocaleController.instance.toggleLanguage();
                        });
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Animated Pulsing Location Graphic
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pulsing outer halo
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.brandCyan.withOpacity(0.12),
                          ),
                        ),
                      ),
                      // Middle ring
                      Container(
                        width: 135,
                        height: 135,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                            width: 6,
                          ),
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      // Core pin icon
                      Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.brandCyan,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Title
                Text(
                  isBn
                      ? 'আপনার অবস্থান আমাদের দ্রুত সেবা দিতে সাহায্য করে'
                      : 'Your location helps us\nserve you better',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  isBn ? 'লোকেশন সুবিধা অন করলে আপনি যা পাবেন:' : 'Enable location to:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
                const SizedBox(height: 14),

                // Feature Bullets
                _buildBullet(
                  Icons.near_me_outlined,
                  isBn
                      ? 'নিকটস্থ বিশেষজ্ঞ হাসপাতাল ও অ্যাম্বুলেন্স সেবা শনাক্তকরণ।'
                      : 'Find nearby specialist hospitals and emergency facilities.',
                ),
                const SizedBox(height: 10),
                _buildBullet(
                  Icons.directions_car_outlined,
                  isBn
                      ? 'হাসপাতালে পৌঁছানোর সঠিক দূরত্ব ও আনুমানিক সময় গণনা।'
                      : 'Accurate distance calculation and travel estimation.',
                ),
                const SizedBox(height: 10),
                _buildBullet(
                  Icons.verified_user_outlined,
                  isBn
                      ? 'আপনার স্বাস্থ্য ও অবস্থান তথ্য শতভাগ গোপন ও নিরাপদ থাকে।'
                      : 'Your location is strictly encrypted and privately held.',
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
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _isRequesting ? null : _handleLocationPermission,
                    child: _isRequesting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.primaryNavy,
                            ),
                          )
                        : Text(
                            isBn ? 'এগিয়ে যান (Proceed)' : 'Proceed',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 10),

                // Skip for now Text Button
                Center(
                  child: TextButton(
                    onPressed: _proceedDirectly,
                    child: Text(
                      isBn ? 'আপাতত বাদ দিন (Skip for now)' : 'Skip for now',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.75),
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

  Widget _buildBullet(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.brandCyan,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.5,
              color: Colors.white.withOpacity(0.85),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
