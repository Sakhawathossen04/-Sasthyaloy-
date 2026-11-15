import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../navigation/presentation/screens/main_shell_screen.dart';

class OnboardingCarouselScreen extends StatefulWidget {
  const OnboardingCarouselScreen({super.key});

  @override
  State<OnboardingCarouselScreen> createState() => _OnboardingCarouselScreenState();
}

class _OnboardingCarouselScreenState extends State<OnboardingCarouselScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _finishOnboarding() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShellScreen()),
      (route) => false,
    );
  }

  void _nextPage(int totalSlides) {
    if (_currentPage < totalSlides - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    final List<Map<String, dynamic>> slides = [
      {
        'titleBn': 'সহজে ও নিরাপদে সেরা স্বাস্থ্যসেবা গ্রহণ করুন',
        'titleEn': 'Easily and simply access quality healthcare. Get started now',
        'subtitleBn': 'ডিজিটাল হাসপাতাল, সার্বক্ষণিক সহায়তা ও বিশেষজ্ঞ চিকিৎসকের পরামর্শ এক ঠিকানায়।',
        'subtitleEn': 'Digital healthcare, 24/7 support and verified specialist advice at your fingertips.',
        'icon': Icons.local_hospital_rounded,
        'badgeText': isBn ? 'বিশ্বস্ত সেবা' : 'Verified Care',
        'accent': AppColors.brandCyan,
      },
      {
        'titleBn': 'পছন্দের চিকিৎসকের সাথে সরাসরি বা ভিডিও কনসাল্টেশন',
        'titleEn': 'Book virtual or in-person consultations with your doctor',
        'subtitleBn': 'সিরিয়াল বা দীর্ঘ লাইনে অপেক্ষা ছাড়াই দ্রুত অ্যাপয়েন্টমেন্ট বুক করুন সহজে।',
        'subtitleEn': 'Schedule consultations effortlessly, in-person or via secure HD video calling.',
        'icon': Icons.video_call_rounded,
        'badgeText': isBn ? 'টেলিমেডিসিন' : 'Teleconsultation',
        'accent': AppColors.emeraldGreen,
      },
      {
        'titleBn': 'সকল মেডিকেল ও ল্যাব রিপোর্ট সুরক্ষিত রাখুন এক ঠিকানায়',
        'titleEn': 'Securely access your medical records in one place',
        'subtitleBn': 'ল্যাব টেস্ট, প্রেসক্রিপশন ও ভাইটাল হিস্ট্রি সবসময় আপনার হাতের মুঠোয়।',
        'subtitleEn': 'Instant access to clinical records, prescriptions and encrypted health reports.',
        'icon': Icons.folder_shared_rounded,
        'badgeText': isBn ? 'ডিজিটাল রেকর্ড' : 'Smart EHR',
        'accent': const Color(0xFF38BDF8),
      },
    ];

    final isLastPage = _currentPage == slides.length - 1;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F3E6D), Color(0xFF0B2D4F), Color(0xFF061A2E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Action Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _finishOnboarding,
                      child: Text(
                        isBn ? 'বাদ দিন' : 'Skip',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
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
                          color: Colors.white.withOpacity(0.12),
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Page Slider
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: slides.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Graphic Display Box
                          Container(
                            width: 230,
                            height: 270,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(color: Colors.white.withOpacity(0.16)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (slide['accent'] as Color).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    slide['badgeText'] as String,
                                    style: TextStyle(
                                      color: slide['accent'] as Color,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                CircleAvatar(
                                  radius: 54,
                                  backgroundColor:
                                      (slide['accent'] as Color).withOpacity(0.2),
                                  child: Icon(
                                    slide['icon'] as IconData,
                                    size: 56,
                                    color: slide['accent'] as Color,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Skeleton bars for aesthetic modern look
                                Container(
                                  width: 140,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 90,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 38),

                          // Heading
                          Text(
                            isBn ? slide['titleBn'] : slide['titleEn'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Subtitle
                          Text(
                            isBn ? slide['subtitleBn'] : slide['subtitleEn'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.82),
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Pagination Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(slides.length, (index) {
                  final isActive = _currentPage == index;
                  return InkWell(
                    onTap: () {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.white : Colors.white.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),

              // Bottom Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryNavy,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => _nextPage(slides.length),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLastPage
                              ? (isBn ? 'শুরু করুন (Start Now)' : 'Start Now')
                              : (isBn ? 'পরবর্তী (Next)' : 'Next'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isLastPage
                              ? Icons.check_circle_outline
                              : Icons.arrow_forward_rounded,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
