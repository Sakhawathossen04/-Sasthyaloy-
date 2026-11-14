import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/localization/app_locale_controller.dart';
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
  bool _isInPersonSelected = true;
  bool _isTeleconsultSelected = false;

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

              const SizedBox(height: 12),

              // 2. Promotional Carousels
              _buildPromoCarousel(isBn),

              const SizedBox(height: 24),

              // 3. Quick Actions Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  AppStrings.tr('quick_actions', isBangla: isBn),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _buildQuickActionsGrid(isBn),

              const SizedBox(height: 20),

              // 4. Primary Care Card
              _buildPrimaryCareCard(isBn),

              const SizedBox(height: 24),

              // 5. Book an Appointment Card
              _buildBookAppointmentCard(isBn),

              const SizedBox(height: 24),

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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, color: AppColors.primaryNavy, size: 28),
          ),
          const SizedBox(width: 12),

          // User Name Greeting
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.tr('guest_greeting', isBangla: isBn),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
            ],
          ),
          const Spacer(),

          // Language Switcher Pill
          InkWell(
            onTap: () {
              AppLocaleController.instance.toggleLanguage();
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
                  const SizedBox(width: 6),
                  const Icon(Icons.language, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // SOS Emergency Button
          InkWell(
            onTap: () => _showSosDialog(isBn),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryNavy, width: 2),
              ),
              child: const Center(
                child: Text(
                  'SOS',
                  style: TextStyle(
                    color: AppColors.primaryNavy,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
      },
      {
        'title': AppStrings.tr('records_banner_title', isBangla: isBn),
        'subtitle': AppStrings.tr('records_banner_subtitle', isBangla: isBn),
        'icon': Icons.folder_shared_outlined,
      },
      {
        'title': AppStrings.tr('booking_banner_title', isBangla: isBn),
        'subtitle': AppStrings.tr('booking_banner_subtitle', isBangla: isBn),
        'icon': Icons.calendar_today_outlined,
      },
      {
        'title': AppStrings.tr('ai_banner_title', isBangla: isBn),
        'subtitle': AppStrings.tr('ai_banner_subtitle', isBangla: isBn),
        'icon': Icons.psychology_alt_outlined,
      },
    ];

    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _bannerController,
        itemCount: banners.length,
        onPageChanged: (idx) => setState(() => _currentBannerIndex = idx),
        itemBuilder: (context, index) {
          final banner = banners[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0B4278), Color(0xFF0077D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        banner['subtitle'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        banner['icon'] as IconData,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 3. Quick Actions Grid
  Widget _buildQuickActionsGrid(bool isBn) {
    final actions = [
      {
        'title': isBn ? 'আমার স্বাস্থ্য' : 'My Health',
        'icon': Icons.favorite_rounded,
        'color': const Color(0xFF4299E1),
        'isLocked': true,
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
        'isLocked': true,
        'tab': 1,
      },
      {
        'title': isBn ? 'স্বাস্থ্য বীমা' : 'Insurance',
        'icon': Icons.shield_rounded,
        'color': const Color(0xFF4FD1C5),
        'isLocked': true,
        'tab': 1,
      },
      {
        'title': isBn ? 'জিনোম' : 'Genome',
        'icon': Icons.biotech_rounded,
        'color': const Color(0xFF81E6D9),
        'isLocked': true,
        'tab': 1,
      },
      {
        'title': isBn ? 'সুস্থতা ট্র্যাকার' : 'Wellness',
        'icon': Icons.watch_rounded,
        'color': const Color(0xFF68D391),
        'isLocked': true,
        'tab': 1,
      },
      {
        'title': isBn ? 'স্বাস্থ্য সংবাদ' : 'News & Articles',
        'icon': Icons.article_rounded,
        'color': const Color(0xFF2B6CB0),
        'isLocked': false,
        'tab': 0,
      },
      {
        'title': isBn ? 'ইভেন্টস' : 'Events',
        'icon': Icons.event_available_rounded,
        'color': const Color(0xFF2C5282),
        'isLocked': false,
        'tab': 0,
      },
      {
        'title': isBn ? 'রেসিপি' : 'Recipes',
        'icon': Icons.restaurant_menu_rounded,
        'color': const Color(0xFF319795),
        'isLocked': false,
        'tab': 0,
      },
      {
        'title': isBn ? 'মূল্যায়ন' : 'My Assessments',
        'icon': Icons.fact_check_rounded,
        'color': const Color(0xFF4A5568),
        'isLocked': true,
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
          mainAxisSpacing: 12,
          crossAxisSpacing: 10,
          childAspectRatio: 0.82,
        ),
        itemBuilder: (context, index) {
          final item = actions[index];
          final isLocked = item['isLocked'] as bool;
          return InkWell(
            onTap: () {
              if (isLocked) {
                _showLoginRequiredDialog(isBn);
              } else {
                widget.onNavigateToTab(item['tab'] as int);
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          size: 30,
                          color: item['color'] as Color,
                        ),
                        const SizedBox(height: 8),
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
                      child: Icon(Icons.lock, size: 12, color: AppColors.textMuted),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.tr('book_appointment_desc', isBangla: isBn),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),

          // Search Field
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SpecialitySearchScreen()),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Commonly Searched Specialities
          Text(
            AppStrings.tr('commonly_searched', isBangla: isBn),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildFilterChip('Family Medicine', isBn ? 'ফ্যামিলি মেডিসিন' : 'Family Medicine'),
              const SizedBox(width: 8),
              _buildFilterChip('General Practitioner', isBn ? 'জেনারেল ফিজিশিয়ান' : 'General Practitioner'),
            ],
          ),
          const SizedBox(height: 16),

          // Hospital or Clinic Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                const Icon(Icons.apartment_rounded, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 10),
                Text(
                  AppStrings.tr('hospital_clinic', isBangla: isBn),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

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
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  Checkbox(
                    value: _isTeleconsultSelected,
                    activeColor: AppColors.primaryNavy,
                    onChanged: (val) => setState(() => _isTeleconsultSelected = val ?? false),
                  ),
                  Text(
                    AppStrings.tr('teleconsultation', isBangla: isBn),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

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
                  MaterialPageRoute(builder: (_) => const SpecialitySearchScreen()),
                );
              },
              child: Text(
                AppStrings.tr('search', isBangla: isBn),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
              Text(
                isBn ? 'সব দেখুন' : 'View All',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brandCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.watch_rounded, color: Color(0xFF0284C7), size: 32),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.tr('wellness_title', isBangla: isBn),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppStrings.tr('wellness_desc', isBangla: isBn),
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
                  onPressed: () => _showLoginRequiredDialog(isBn),
                  child: Text(
                    AppStrings.tr('connect', isBangla: isBn),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.chipBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.chipText,
          ),
        ),
      ),
    );
  }

  void _showSosDialog(bool isBn) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.sosRed, size: 28),
            const SizedBox(width: 8),
            Text(isBn ? 'জরুরি চিকিৎসা সহায়তা (SOS)' : 'Emergency Assistance (SOS)'),
          ],
        ),
        content: Text(
          isBn
              ? 'জরুরি অ্যাম্বুলেন্স বা স্বাস্থ্য হেল্পলাইনে সরাসরি কল করতে চান?'
              : 'Do you want to dial emergency health helplines or nearest ambulance?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(isBn ? 'বাতিল' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.sosRed),
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(isBn ? 'কল করুন (16263)' : 'Call 16263'),
          ),
        ],
      ),
    );
  }

  void _showLoginRequiredDialog(bool isBn) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isBn ? 'লগইন প্রয়োজন' : 'Sign in to proceed'),
        content: Text(
          isBn
              ? 'এই সেবাটি ব্যবহার করতে অনুগ্রহ করে আপনার ফোন নম্বর দিয়ে সাইন-ইন করুন।'
              : 'Please sign in to access full services and health records.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(isBn ? 'পরে' : 'Later'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onNavigateToTab(4); // Navigate to Menu
            },
            child: Text(isBn ? 'লগইন করুন' : 'Sign In'),
          ),
        ],
      ),
    );
  }
}
