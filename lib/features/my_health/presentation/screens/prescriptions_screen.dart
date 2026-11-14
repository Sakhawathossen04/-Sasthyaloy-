import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../domain/controllers/health_record_controller.dart';
import '../../domain/models/health_record_model.dart';

class PrescriptionsScreen extends StatelessWidget {
  const PrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          isBn ? 'ডিজিটাল প্রেসক্রিপশন ও ওষুধ' : 'Digital Prescriptions',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryNavy),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ValueListenableBuilder<List<PrescriptionRecord>>(
        valueListenable: HealthRecordController.instance.prescriptionsNotifier,
        builder: (context, rxList, _) {
          if (rxList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.medication_rounded, size: 54, color: AppColors.textMuted),
                  const SizedBox(height: 12),
                  Text(
                    isBn ? 'কোনো প্রেসক্রিপশন সংরক্ষিত নেই' : 'No prescriptions recorded',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: rxList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final rx = rxList[index];
              return _buildPrescriptionCard(context, rx, isBn);
            },
          );
        },
      ),
    );
  }

  Widget _buildPrescriptionCard(BuildContext context, PrescriptionRecord rx, bool isBn) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Doctor Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.brandCyan.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.receipt_long_rounded, color: AppColors.primaryNavy, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBn ? rx.doctorNameBn : rx.doctorNameEn,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      rx.degrees,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isBn ? rx.hospitalBn : rx.hospitalEn,
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Text(
                rx.date,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Diagnosis Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.chipBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.healing_rounded, size: 14, color: AppColors.brandCyan),
                const SizedBox(width: 6),
                Text(
                  '${isBn ? "রোগ নির্ণয়:" : "Diagnosis:"} ${isBn ? rx.diagnosisBn : rx.diagnosisEn}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                ),
              ],
            ),
          ),

          const Divider(height: 22, color: AppColors.borderLight),

          // Prescribed Medicines Heading
          Text(
            isBn ? 'নির্দেশিত ওষুধসমূহ (Rx):' : 'Prescribed Medicines (Rx):',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
          ),
          const SizedBox(height: 10),

          // Medicines List
          ...rx.medicines.map((med) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const Icon(Icons.medication_liquid_rounded, color: AppColors.emeraldGreen, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          med.name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                        ),
                        Text(
                          '${med.generic} • ${isBn ? med.instructionBn : med.instructionEn}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Text(
                      med.dosage,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 10),

          // Advice Text
          Text(
            '${isBn ? "পরামর্শ:" : "Advice:"} ${isBn ? rx.adviceBn : rx.adviceEn}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
          ),

          const SizedBox(height: 14),

          // Refill Action
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNavy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primaryNavy,
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      isBn ? 'প্রেসক্রিপশনটি হোম ডেলিভারির জন্য প্রস্তুত করা হচ্ছে...' : 'Ordering medicines for home delivery...',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.local_pharmacy_rounded, size: 18),
              label: Text(
                isBn ? 'ওষুধ হোম ডেলিভারি অর্ডার করুন' : 'Order Medicine Delivery',
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
