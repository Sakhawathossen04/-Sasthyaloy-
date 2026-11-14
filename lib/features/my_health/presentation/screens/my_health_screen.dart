import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';

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
              // 1. Patient Profile Card
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.chipBackground,
                      child: Icon(Icons.person, color: AppColors.primaryNavy, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isBn ? 'আহমেদ খালিদ' : 'Ahmed Khalid',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryNavy,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isBn ? 'রক্তের গ্রুপ: O+ | বয়স: ৩২' : 'Blood: O+ | Age: 32',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 2. Results Section
              Text(
                isBn ? 'ল্যাব টেস্ট ও ডায়াগনস্টিক রিপোর্টস' : 'Results',
                style: const TextStyle(
                  fontSize: 18,
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
                      title: isBn ? 'ল্যাবরেটরি টেস্ট (Laboratory)' : 'Laboratory',
                      subtitle: isBn ? 'সিবিসি, লিপিড প্রোফাইল ও রক্ত পরীক্ষা' : 'Complete blood count & routine panels',
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: AppColors.borderLight),
                    _buildReportTile(
                      icon: Icons.medical_services_outlined,
                      title: isBn ? 'রেডিওলজি (Radiology)' : 'Radiology',
                      subtitle: isBn ? 'এক্স-রে, আল্ট্রাসাউন্ড ও এমআরআই' : 'X-Ray, Ultrasound & MRI reports',
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: AppColors.borderLight),
                    _buildReportTile(
                      icon: Icons.biotech_outlined,
                      title: isBn ? 'মাইক্রোবায়োলজি (Microbiology)' : 'Microbiology',
                      subtitle: isBn ? 'কালচার ও সেনসিটিভিটি টেস্ট' : 'Culture & sensitivity test reports',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 3. Other Medical Information
              Text(
                isBn ? 'অন্যান্য স্বাস্থ্য তথ্য' : 'Other Medical Information',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 14),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _buildInfoCard(
                    icon: Icons.monitor_heart_outlined,
                    title: isBn ? 'ভাইটাল সাইনস' : 'Vital Signs',
                    desc: isBn ? 'রক্তচাপ, সুগার ও পালস' : 'Blood pressure, sugar & pulse',
                    color: const Color(0xFF0284C7),
                  ),
                  _buildInfoCard(
                    icon: Icons.medication_liquid_outlined,
                    title: isBn ? 'চলমান ওষুধ' : 'Medications',
                    desc: isBn ? 'দৈনিক প্রেসক্রিপশন রিমাইন্ডার' : 'Daily active dosage reminder',
                    color: const Color(0xFF0D9488),
                  ),
                  _buildInfoCard(
                    icon: Icons.assignment_outlined,
                    title: isBn ? 'পূর্ববর্তী রোগ' : 'Conditions',
                    desc: isBn ? 'ডায়াবেটিস, অ্যাজমা ইত্যাদি' : 'Chronic health history',
                    color: const Color(0xFF8B5CF6),
                  ),
                  _buildInfoCard(
                    icon: Icons.shield_outlined,
                    title: isBn ? 'অ্যালার্জি' : 'Allergies',
                    desc: isBn ? 'খাবার বা ওষুধের সংবেদনশীলতা' : 'Recorded drug/food allergies',
                    color: const Color(0xFFE11D48),
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
        child: Icon(icon, color: AppColors.primaryNavy, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
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
    );
  }
}
