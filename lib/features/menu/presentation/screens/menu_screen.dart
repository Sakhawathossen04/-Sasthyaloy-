import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../auth/domain/controllers/auth_controller.dart';
import '../../../auth/domain/models/user_profile_model.dart';
import '../../../auth/presentation/screens/edit_profile_screen.dart';
import '../../../auth/presentation/screens/phone_auth_screen.dart';
import '../../../onboarding/presentation/screens/language_selection_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          isBn ? 'প্রোফাইল ও সেটিংস' : 'Profile & Settings',
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
          child: ValueListenableBuilder<UserProfileModel>(
            valueListenable: AuthController.instance.userNotifier,
            builder: (context, user, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Profile / Sign In Banner
                  if (!user.isLoggedIn)
                    _buildGuestBanner(isBn)
                  else
                    _buildUserProfileCard(user, isBn),

                  const SizedBox(height: 20),

                  // 2. Family Members Switcher (If Logged In)
                  if (user.isLoggedIn && user.familyMembers.isNotEmpty) ...[
                    _buildFamilyMembersSection(user, isBn),
                    const SizedBox(height: 20),
                  ],

                  // 3. Healthcare Services Section
                  _buildSectionHeader(isBn ? 'স্বাস্থ্য সেবা ও রেকর্ড' : 'Healthcare Records'),
                  _buildMenuCard([
                    _buildMenuTile(
                      icon: Icons.calendar_month_rounded,
                      title: isBn ? 'আমার অ্যাপয়েন্টমেন্টসমূহ' : 'My Appointments',
                      onTap: () {
                        // Info modal
                        _showFeatureNotice(context, isBn, isBn ? 'অ্যাপয়েন্টমেন্ট' : 'Appointments');
                      },
                    ),
                    _buildMenuTile(
                      icon: Icons.folder_shared_rounded,
                      title: isBn ? 'ডিজিটাল প্রেসক্রিপশন ও রিপোর্ট' : 'EHR & Prescriptions',
                      onTap: () {
                        _showFeatureNotice(context, isBn, isBn ? 'মেডিকেল রেকর্ড' : 'Medical Records');
                      },
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // 4. App Settings
                  _buildSectionHeader(isBn ? 'অ্যাপ সেটিংস' : 'App Settings'),
                  _buildMenuCard([
                    _buildMenuTile(
                      icon: Icons.language_rounded,
                      title: isBn ? 'ভাষা পরিবর্তন (Language)' : 'Language',
                      trailingText: isBn ? 'বাংলা' : 'English',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const LanguageSelectionScreen(isFromSettings: true)),
                        );
                      },
                    ),
                    _buildSwitchTile(
                      icon: Icons.notifications_active_outlined,
                      title: isBn ? 'পুশ নোটিফিকেশন' : 'Push Notifications',
                      value: _notificationsEnabled,
                      onChanged: (val) => setState(() => _notificationsEnabled = val),
                    ),
                    _buildSwitchTile(
                      icon: Icons.fingerprint_rounded,
                      title: isBn ? 'বায়োমেট্রিক ও ফেস আনলক' : 'Biometric Security',
                      value: _biometricEnabled,
                      onChanged: (val) => setState(() => _biometricEnabled = val),
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // 5. Policies & Help
                  _buildSectionHeader(isBn ? 'সহায়তা ও নীতিমালা' : 'Support & Legal'),
                  _buildMenuCard([
                    _buildMenuTile(
                      icon: Icons.support_agent_rounded,
                      title: isBn ? 'স্বাস্থ্য বাতায়ন হেল্পলাইন (১৬২৬৩)' : 'Health Helpline (16263)',
                      onTap: () => _dialSupport(context, isBn),
                    ),
                    _buildMenuTile(
                      icon: Icons.privacy_tip_outlined,
                      title: isBn ? 'গোপনীয়তা নীতিমালা ও শর্তাবলী' : 'Privacy Policy & Terms',
                      onTap: () => _showPrivacyPolicyModal(context, isBn),
                    ),
                    _buildMenuTile(
                      icon: Icons.info_outline_rounded,
                      title: isBn ? 'স্বাস্থ্যালয় সম্পর্কে' : 'About Sasthyaloy',
                      trailingText: 'v1.0.0',
                      onTap: () => _showAboutModal(context, isBn),
                    ),
                  ]),

                  // 6. Logout Button (If Logged In)
                  if (user.isLoggedIn) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.sosRed,
                          side: const BorderSide(color: AppColors.sosRed),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.logout_rounded, size: 20),
                        label: Text(
                          isBn ? 'লগআউট করুন (Sign Out)' : 'Sign Out',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => _showLogoutDialog(context, isBn),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // 7. Footer
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Sasthyaloy v1.0.0 (30883)\n© 2026 Department of Digital Health. All rights reserved.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.4),
                        ),
                        const SizedBox(height: 10),
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
              );
            },
          ),
        ),
      ),
    );
  }

  // User Profile Card
  Widget _buildUserProfileCard(UserProfileModel user, bool isBn) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: AppColors.brandCyan.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.brandCyan, width: 2),
                ),
                child: const Icon(Icons.person, color: AppColors.primaryNavy, size: 36),
              ),
              const SizedBox(width: 14),
              // Name & Contact
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isBn ? user.nameBn : user.nameEn,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryNavy,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.sosRed.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            user.bloodGroup,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.sosRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.phone.isNotEmpty ? user.phone : '+880 1712-345678',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Patient ID: ${user.id}',
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: AppColors.borderLight),
          // Edit Profile Action Button
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundLight,
                foregroundColor: AppColors.primaryNavy,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: AppColors.borderLight),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
              icon: const Icon(Icons.edit_note_rounded, size: 20),
              label: Text(
                isBn ? 'প্রোফাইল সম্পাদনা করুন' : 'Edit Profile Details',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Family Members Section
  Widget _buildFamilyMembersSection(UserProfileModel user, bool isBn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader(isBn ? 'পরিবারের সদস্য নির্বাচন' : 'Switch Family Member'),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primaryNavy,
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      isBn ? 'নতুন পারিবারিক সদস্য যোগ করার ফর্ম শীঘ্রই আসছে!' : 'Add family member coming soon!',
                    ),
                  ),
                );
              },
              child: Text(
                isBn ? '+ সদস্য যোগ' : '+ Add',
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.brandCyan),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: user.familyMembers.map((member) {
              final isSelected = user.activeMemberId == member.id;
              return InkWell(
                onTap: () => AuthController.instance.switchFamilyMember(member.id),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryNavy : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryNavy : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: isSelected ? Colors.white : AppColors.primaryNavy,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isBn ? member.nameBn : member.nameEn,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Guest Banner
  Widget _buildGuestBanner(bool isBn) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_person_outlined, color: AppColors.primaryNavy, size: 24),
              const SizedBox(width: 10),
              Text(
                isBn ? 'লগইন করে সম্পূর্ণ সেবা গ্রহণ করুন' : 'Sign in to access your records',
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isBn
                ? 'ব্যক্তিগত প্রেসক্রিপশন, ল্যাব টেস্ট ফলাফল ও পরিবারিক হেলথ রেকর্ড দেখতে লগইন করুন।'
                : 'Access encrypted medical prescriptions, laboratory tests and family health history.',
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNavy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.phone_android_rounded, size: 18),
              label: Text(
                isBn ? 'মোবাইল নম্বর দিয়ে প্রবেশ করুন' : 'Sign In with Mobile OTP',
                style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PhoneAuthScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
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

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryNavy, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) ...[
            Text(
              trailingText,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
          ],
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: AppColors.textSecondary,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.primaryNavy, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      activeColor: AppColors.brandCyan,
      value: value,
      onChanged: onChanged,
    );
  }

  void _dialSupport(BuildContext context, bool isBn) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryNavy,
        behavior: SnackBarBehavior.floating,
        content: Text(
          isBn ? 'স্বাস্থ্য বাতায়ন হেল্পলাইনে (১৬২৬৩) কল সংযোগ করা হচ্ছে...' : 'Dialing Health Helpline 16263...',
        ),
      ),
    );
  }

  void _showPrivacyPolicyModal(BuildContext context, bool isBn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isBn ? 'গোপনীয়তা নীতিমালা ও ডেটা নিরাপত্তা' : 'Privacy & Security Policy',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
              ),
              const SizedBox(height: 12),
              Text(
                isBn
                    ? 'স্বাস্থ্যালয় আপনার সকল ডিজিটাল হেলথ রেকর্ড, প্রেসক্রিপশন ও ব্যক্তিগত তথ্য আন্তর্জাতিক HIPAA ও স্থানীয় ডিজিটাল নিরাপত্তা আইনের পূর্ণ মানদণ্ডে এনক্রিপ্ট করে সংরক্ষণ করে।'
                    : 'Sasthyaloy strictly encrypts all your electronic health records, diagnostic tests and personal credentials in compliance with standard clinical data privacy protocols.',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(isBn ? 'সম্মত আছি' : 'I Understand'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutModal(BuildContext context, bool isBn) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isBn ? 'স্বাস্থ্যালয় (Sasthyaloy)' : 'About Sasthyaloy'),
        content: Text(
          isBn
              ? 'স্বাস্থ্যালয় বাংলাদেশের প্রথম আন্তর্জাতিক মানের কৃত্রিম বুদ্ধিমত্তা সমৃদ্ধ ও সমন্বিত ডিজিটাল স্বাস্থ্যসেবা প্ল্যাটফর্ম।'
              : 'Sasthyaloy is Bangladesh\'s pioneering AI-powered comprehensive digital healthcare platform.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(isBn ? 'ঠিক আছে' : 'OK'),
          ),
        ],
      ),
    );
  }

  void _showFeatureNotice(BuildContext context, bool isBn, String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryNavy,
        behavior: SnackBarBehavior.floating,
        content: Text(
          isBn ? '$featureName সেকশন সক্রিয় রয়েছে।' : '$featureName is currently active.',
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isBn) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isBn ? 'লগআউট নিশ্চিতকরণ' : 'Confirm Logout'),
        content: Text(
          isBn
              ? 'আপনি কি নিশ্চিত যে আপনার অ্যাকাউন্ট থেকে লগআউট করতে চান?'
              : 'Are you sure you want to log out of your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(isBn ? 'বাতিল' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.sosRed),
            onPressed: () {
              Navigator.of(ctx).pop();
              AuthController.instance.signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primaryNavy,
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    isBn ? 'লগআউট সফল হয়েছে।' : 'Logged out successfully.',
                  ),
                ),
              );
            },
            child: Text(isBn ? 'লগআউট' : 'Sign Out'),
          ),
        ],
      ),
    );
  }
}
