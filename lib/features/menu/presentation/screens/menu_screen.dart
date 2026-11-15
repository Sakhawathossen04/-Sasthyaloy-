import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../auth/domain/controllers/auth_controller.dart';
import '../../../auth/domain/models/user_profile_model.dart';
import '../../../auth/presentation/screens/edit_profile_screen.dart';
import '../../../auth/presentation/screens/phone_auth_screen.dart';
import '../../../auth/presentation/widgets/profile_avatar_widget.dart';
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
                  if (user.isLoggedIn) ...[
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
    final displayName = user.nameBn.isNotEmpty
        ? user.nameBn
        : (user.nameEn.isNotEmpty
            ? user.nameEn
            : (isBn ? 'নামবিহীন ব্যবহারকারী' : 'Profile Unnamed'));

    final displayBlood = (user.bloodGroup.isNotEmpty && user.bloodGroup != 'N/A')
        ? user.bloodGroup
        : (isBn ? 'রক্তের গ্রুপ?' : 'Blood?');

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
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(35),
                child: ProfileAvatarWidget(
                  avatarId: user.avatarId,
                  size: 64,
                  iconSize: 32,
                ),
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
                            displayName,
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
                            displayBlood,
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
                      user.phone.isNotEmpty ? user.phone : (isBn ? 'মোবাইল নম্বর যোগ করুন' : 'Add phone number'),
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
            _buildSectionHeader(isBn ? 'পরিবারের সদস্য নির্বাচন' : 'Family Member Selection'),
            InkWell(
              onTap: () => _showAddFamilyMemberModal(context, isBn),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.brandCyan.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, size: 14, color: AppColors.brandCyan),
                    const SizedBox(width: 4),
                    Text(
                      isBn ? 'সদস্য যোগ' : 'Add Member',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandCyan,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (user.familyMembers.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.brandCyan.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.group_add_outlined, color: AppColors.brandCyan, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isBn ? 'পরিবারের কোনো সদস্য এখনো যোগ করা হয়নি' : 'No family members added yet',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isBn
                            ? 'অ্যাপয়েন্টমেন্ট বা টেস্ট বুকিং করার জন্য সদস্য যুক্ত করুন'
                            : 'Add family members to book doctor consultations',
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                TextButton(
                  onPressed: () => _showAddFamilyMemberModal(context, isBn),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: AppColors.brandCyan,
                  ),
                  child: Text(
                    isBn ? '+ যোগ' : '+ Add',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...user.familyMembers.map((member) {
                  final isSelected = user.activeMemberId == member.id;
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () => AuthController.instance.switchFamilyMember(member.id),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryNavy : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryNavy : AppColors.borderLight,
                            width: isSelected ? 1.5 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryNavy.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isSelected ? Icons.check_circle_rounded : Icons.person_outline,
                              size: 16,
                              color: isSelected ? Colors.white : AppColors.primaryNavy,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isBn ? member.nameBn : member.nameEn,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white.withOpacity(0.2)
                                    : AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isBn ? member.relationBn : member.relationEn,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () => _confirmRemoveMember(context, member, isBn),
                              child: Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: isSelected ? Colors.white70 : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                // Quick add chip
                InkWell(
                  onTap: () => _showAddFamilyMemberModal(context, isBn),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.brandCyan.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.brandCyan.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 16, color: AppColors.brandCyan),
                        const SizedBox(width: 4),
                        Text(
                          isBn ? 'সদস্য যোগ' : 'Add',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brandCyan,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showAddFamilyMemberModal(BuildContext context, bool isBn) {
    final nameBnCtrl = TextEditingController();
    final nameEnCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    String selectedRelationBn = 'স্ত্রী';
    String selectedRelationEn = 'Spouse';
    String selectedBlood = 'B+';

    final relations = [
      {'bn': 'স্ত্রী', 'en': 'Spouse'},
      {'bn': 'স্বামী', 'en': 'Husband'},
      {'bn': 'সন্তান', 'en': 'Child'},
      {'bn': 'বাবা', 'en': 'Father'},
      {'bn': 'মা', 'en': 'Mother'},
      {'bn': 'ভাই', 'en': 'Brother'},
      {'bn': 'বোন', 'en': 'Sister'},
      {'bn': 'অন্যান্য', 'en': 'Other'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isBn ? 'পরিবারের সদস্য যোগ করুন' : 'Add Family Member',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryNavy,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: nameBnCtrl,
                        decoration: InputDecoration(
                          labelText: isBn ? 'সদস্যের নাম (বাংলায়)' : 'Member Name (Bangla)',
                          hintText: 'উদা: নুসরাত জাহান',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: AppColors.backgroundLight,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: nameEnCtrl,
                        decoration: InputDecoration(
                          labelText: isBn ? 'সদস্যের নাম (ইংরেজিতে)' : 'Member Name (English)',
                          hintText: 'e.g., Nusrat Jahan',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: AppColors.backgroundLight,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Relation Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedRelationBn,
                            isExpanded: true,
                            items: relations.map((rel) {
                              return DropdownMenuItem<String>(
                                value: rel['bn'],
                                child: Text(
                                  isBn ? rel['bn']! : rel['en']!,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() {
                                  selectedRelationBn = val;
                                  final match = relations.firstWhere((r) => r['bn'] == val);
                                  selectedRelationEn = match['en']!;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: ageCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: isBn ? 'বয়স' : 'Age',
                                hintText: '25',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: AppColors.backgroundLight,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.borderLight),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedBlood,
                                  isExpanded: true,
                                  items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-', 'N/A']
                                      .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setModalState(() => selectedBlood = val);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryNavy,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            final nameBn = nameBnCtrl.text.trim();
                            final nameEn = nameEnCtrl.text.trim();
                            if (nameBn.isEmpty && nameEn.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.sosRed,
                                  content: Text(
                                    isBn ? 'সদস্যের নাম লিখুন' : 'Please enter member name',
                                  ),
                                ),
                              );
                              return;
                            }
                            final age = int.tryParse(ageCtrl.text) ?? 0;
                            final newMember = FamilyMember(
                              id: 'fam_${DateTime.now().millisecondsSinceEpoch}',
                              nameBn: nameBn.isNotEmpty ? nameBn : nameEn,
                              nameEn: nameEn.isNotEmpty ? nameEn : nameBn,
                              relationBn: selectedRelationBn,
                              relationEn: selectedRelationEn,
                              age: age,
                              bloodGroup: selectedBlood,
                            );
                            AuthController.instance.addFamilyMember(newMember);
                            Navigator.of(ctx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.emeraldGreen,
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  isBn
                                      ? 'পারিবারিক সদস্য সফলভাবে যুক্ত হয়েছে!'
                                      : 'Family member added successfully!',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            isBn ? 'সদস্য যুক্ত করুন' : 'Add Member',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmRemoveMember(BuildContext context, FamilyMember member, bool isBn) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isBn ? 'সদস্য মুছে ফেলবেন?' : 'Remove Member?'),
        content: Text(
          isBn
              ? '${member.nameBn} কে পরিবারের তালিকা থেকে মুছে ফেলতে চান?'
              : 'Remove ${member.nameEn} from family members?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(isBn ? 'না' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sosRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              AuthController.instance.removeFamilyMember(member.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primaryNavy,
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    isBn ? 'সদস্য তালিকা থেকে মুছে ফেলা হয়েছে' : 'Member removed successfully',
                  ),
                ),
              );
            },
            child: Text(isBn ? 'হ্যাঁ, মুছুন' : 'Remove'),
          ),
        ],
      ),
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
                ? 'ব্যক্তিগত প্রেসক্রিপশন, ল্যাব টেস্ট ফলাফল ও পরিবারিক হেলথ রেকর্ড দেখতে লগইন বা প্রোফাইল পূরণ করুন।'
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
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.brandCyan,
                side: const BorderSide(color: AppColors.brandCyan),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.edit_note_rounded, size: 18),
              label: Text(
                isBn ? 'সরাসরি প্রোফাইল তথ্য পূরণ করুন' : 'Fill Profile Directly',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
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
