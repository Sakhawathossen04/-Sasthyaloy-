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

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    final List<Map<String, dynamic>> slides = [
      {
        'titleBn': 'সহজে ও নিরাপদে সেরা স্বাস্থ্যসেবা গ্রহণ করুন',
        'titleEn': 'Easily and simply access quality healthcare. Get started now',
        'subtitleBn': 'ডিজিটাল হাসপাতাল, সার্বক্ষণিক সহায়তা ও বিশেষজ্ঞ চিকিৎসকের পরামর্শ।',
        'subtitleEn': 'Digital healthcare, 24/7 support and verified specialist advice.',
        'icon': Icons.local_hospital_rounded,
        'accent': AppColors.brandCyan,
      },
      {
        'titleBn': 'পছন্দের চিকিৎসকের সাথে সরাসরি বা ভিডিও কনসাল্টেশন',
        'titleEn': 'Book virtual or in-person consultations with your doctor',
        'subtitleBn': 'অ্যাপয়েন্টমেন্ট নিন কোনো ভোগান্তি ছাড়াই, সরাসরি বা অনলাইনের মাধ্যমে।',
        'subtitleEn': 'Schedule consultations effortlessly, in-person or via secure video call.',
        'icon': Icons.video_call_rounded,
        'accent': AppColors.emeraldGreen,
      },
      {
        'titleBn': 'সকল মেডিকেল ও ল্যাব রিপোর্ট সুরক্ষিত রাখুন এক ঠিকানায়',
        'titleEn': 'Securely access your medical records in one place',
        'subtitleBn': 'ল্যাব টেস্ট, প্রেসক্রিপশন ও ভাইটাল হিস্ট্রি যেকোনো সময় দেখার সুযোগ।',
        'subtitleEn': 'Instant access to lab results, prescriptions and clinical history.',
        'icon': Icons.folder_shared_rounded,
        'accent': Color(0xFF38BDF8),
      },
    ];

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
              // Language Switcher Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
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
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
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
                          // Illustration container
                          Container(
                            width: 220,
                            height: 280,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white.withOpacity(0.15)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 54,
                                  backgroundColor: (slide['accent'] as Color).withOpacity(0.2),
                                  child: Icon(
                                    slide['icon'] as IconData,
                                    size: 54,
                                    color: slide['accent'] as Color,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  width: 140,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: 100,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),

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
                              color: Colors.white.withOpacity(0.8),
                              height: 1.4,
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
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.white.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Start Now Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryNavy,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const MainShellScreen()),
                      );
                    },
                    child: Text(
                      isBn ? 'শুরু করুন (Start Now)' : 'Start Now',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
