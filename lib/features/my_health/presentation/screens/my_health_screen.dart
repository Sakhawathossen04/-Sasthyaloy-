import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../auth/domain/controllers/auth_controller.dart';
import '../../../auth/domain/models/user_profile_model.dart';
import '../../../auth/presentation/screens/edit_profile_screen.dart';
import 'lab_reports_screen.dart';
import 'prescriptions_screen.dart';
import 'vital_signs_screen.dart';

class MyHealthScreen extends StatelessWidget {
  const MyHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          isBn ? 'আমার স্বাস্থ্য (My Health)' : 'My Health',
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Patient Profile Card (Synced with AuthController)
              ValueListenableBuilder<UserProfileModel>(
                valueListenable: AuthController.instance.userNotifier,
                builder: (context, user, _) {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.brandCyan.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person, color: AppColors.primaryNavy, size: 30),
                          ),
                          const SizedBox(width: 14),
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryNavy,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.sosRed.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        user.bloodGroup,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.sosRed,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'PID: ${user.id} • ${user.age > 0 ? (isBn ? '${user.age} বছর' : '${user.age} yrs') : (isBn ? '২৮ বছর' : '28 yrs')}',
                                  style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // 2. Results Section (Diagnostic Reports)
              Text(
                isBn ? 'ল্যাব টেস্ট ও ডায়াগনস্টিক রিপোর্টস' : 'Diagnostic Reports',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    _buildReportTile(
                      icon: Icons.science_outlined,
                      title: isBn ? 'ল্যাবরেটরি টেস্ট (Laboratory)' : 'Laboratory Tests',
                      subtitle: isBn ? 'সিবিসি, লিপিড প্রোফাইল ও রক্ত পরীক্ষা' : 'Complete blood count & routine panels',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LabReportsScreen(initialCategory: 'Laboratory'),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.borderLight),
                    _buildReportTile(
                      icon: Icons.medical_services_outlined,
                      title: isBn ? 'রেডিওলজি ও ইমেজিং (Radiology)' : 'Radiology & Imaging',
                      subtitle: isBn ? 'এক্স-রে, আল্ট্রাসাউন্ড ও এমআরআই রিপোর্ট' : 'X-Ray, Ultrasound & MRI reports',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LabReportsScreen(initialCategory: 'Radiology'),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.borderLight),
                    _buildReportTile(
                      icon: Icons.biotech_outlined,
                      title: isBn ? 'মাইক্রোবায়োলজি ও অন্যান্য' : 'Microbiology & Special',
                      subtitle: isBn ? 'কালচার ও বিশেষায়িত টেস্ট রিপোর্ট' : 'Culture & specialized diagnostic tests',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LabReportsScreen(initialCategory: 'All'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Other Medical Information
              Text(
                isBn ? 'অন্যান্য স্বাস্থ্য তথ্য ও ট্র্যাকার' : 'Medical Information & Vitals',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 12),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.35,
                children: [
                  _buildInfoCard(
                    icon: Icons.monitor_heart_outlined,
                    title: isBn ? 'ভাইটাল সাইনস' : 'Vital Signs',
                    desc: isBn ? 'রক্তচাপ, সুগার ও পালস' : 'Blood pressure, sugar & pulse',
                    color: const Color(0xFF0284C7),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const VitalSignsScreen()),
                      );
                    },
                  ),
                  _buildInfoCard(
                    icon: Icons.medication_liquid_outlined,
                    title: isBn ? 'চলমান ওষুধ' : 'Medications (Rx)',
                    desc: isBn ? 'প্রেসক্রিপশন ও ওষুধের তালিকা' : 'Active prescriptions & dosage',
                    color: const Color(0xFF0D9488),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PrescriptionsScreen()),
                      );
                    },
                  ),
                  _buildInfoCard(
                    icon: Icons.assignment_outlined,
                    title: isBn ? 'দীর্ঘমেয়াদী রোগ' : 'Conditions',
                    desc: isBn ? 'উচ্চ রক্তচাপ, ডিসলিপিডেমিয়া' : 'Hypertension, Dyslipidemia',
                    color: const Color(0xFF8B5CF6),
                    onTap: () => _showConditionSheet(context, isBn),
                  ),
                  _buildInfoCard(
                    icon: Icons.shield_outlined,
                    title: isBn ? 'অ্যালার্জি হিস্ট্রি' : 'Allergies',
                    desc: isBn ? 'পেনিসিলিন ও ডাস্ট অ্যালার্জি' : 'Penicillin & seasonal dust',
                    color: const Color(0xFFE11D48),
                    onTap: () => _showAllergySheet(context, isBn),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.chipBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryNavy, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: AppColors.textPrimary),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 2),
            Text(
              desc,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  void _showConditionSheet(BuildContext context, bool isBn) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isBn ? 'দীর্ঘমেয়াদী স্বাস্থ্য সমস্যা (Chronic Conditions)' : 'Chronic Health Conditions',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
              ),
              const SizedBox(height: 14),
              _buildConditionTile('প্রাথমিক উচ্চ রক্তচাপ (Stage 1 Hypertension)', 'শনাক্তের তারিখ: ১৫ জানুয়ারি ২০২৪', Icons.favorite_border),
              const SizedBox(height: 8),
              _buildConditionTile('ডিসলিপিডেমিয়া (Mild Dyslipidemia)', 'শনাক্তের তারিখ: ০২ নভেম্বর ২০২৬', Icons.bloodtype_outlined),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(isBn ? 'ঠিক আছে' : 'OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAllergySheet(BuildContext context, bool isBn) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isBn ? 'নথিভুক্ত অ্যালার্জি ইতিহাস (Known Allergies)' : 'Known Allergies',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
              ),
              const SizedBox(height: 14),
              _buildConditionTile('পেনিসিলিন অ্যান্টিবায়োটিক সংবেদনশীলতা', 'তীব্রতা: মাঝারি (ত্বকে র‍্যাশ দেখা দেয়)', Icons.warning_amber_rounded),
              const SizedBox(height: 8),
              _buildConditionTile('মৌসুমি ডাস্ট ও ধুলোবালি অ্যালার্জি', 'তীব্রতা: মৃদু (অ্যালার্জিক রাইনাইটিস)', Icons.air_rounded),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(isBn ? 'ঠিক আছে' : 'OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConditionTile(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryNavy, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
                Text(subtitle, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
