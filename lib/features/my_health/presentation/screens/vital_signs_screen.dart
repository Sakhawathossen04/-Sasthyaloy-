import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../domain/controllers/health_record_controller.dart';
import '../../domain/models/health_record_model.dart';

class VitalSignsScreen extends StatelessWidget {
  const VitalSignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          isBn ? 'ভাইটাল সাইনস ট্র্যাকার' : 'Vital Signs Tracker',
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
      body: ValueListenableBuilder<List<VitalSignRecord>>(
        valueListenable: HealthRecordController.instance.vitalsNotifier,
        builder: (context, records, _) {
          final latest = records.isNotEmpty
              ? records.first
              : const VitalSignRecord(
                  id: '0',
                  systolicBp: 120,
                  diastolicBp: 80,
                  bloodGlucose: 5.6,
                  heartRate: 74,
                  spO2: 98,
                  temperature: 98.4,
                  weightKg: 68.5,
                  recordedDate: 'Today',
                  recordedTime: '08:30 AM',
                  notes: 'Normal',
                );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Latest Summary Banner
                Text(
                  isBn ? 'সাম্প্রতিক স্বাস্থ্য নির্দেশক (Latest Vitals)' : 'Latest Vitals',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: 12),

                // 4-Grid Cards
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  children: [
                    _buildVitalCard(
                      icon: Icons.monitor_heart_outlined,
                      label: isBn ? 'রক্তচাপ (BP)' : 'Blood Pressure',
                      value: '${latest.systolicBp}/${latest.diastolicBp}',
                      unit: 'mmHg',
                      status: isBn ? 'স্বাভাবিক (Normal)' : 'Normal',
                      color: const Color(0xFF0284C7),
                      isGood: true,
                    ),
                    _buildVitalCard(
                      icon: Icons.bloodtype_outlined,
                      label: isBn ? 'ব্লাড সুগার' : 'Blood Glucose',
                      value: latest.bloodGlucose.toStringAsFixed(1),
                      unit: 'mmol/L',
                      status: isBn ? 'নিয়ন্ত্রিত (Controlled)' : 'Controlled',
                      color: const Color(0xFF059669),
                      isGood: true,
                    ),
                    _buildVitalCard(
                      icon: Icons.favorite_outline_rounded,
                      label: isBn ? 'হার্ট রেট (পালস)' : 'Heart Rate',
                      value: '${latest.heartRate}',
                      unit: 'bpm',
                      status: isBn ? 'স্বাভাবিক (Optimal)' : 'Optimal',
                      color: const Color(0xFFE11D48),
                      isGood: true,
                    ),
                    _buildVitalCard(
                      icon: Icons.air_rounded,
                      label: isBn ? 'অক্সিজেন SpO2' : 'Blood Oxygen',
                      value: '${latest.spO2}%',
                      unit: 'SpO2',
                      status: isBn ? 'উন্নত (Healthy)' : 'Healthy',
                      color: const Color(0xFF7C3AED),
                      isGood: true,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 2. Timeline History
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isBn ? 'পূর্ববর্তী রিডিং ইতিহাস' : 'Reading History',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    Text(
                      '${records.length} ${isBn ? 'টি এন্ট্রি' : 'entries'}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, idx) {
                    final item = records[idx];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.recordedDate} • ${item.recordedTime}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.notes,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.emeraldGreen),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 14, color: AppColors.borderLight),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildMiniMetric('BP', '${item.systolicBp}/${item.diastolicBp}'),
                              _buildMiniMetric('Sugar', '${item.bloodGlucose} mmol'),
                              _buildMiniMetric('Pulse', '${item.heartRate} bpm'),
                              _buildMiniMetric('SpO2', '${item.spO2}%'),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryNavy,
        icon: const Icon(Icons.add_chart_rounded, color: Colors.white),
        label: Text(
          isBn ? 'নতুন ভাইটাল রেকর্ড' : 'Log New Vitals',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () => _showAddVitalModal(context, isBn),
      ),
    );
  }

  Widget _buildVitalCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required String status,
    required Color color,
    required bool isGood,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
        Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
      ],
    );
  }

  void _showAddVitalModal(BuildContext context, bool isBn) {
    final sysController = TextEditingController(text: '120');
    final diaController = TextEditingController(text: '80');
    final sugarController = TextEditingController(text: '5.5');
    final pulseController = TextEditingController(text: '72');
    final spO2Controller = TextEditingController(text: '98');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
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
                isBn ? 'নতুন ভাইটাল রিডিং এন্ট্রি' : 'Log Vital Signs',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: sysController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: isBn ? 'সিস্টোলিক BP' : 'Systolic BP',
                        suffixText: 'mmHg',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: diaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: isBn ? 'ডায়াস্টোলিক BP' : 'Diastolic BP',
                        suffixText: 'mmHg',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: sugarController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: isBn ? 'ব্লাড সুগার' : 'Blood Glucose',
                        suffixText: 'mmol/L',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: pulseController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: isBn ? 'হার্ট রেট' : 'Heart Rate',
                        suffixText: 'bpm',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: spO2Controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isBn ? 'অক্সিজেন স্যাচুরেশন (SpO2)' : 'SpO2 Oxygen',
                  suffixText: '%',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
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
                    final sys = int.tryParse(sysController.text) ?? 120;
                    final dia = int.tryParse(diaController.text) ?? 80;
                    final sugar = double.tryParse(sugarController.text) ?? 5.5;
                    final pulse = int.tryParse(pulseController.text) ?? 72;
                    final spo2 = int.tryParse(spO2Controller.text) ?? 98;

                    HealthRecordController.instance.addVitalSign(
                      VitalSignRecord(
                        id: 'vt_${DateTime.now().millisecondsSinceEpoch}',
                        systolicBp: sys,
                        diastolicBp: dia,
                        bloodGlucose: sugar,
                        heartRate: pulse,
                        spO2: spo2,
                        temperature: 98.4,
                        weightKg: 68.5,
                        recordedDate: isBn ? 'আজ (Now)' : 'Today (Now)',
                        recordedTime: 'Just now',
                        notes: isBn ? 'নিয়মিত পর্যবেক্ষণ' : 'Routine record',
                      ),
                    );

                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.emeraldGreen,
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          isBn ? 'ভাইটাল রিডিং সফলভাবে সংরক্ষিত হয়েছে!' : 'Vitals logged successfully!',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    isBn ? 'সংরক্ষণ করুন (Save)' : 'Save Record',
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
