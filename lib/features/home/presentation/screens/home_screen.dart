import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../auth/domain/controllers/auth_controller.dart';
import '../../../auth/presentation/screens/phone_auth_screen.dart';
import '../../../doctors/presentation/screens/speciality_search_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigateToTab;
  const HomeScreen({super.key, required this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;

  bool _isInPersonSelected = true;
  bool _isTeleconsultSelected = false;

  // Selected Hospital/Clinic
  String? _selectedHospital;

  // User State: Guest vs Logged In
  bool get _isLoggedIn => AuthController.instance.isLoggedIn;
  String get _userName {
    final user = AuthController.instance.currentUser;
    final isBn = AppLocaleController.instance.isBangla;
    if (isBn && user.nameBn.isNotEmpty) return user.nameBn;
    if (user.nameEn.isNotEmpty) return user.nameEn;
    if (user.nameBn.isNotEmpty) return user.nameBn;
    return isBn ? 'ব্যবহারকারী' : 'User';
  }

  // Wellness Tracking Connected State
  bool _isWellnessConnected = false;
  int _dailySteps = 7420;
  int _heartRate = 72;

  final List<String> _hospitalListBn = [
    'সকল হাসপাতাল ও ক্লিনিক',
    'ঢাকা মেডিকেল কলেজ হাসপাতাল (DMCH)',
    'বঙ্গবন্ধু শেখ মুজিব মেডিকেল বিশ্ববিদ্যালয় (BSMMU)',
    'স্কয়ার হাসপাতাল লিমিটেড (Square Hospital)',
    'ইউনাইটেড হাসপাতাল (United Hospital)',
    'এভারকেয়ার হাসপাতাল ঢাকা (Evercare Hospital)',
    'ইবনে সিনা বিশেষায়িত হাসপাতাল (Ibn Sina)',
    'বারডেম জেনারেল হাসপাতাল (BIRDEM)',
    'চট্টগ্রাম মেডিকেল কলেজ হাসপাতাল (CMCH)',
    'কুর্মিটোলা জেনারেল হাসপাতাল (KGH)',
  ];

  final List<String> _hospitalListEn = [
    'All Hospitals & Clinics',
    'Dhaka Medical College Hospital (DMCH)',
    'Bangabandhu Sheikh Mujib Medical University (BSMMU)',
    'Square Hospital Limited',
    'United Hospital Limited',
    'Evercare Hospital Dhaka',
    'Ibn Sina Specialized Hospital',
    'BIRDEM General Hospital',
    'Chittagong Medical College Hospital (CMCH)',
    'Kurmitola General Hospital (KGH)',
  ];

  @override
  void initState() {
    super.initState();
    AuthController.instance.userNotifier.addListener(_onUserChanged);
    // Auto-advance banner carousel every 4 seconds
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      if (_bannerController.hasClients) {
        final nextIndex = (_currentBannerIndex + 1) % 4;
        _bannerController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onUserChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    AuthController.instance.userNotifier.removeListener(_onUserChanged);
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header Bar
              _buildHeader(isBn),

              const SizedBox(height: 8),

              // 2. Promotional Dynamic Carousels
              _buildPromoCarousel(isBn),

              const SizedBox(height: 20),

              // 3. Quick Actions Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.tr('quick_actions', isBangla: isBn),
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    if (!_isLoggedIn)
                      GestureDetector(
                        onTap: () => _showLoginDialog(isBn),
                        child: Text(
                          isBn ? 'লগইন করুন' : 'Sign In',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brandCyan,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildQuickActionsGrid(isBn),

              const SizedBox(height: 20),

              // 4. Primary Care Card
              _buildPrimaryCareCard(isBn),

              const SizedBox(height: 20),

              // 5. Book an Appointment Card
              _buildBookAppointmentCard(isBn),

              const SizedBox(height: 20),

              // 6. Wellness Section
              _buildWellnessSection(isBn),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Top Header
  Widget _buildHeader(bool isBn) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // User Avatar
          GestureDetector(
            onTap: () {
              if (!_isLoggedIn) {
                _showLoginDialog(isBn);
              } else {
                widget.onNavigateToTab(4); // Open Menu
              }
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _isLoggedIn ? AppColors.brandCyan.withOpacity(0.15) : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isLoggedIn ? AppColors.brandCyan : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Icon(
                _isLoggedIn ? Icons.verified_user_rounded : Icons.person_rounded,
                color: AppColors.primaryNavy,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // User Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isLoggedIn
                      ? (isBn ? 'স্বাগতম, $_userName' : 'Hello, $_userName')
                      : AppStrings.tr('guest_greeting', isBangla: isBn),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  isBn ? 'স্বাস্থ্যালয় হেলথকেয়ার' : 'Sasthyaloy Healthcare',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Language Switcher Pill
          InkWell(
            onTap: () {
              setState(() {
                AppLocaleController.instance.toggleLanguage();
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryNavy,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    isBn ? 'English' : 'বাংলা',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.language, color: Colors.white, size: 15),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // SOS Emergency Button with Badge
          InkWell(
            onTap: () => _showSosBottomSheet(isBn),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.sosRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.sosRed, width: 1.5),
              ),
              child: Row(
                children: const [
                  Icon(Icons.emergency_rounded, color: AppColors.sosRed, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'SOS',
                    style: TextStyle(
                      color: AppColors.sosRed,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Promotional Carousels
  Widget _buildPromoCarousel(bool isBn) {
    final banners = [
      {
        'title': AppStrings.tr('welcome_banner_title', isBangla: isBn),
        'subtitle': AppStrings.tr('welcome_banner_subtitle', isBangla: isBn),
        'icon': Icons.medical_services_outlined,
        'gradient': const [Color(0xFF0B4278), Color(0xFF0077D4)],
        'action': () => _showWelcomeModal(isBn),
      },
      {
        'title': AppStrings.tr('records_banner_title', isBangla: isBn),
        'subtitle': AppStrings.tr('records_banner_subtitle', isBangla: isBn),
        'icon': Icons.folder_shared_outlined,
        'gradient': const [Color(0xFF065F46), Color(0xFF059669)],
        'action': () {
          if (!_isLoggedIn) {
            _showLoginDialog(isBn);
          } else {
            widget.onNavigateToTab(1); // My Health
          }
        },
      },
      {
        'title': AppStrings.tr('booking_banner_title', isBangla: isBn),
        'subtitle': AppStrings.tr('booking_banner_subtitle', isBangla: isBn),
        'icon': Icons.calendar_today_outlined,
        'gradient': const [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
        'action': () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SpecialitySearchScreen()),
          );
        },
      },
      {
        'title': AppStrings.tr('ai_banner_title', isBangla: isBn),
        'subtitle': AppStrings.tr('ai_banner_subtitle', isBangla: isBn),
        'icon': Icons.psychology_alt_outlined,
        'gradient': const [Color(0xFF4C1D95), Color(0xFF7C3AED)],
        'action': () {
          widget.onNavigateToTab(2); // AI Assistant
        },
      },
    ];

    return Column(
      children: [
        SizedBox(
          height: 165,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: banners.length,
            onPageChanged: (idx) => setState(() => _currentBannerIndex = idx),
            itemBuilder: (context, index) {
              final banner = banners[index];
              return InkWell(
                onTap: banner['action'] as VoidCallback,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: banner['gradient'] as List<Color>,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              banner['title'] as String,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              banner['subtitle'] as String,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              banner['icon'] as IconData,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (idx) {
            final isActive = _currentBannerIndex == idx;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? AppColors.brandCyan : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  // 3. Quick Actions Grid
  Widget _buildQuickActionsGrid(bool isBn) {
    final actions = [
      {
        'title': isBn ? 'আমার স্বাস্থ্য' : 'My Health',
        'icon': Icons.favorite_rounded,
        'color': const Color(0xFF4299E1),
        'isLocked': !_isLoggedIn,
        'tab': 1,
      },
      {
        'title': isBn ? 'ডাক্তার খুঁজুন' : 'Book a Doctor',
        'icon': Icons.calendar_today_rounded,
        'color': const Color(0xFF3182CE),
        'isLocked': false,
        'tab': 3,
      },
      {
        'title': isBn ? 'টেলি কনসাল্ট' : 'Tele Consult',
        'icon': Icons.video_call_rounded,
        'color': const Color(0xFF0077D4),
        'isLocked': false,
        'tab': 3,
      },
      {
        'title': isBn ? 'লক্ষণ যাচাইকারী' : 'AI Symptom Checker',
        'icon': Icons.search_rounded,
        'color': const Color(0xFF00A3FF),
        'isLocked': false,
        'tab': 2,
      },
      {
        'title': isBn ? 'প্রেসক্রিপশন' : 'Prescription',
        'icon': Icons.medication_rounded,
        'color': const Color(0xFF63B3ED),
        'isLocked': !_isLoggedIn,
        'tab': 1,
      },
      {
        'title': isBn ? 'স্বাস্থ্য বীমা' : 'Insurance',
        'icon': Icons.shield_rounded,
        'color': const Color(0xFF4FD1C5),
        'isLocked': !_isLoggedIn,
        'tab': 1,
      },
      {
        'title': isBn ? 'জিনোম কেয়ার' : 'Genome',
        'icon': Icons.biotech_rounded,
        'color': const Color(0xFF81E6D9),
        'isLocked': !_isLoggedIn,
        'tab': 1,
      },
      {
        'title': isBn ? 'সুস্থতা ট্র্যাকার' : 'Wellness',
        'icon': Icons.watch_rounded,
        'color': const Color(0xFF68D391),
        'isLocked': false,
        'tab': -1, // custom
      },
      {
        'title': isBn ? 'স্বাস্থ্য সংবাদ' : 'News & Articles',
        'icon': Icons.article_rounded,
        'color': const Color(0xFF2B6CB0),
        'isLocked': false,
        'tab': -2, // custom
      },
      {
        'title': isBn ? 'ইভেন্টস' : 'Events',
        'icon': Icons.event_available_rounded,
        'color': const Color(0xFF2C5282),
        'isLocked': false,
        'tab': -3, // custom
      },
      {
        'title': isBn ? 'পুষ্টিকর রেসিপি' : 'Recipes',
        'icon': Icons.restaurant_menu_rounded,
        'color': const Color(0xFF319795),
        'isLocked': false,
        'tab': -4, // custom
      },
      {
        'title': isBn ? 'মূল্যায়ন' : 'My Assessments',
        'icon': Icons.fact_check_rounded,
        'color': const Color(0xFF4A5568),
        'isLocked': !_isLoggedIn,
        'tab': 1,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actions.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.84,
        ),
        itemBuilder: (context, index) {
          final item = actions[index];
          final isLocked = item['isLocked'] as bool;
          return InkWell(
            onTap: () {
              if (isLocked) {
                _showLoginDialog(isBn);
              } else {
                final tab = item['tab'] as int;
                if (tab >= 0) {
                  widget.onNavigateToTab(tab);
                } else if (tab == -1) {
                  _showWellnessTrackerModal(isBn);
                } else {
                  _showContentDetailModal(
                    isBn,
                    title: item['title'] as String,
                    icon: item['icon'] as IconData,
                  );
                }
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          size: 28,
                          color: item['color'] as Color,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['title'] as String,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLocked)
                    const Positioned(
                      top: 0,
                      right: 2,
                      child: Icon(Icons.lock_rounded, size: 12, color: AppColors.textMuted),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 4. Primary Care Card
  Widget _buildPrimaryCareCard(bool isBn) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.chipBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.all_inclusive, color: AppColors.primaryNavy, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.tr('primary_care', isBangla: isBn),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.tr('primary_care_desc', isBangla: isBn),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SpecialitySearchScreen()),
              );
            },
            child: Text(
              AppStrings.tr('explore', isBangla: isBn),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // 5. Book an Appointment Card
  Widget _buildBookAppointmentCard(bool isBn) {
    final activeHospitalLabel = _selectedHospital ??
        (isBn ? 'হাসপাতাল বা ক্লিনিক নির্বাচন করুন' : 'Hospital or Clinic');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tr('book_appointment', isBangla: isBn),
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.tr('book_appointment_desc', isBangla: isBn),
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),

          // Search Field: Doctor / Speciality
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SpecialitySearchScreen()),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    AppStrings.tr('speciality_or_name', isBangla: isBn),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Commonly Searched Specialities Chips
          Text(
            AppStrings.tr('commonly_searched', isBangla: isBn),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Family Medicine', isBn ? 'ফ্যামিলি মেডিসিন' : 'Family Medicine'),
                const SizedBox(width: 8),
                _buildFilterChip('General Practitioner', isBn ? 'জেনারেল ফিজিশিয়ান' : 'General Practitioner'),
                const SizedBox(width: 8),
                _buildFilterChip('Cardiology', isBn ? 'কার্ডিওলজি' : 'Cardiology'),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Hospital or Clinic Field (Interactive Selector)
          InkWell(
            onTap: () => _showHospitalPicker(isBn),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedHospital != null ? AppColors.brandCyan : AppColors.borderLight,
                  width: _selectedHospital != null ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.apartment_rounded,
                    color: _selectedHospital != null ? AppColors.brandCyan : AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      activeHospitalLabel,
                      style: TextStyle(
                        color: _selectedHospital != null ? AppColors.primaryNavy : AppColors.textSecondary,
                        fontSize: 13.5,
                        fontWeight: _selectedHospital != null ? FontWeight.w600 : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_selectedHospital != null)
                    GestureDetector(
                      onTap: () => setState(() => _selectedHospital = null),
                      child: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                    )
                  else
                    const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Appointment Type Checkboxes
          Row(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _isInPersonSelected,
                    activeColor: AppColors.primaryNavy,
                    onChanged: (val) => setState(() => _isInPersonSelected = val ?? true),
                  ),
                  Text(
                    AppStrings.tr('in_person', isBangla: isBn),
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Checkbox(
                    value: _isTeleconsultSelected,
                    activeColor: AppColors.primaryNavy,
                    onChanged: (val) => setState(() => _isTeleconsultSelected = val ?? false),
                  ),
                  Text(
                    AppStrings.tr('teleconsultation', isBangla: isBn),
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Search Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNavy,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SpecialitySearchScreen(
                      initialSearch: _selectedHospital,
                    ),
                  ),
                );
              },
              child: Text(
                AppStrings.tr('search', isBangla: isBn),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 6. Wellness Section
  Widget _buildWellnessSection(bool isBn) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isBn ? 'সুস্থতা ও লাইফস্টাইল' : 'Wellness',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
              GestureDetector(
                onTap: () => _showWellnessTrackerModal(isBn),
                child: Text(
                  isBn ? 'বিস্তারিত দেখুন' : 'View Details',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandCyan,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isWellnessConnected ? const Color(0xFFDCFCE7) : const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _isWellnessConnected ? Icons.favorite_rounded : Icons.watch_rounded,
                    color: _isWellnessConnected ? AppColors.emeraldGreen : const Color(0xFF0284C7),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isWellnessConnected
                            ? (isBn ? 'স্মার্ট ডিভাইস সংযুক্ত আছে' : 'Smart Device Connected')
                            : AppStrings.tr('wellness_title', isBangla: isBn),
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isWellnessConnected
                            ? (isBn
                                ? 'আজকে $_dailySteps পা হেঁটেছেন | হার্ট রেট: $_heartRate bpm'
                                : 'Today: $_dailySteps steps | Heart rate: $_heartRate bpm')
                            : AppStrings.tr('wellness_desc', isBangla: isBn),
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isWellnessConnected ? AppColors.emeraldGreen : AppColors.primaryNavy,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () => _showWellnessTrackerModal(isBn),
                  child: Text(
                    _isWellnessConnected
                        ? (isBn ? 'সিঙ্ক' : 'Sync')
                        : AppStrings.tr('connect', isBangla: isBn),
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => SpecialitySearchScreen(initialSearch: value)),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.chipBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.chipText,
          ),
        ),
      ),
    );
  }

  // --- INTERACTIVE MODALS & DIALOGS ---

  // SOS Bottom Sheet
  void _showSosBottomSheet(bool isBn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.sosRed.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.emergency_rounded, color: AppColors.sosRed, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isBn ? 'জরুরি চিকিৎসা সহায়তা (Emergency SOS)' : 'Emergency Assistance (SOS)',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                        ),
                        Text(
                          isBn ? '২৪/৭ তাৎক্ষণিক মেডিকেল হেল্পলাইন' : '24/7 immediate clinical response',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSosTile(
                title: isBn ? 'জাতীয় জরুরি সেবা (পুলিশ, অ্যাম্বুলেন্স)' : 'National Emergency Service',
                phone: '999',
                icon: Icons.local_police_rounded,
                color: Colors.red.shade700,
                onTap: () => _simulateCall('999'),
              ),
              const SizedBox(height: 10),
              _buildSosTile(
                title: isBn ? 'স্বাস্থ্য বাতায়ন (স্বাস্থ্য অধিদপ্তর)' : 'Swasthya Batayan (Govt Health Helpline)',
                phone: '16263',
                icon: Icons.health_and_safety_rounded,
                color: AppColors.emeraldGreen,
                onTap: () => _simulateCall('16263'),
              ),
              const SizedBox(height: 10),
              _buildSosTile(
                title: isBn ? 'রেড ক্রিসেন্ট অ্যাম্বুলেন্স সার্ভিস' : 'Red Crescent Ambulance Service',
                phone: '01811458524',
                icon: Icons.airport_shuttle_rounded,
                color: Colors.orange.shade800,
                onTap: () => _simulateCall('01811458524'),
              ),
              const SizedBox(height: 10),
              _buildSosTile(
                title: isBn ? 'ঢাকা মেডিকেল কলেজ ইমার্জেন্সি' : 'Dhaka Medical College Emergency',
                phone: '02-55165088',
                icon: Icons.local_hospital_rounded,
                color: AppColors.brandCyan,
                onTap: () => _simulateCall('02-55165088'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSosTile({
    required String title,
    required String phone,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
        ),
        subtitle: Text(
          phone,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color),
        ),
        trailing: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: onTap,
          icon: const Icon(Icons.call, size: 16),
          label: const Text('Call', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _simulateCall(String number) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryNavy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(
          AppLocaleController.instance.isBangla
              ? '$number নম্বরে কল সংযোগ করা হচ্ছে...'
              : 'Initiating call to $number...',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // Hospital Picker Modal
  void _showHospitalPicker(bool isBn) {
    final list = isBn ? _hospitalListBn : _hospitalListEn;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.65,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isBn ? 'হাসপাতাল বা স্বাস্থ্যকেন্দ্র নির্বাচন' : 'Select Hospital or Healthcare Facility',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderLight),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    final isSelected = _selectedHospital == item;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        index == 0 ? Icons.local_hospital_rounded : Icons.apartment_rounded,
                        color: isSelected ? AppColors.brandCyan : AppColors.textSecondary,
                      ),
                      title: Text(
                        item,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AppColors.brandCyan : AppColors.textPrimary,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded, color: AppColors.brandCyan)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedHospital = index == 0 ? null : item;
                        });
                        Navigator.of(ctx).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Quick Sign In Dialog (Simulates Phone OTP login)
  void _showLoginDialog(bool isBn) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PhoneAuthScreen()),
    );
  }

  // Wellness Tracker Modal
  void _showWellnessTrackerModal(bool isBn) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isBn ? 'সুস্থতা ট্র্যাকার ও স্মার্ট ডিভাইস' : 'Wellness & Smart Device Tracker',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isBn
                        ? 'Google Fit, Apple Health বা ফিটনেস ব্যান্ডের সাথে সিঙ্ক করে প্রতিদিনের হাঁটা ও ক্যালোরি ট্র্যাক করুন।'
                        : 'Sync with Google Fit, Apple Health or Smart band to monitor daily steps and vitals.',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricColumn(
                          isBn ? 'হাঁটা' : 'Steps',
                          '$_dailySteps',
                          isBn ? 'পা' : 'steps',
                          Icons.directions_walk_rounded,
                        ),
                        Container(width: 1, height: 40, color: AppColors.borderLight),
                        _buildMetricColumn(
                          isBn ? 'হার্ট রেট' : 'Heart Rate',
                          '$_heartRate',
                          'bpm',
                          Icons.favorite_rounded,
                        ),
                        Container(width: 1, height: 40, color: AppColors.borderLight),
                        _buildMetricColumn(
                          isBn ? 'ক্যালোরি' : 'Burned',
                          '450',
                          'kcal',
                          Icons.local_fire_department_rounded,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isWellnessConnected ? AppColors.emeraldGreen : AppColors.primaryNavy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        setState(() {
                          _isWellnessConnected = !_isWellnessConnected;
                          if (_isWellnessConnected) {
                            _dailySteps = 7850;
                            _heartRate = 74;
                          }
                        });
                        Navigator.of(ctx).pop();
                      },
                      icon: Icon(_isWellnessConnected ? Icons.sync_rounded : Icons.add_link_rounded),
                      label: Text(
                        _isWellnessConnected
                            ? (isBn ? 'তথ্য রিফ্রেশ করুন' : 'Refresh Metrics')
                            : (isBn ? 'স্মার্ট ডিভাইস যুক্ত করুন' : 'Connect Smart Device'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, String unit, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.brandCyan, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
        Text('$label ($unit)', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  void _showWelcomeModal(bool isBn) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isBn ? 'স্বাস্থ্যালয়ে আপনাকে স্বাগতম' : 'Welcome to Sasthyaloy'),
        content: Text(
          isBn
              ? 'আমাদের প্ল্যাটফর্মে আপনি পাচ্ছেন বিশেষজ্ঞ ডাক্তারদের চেম্বার অ্যাপয়েন্টমেন্ট, টেলিমেডিসিন, ল্যাব রিপোর্ট সংরক্ষণ এবং কৃত্রিম বুদ্ধিমত্তা সমৃদ্ধ স্বাস্থ্য পরামর্শ।'
              : 'Our platform delivers seamless physician appointments, 24/7 teleconsultations, encrypted EHR medical records, and AI-powered clinical guidance.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(isBn ? 'বুঝেছি' : 'Got it'),
          ),
        ],
      ),
    );
  }

  void _showContentDetailModal(bool isBn, {required String title, required IconData icon}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: AppColors.brandCyan),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
              ),
              const SizedBox(height: 10),
              Text(
                isBn
                    ? 'এই বিভাগের সাম্প্রতিক নিবন্ধ, টিপস ও আপডেট শীঘ্রই যুক্ত হবে।'
                    : 'Latest health articles, dietary guidance and updates will appear here.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(isBn ? 'ঠিক আছে' : 'OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
