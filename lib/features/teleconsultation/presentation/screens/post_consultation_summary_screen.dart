import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../my_health/presentation/screens/prescriptions_screen.dart';

class PostConsultationSummaryScreen extends StatelessWidget {
  final String doctorNameBn;
  final String doctorNameEn;
  final String specialityBn;
  final String specialityEn;
  final String callDuration;

  const PostConsultationSummaryScreen({
    super.key,
    required this.doctorNameBn,
    required this.doctorNameEn,
    required this.specialityBn,
    required this.specialityEn,
    required this.callDuration,
  });

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          isBn ? 'কনসালটেশন সারসংক্ষেপ' : 'Consultation Summary',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.primaryNavy),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Success Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCFCE7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle_rounded, color: AppColors.emeraldGreen, size: 48),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    isBn ? 'ভিডিও কনসালটেশন সম্পন্ন!' : 'Teleconsultation Completed!',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isBn
                        ? '$doctorNameBn-এর সাথে আপনার $callDuration সময়ের ভিডিও কল সেশন সফল হয়েছে।'
                        : 'Your $callDuration video consultation with $doctorNameEn was successful.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem(isBn ? 'কলের সময়' : 'Duration', callDuration, Icons.timer_outlined),
                      _buildSummaryItem(isBn ? 'স্ট্যাটাস' : 'Status', isBn ? 'সম্পন্ন' : 'Completed', Icons.verified_outlined),
                      _buildSummaryItem(isBn ? 'কোয়ালিটি' : 'Quality', 'HD 1080p', Icons.high_quality_outlined),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // E-Prescription Generated Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.receipt_long_rounded, color: AppColors.brandCyan, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            isBn ? 'ডিজিটাল ই-প্রেসক্রিপশন' : 'Digital E-Prescription',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldGreen.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isBn ? 'স্বাক্ষরিত' : 'Signed',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.emeraldGreen),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isBn
                        ? 'চিকিৎসক আপনার জন্য ই-প্রেসক্রিপশন ইস্যু করেছেন। এটি আপনার "মাই হেলথ" সেকশনে স্থায়ীভাবে সংরক্ষিত থাকবে।'
                        : 'Doctor has issued your e-prescription, permanently accessible under "My Health".',
                    style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.35),
                  ),
                  const SizedBox(height: 16),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryNavy,
                            side: const BorderSide(color: AppColors.borderLight),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const PrescriptionsScreen()),
                            );
                          },
                          icon: const Icon(Icons.visibility_outlined, size: 18),
                          label: Text(isBn ? 'প্রেসক্রিপশন ভিউ' : 'View Rx'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryNavy,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.emeraldGreen,
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  isBn ? 'ই-প্রেসক্রিপশন পিডিএফ ডাউনলোড হচ্ছে...' : 'Downloading E-Prescription PDF...',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.download_rounded, size: 18),
                          label: Text(isBn ? 'ডাউনলোড' : 'Download'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Return to Home
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  isBn ? 'হোম ড্যাশবোর্ডে ফিরে যান' : 'Back to Dashboard',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.brandCyan),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
