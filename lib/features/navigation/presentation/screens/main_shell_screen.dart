import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../my_health/presentation/screens/my_health_screen.dart';
import '../../../voice_ai/presentation/screens/voice_ai_screen.dart';
import '../../../appointments/presentation/screens/appointments_screen.dart';
import '../../../menu/presentation/screens/menu_screen.dart';

class MainShellScreen extends StatefulWidget {
  final int initialIndex;
  const MainShellScreen({super.key, this.initialIndex = 0});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _currentIndex;
  final List<int> _tabHistory = [0];
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _tabHistory.clear();
    _tabHistory.add(widget.initialIndex);
    AppLocaleController.instance.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    AppLocaleController.instance.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
      _tabHistory.remove(index);
      _tabHistory.add(index);
    });
  }

  void _handleBackNavigation() {
    // 1. If user switched across tabs, pop previous tab from history
    if (_tabHistory.length > 1) {
      setState(() {
        _tabHistory.removeLast();
        _currentIndex = _tabHistory.last;
      });
      return;
    }

    // 2. If somehow history is empty but not on home tab, jump to home tab
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
        _tabHistory.clear();
        _tabHistory.add(0);
      });
      return;
    }

    // 3. If currently on Home tab, require double back tap within 2s to exit app
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      final isBn = AppLocaleController.instance.isBangla;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isBn
                ? 'অ্যাপ থেকে বের হতে আবার ব্যাক চাপুন'
                : 'Press back again to exit',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          backgroundColor: AppColors.primaryNavy,
        ),
      );
      return;
    }

    // Double tap confirmed: exit app cleanly
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    final List<Widget> pages = [
      HomeScreen(onNavigateToTab: _onTabSelected),
      const MyHealthScreen(),
      const VoiceAiScreen(),
      const AppointmentsScreen(),
      const MenuScreen(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          _handleBackNavigation();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: AppColors.borderLight, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: Icons.home_rounded,
                    label: AppStrings.tr('tab_home', isBangla: isBn),
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.favorite_border_rounded,
                    label: AppStrings.tr('tab_health', isBangla: isBn),
                  ),
                  _buildCentralAiItem(
                    index: 2,
                    label: isBn ? 'স্বাস্থ্যালয় AI' : 'Sasthyaloy AI',
                  ),
                  _buildNavItem(
                    index: 3,
                    icon: Icons.calendar_month_outlined,
                    label: AppStrings.tr('tab_appointments', isBangla: isBn),
                  ),
                  _buildNavItem(
                    index: 4,
                    icon: Icons.menu_rounded,
                    label: AppStrings.tr('tab_menu', isBangla: isBn),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => _onTabSelected(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? AppColors.primaryNavy : AppColors.textMuted,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primaryNavy : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCentralAiItem({
    required int index,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => _onTabSelected(index),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.brandCyan, AppColors.emeraldGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandCyan.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.brandCyan : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
