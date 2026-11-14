import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../domain/controllers/health_record_controller.dart';
import '../../domain/models/health_record_model.dart';

class LabReportsScreen extends StatefulWidget {
  final String? initialCategory;
  const LabReportsScreen({super.key, this.initialCategory});

  @override
  State<LabReportsScreen> createState() => _LabReportsScreenState();
}

class _LabReportsScreenState extends State<LabReportsScreen> {
  late String _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialCategory ?? 'All';
  }

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          isBn ? 'ল্যাবরেটরি ও ডায়াগনস্টিক রিপোর্ট' : 'Diagnostic Lab Reports',
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
      body: Column(
        children: [
          // Filter Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', isBn ? 'সকল রিপোর্ট' : 'All Reports'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Laboratory', isBn ? 'ল্যাব টেস্ট (রক্ত/ইউরিন)' : 'Laboratory'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Radiology', isBn ? 'রেডিওলজি (এক্স-রে/এমআরআই)' : 'Radiology'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Reports List
          Expanded(
            child: ValueListenableBuilder<List<LabReport>>(
              valueListenable: HealthRecordController.instance.labReportsNotifier,
              builder: (context, reports, _) {
                final filtered = reports.where((r) {
                  if (_selectedFilter == 'All') return true;
                  return r.categoryEn.toLowerCase() == _selectedFilter.toLowerCase();
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.folder_off_outlined, size: 54, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          isBn ? 'কোনো রিপোর্ট পাওয়া যায়নি' : 'No reports found',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final report = filtered[index];
                    return _buildReportCard(report, isBn);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String category, String label) {
    final isSelected = _selectedFilter.toLowerCase() == category.toLowerCase();
    return InkWell(
      onTap: () => setState(() => _selectedFilter = category),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryNavy : AppColors.chipBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.chipText,
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(LabReport report, bool isBn) {
    final isNormal = report.status == 'Normal';

    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isNormal ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.description_rounded,
                  color: isNormal ? AppColors.emeraldGreen : Colors.orange.shade800,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBn ? report.testNameBn : report.testNameEn,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isBn ? report.hospitalBn : report.hospitalEn,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isNormal ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isNormal ? (isBn ? 'স্বাভাবিক' : 'Normal') : (isBn ? 'পর্যবেক্ষণ' : 'Warning'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isNormal ? AppColors.emeraldGreen : Colors.orange.shade900,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: AppColors.borderLight),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 5),
                  Text(
                    report.date,
                    style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '(${report.fileSize})',
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                  ),
                ],
              ),
              Row(
                children: [
                  // Offline Download Icon Button
                  IconButton(
                    icon: Icon(
                      report.isDownloaded ? Icons.cloud_done_rounded : Icons.cloud_download_outlined,
                      color: report.isDownloaded ? AppColors.emeraldGreen : AppColors.brandCyan,
                      size: 22,
                    ),
                    onPressed: () {
                      HealthRecordController.instance.toggleDownloadReport(report.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.primaryNavy,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                          content: Text(
                            report.isDownloaded
                                ? (isBn ? 'অফলাইন ক্যাশ থেকে সরানো হয়েছে' : 'Removed from offline storage')
                                : (isBn ? 'রিপোর্ট সফলভাবে অফলাইনে সেভ হয়েছে!' : 'Report downloaded for offline viewing!'),
                          ),
                        ),
                      );
                    },
                  ),
                  // View Full PDF Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNavy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _openPdfViewer(report, isBn),
                    child: Text(
                      isBn ? 'ভিউ করুন' : 'View PDF',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openPdfViewer(LabReport report, bool isBn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.82,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Drag Handle
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

              // Lab Letterhead Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
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
                          isBn ? report.hospitalBn : report.hospitalEn,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryNavy.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('OFFICIAL REPORT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
                        ),
                      ],
                    ),
                    const Divider(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(isBn ? 'রোগী: মোঃ শাকাওয়াত হোসেন' : 'Patient: Md. Sakhawat Hossen', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        Text('PID: #PT-98421', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isBn ? 'রেফারিং চিকিৎসক: ${report.referringDoctorBn}' : 'Ref by: ${report.referringDoctorEn}',
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Text(
                isBn ? report.testNameBn : report.testNameEn,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
              ),
              const SizedBox(height: 12),

              // Parameter Table Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Expanded(flex: 3, child: Text('TEST PARAMETER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                    Expanded(flex: 2, child: Text('RESULT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                    Expanded(flex: 2, child: Text('NORMAL RANGE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // Parameter List
              Expanded(
                child: ListView.separated(
                  itemCount: report.parameters.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderLight),
                  itemBuilder: (context, idx) {
                    final p = report.parameters[idx];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              p.name,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Text(
                                  '${p.result} ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: p.isAbnormal ? Colors.orange.shade800 : AppColors.primaryNavy,
                                  ),
                                ),
                                if (p.unit != '-')
                                  Text(
                                    p.unit,
                                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              p.referenceRange,
                              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              // Bottom Actions: Download & Close
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      icon: const Icon(Icons.close, size: 18),
                      label: Text(isBn ? 'বন্ধ করুন' : 'Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        HealthRecordController.instance.toggleDownloadReport(report.id);
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.emeraldGreen,
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              isBn ? 'পিডিএফ ডাউনলোড সম্পন্ন হয়েছে!' : 'PDF downloaded successfully!',
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
      ),
    );
  }
}
