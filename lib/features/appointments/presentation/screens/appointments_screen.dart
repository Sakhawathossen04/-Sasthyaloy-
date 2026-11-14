import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../doctors/presentation/screens/speciality_search_screen.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: Text(
            isBn ? 'অ্যাপয়েন্টমেন্টসমূহ' : 'Appointments',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            labelColor: AppColors.primaryNavy,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.brandCyan,
            indicatorWeight: 3,
            tabs: [
              Tab(text: isBn ? 'আসন্ন অ্যাপয়েন্টমেন্ট' : 'Upcoming'),
              Tab(text: isBn ? 'পূর্ববর্তী ইতিহাস' : 'Past Consultations'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Upcoming Tab
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildAppointmentCard(
                  context: context,
                  isBn: isBn,
                  doctorName: isBn ? 'ডা. তানভীর আহমেদ' : 'Dr. Tanvir Ahmed',
                  speciality: isBn ? 'কার্ডিওলজিস্ট (হৃদরোগ বিশেষজ্ঞ)' : 'Cardiologist',
                  date: '15 Nov 2026, 10:30 AM',
                  type: isBn ? 'ভিডিও টেলি-কনসাল্টেশন' : 'Video Teleconsultation',
                  isVideo: true,
                  status: isBn ? 'নিশ্চিতকৃত' : 'Confirmed',
                ),
                const SizedBox(height: 16),
                _buildAppointmentCard(
                  context: context,
                  isBn: isBn,
                  doctorName: isBn ? 'ডা. ফারহানা চৌধুরী' : 'Dr. Farhana Chowdhury',
                  speciality: isBn ? 'গাইনিকোলজিস্ট' : 'Gynecologist',
                  date: '18 Nov 2026, 04:00 PM',
                  type: isBn ? 'চেম্বারে সরাসরি' : 'In-Person Consultation',
                  isVideo: false,
                  status: isBn ? 'অপেক্ষমাণ' : 'Pending',
                ),
              ],
            ),

            // Past Tab
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildAppointmentCard(
                  context: context,
                  isBn: isBn,
                  doctorName: isBn ? 'ডা. রফিকুল ইসলাম' : 'Dr. Rafiqul Islam',
                  speciality: isBn ? 'জেনারেল ফিজিশিয়ান' : 'General Practitioner',
                  date: '02 Oct 2026, 11:00 AM',
                  type: isBn ? 'চেম্বারে সরাসরি' : 'In-Person',
                  isVideo: false,
                  status: isBn ? 'সম্পন্ন' : 'Completed',
                  isPast: true,
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.primaryNavy,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            isBn ? 'নতুন অ্যাপয়েন্টমেন্ট' : 'Book New',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SpecialitySearchScreen()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppointmentCard({
    required BuildContext context,
    required bool isBn,
    required String doctorName,
    required String speciality,
    required String date,
    required String type,
    required bool isVideo,
    required String status,
    bool isPast = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.chipBackground,
                child: Icon(isVideo ? Icons.videocam : Icons.person, color: AppColors.primaryNavy),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryNavy),
                    ),
                    const SizedBox(height: 2),
                    Text(speciality, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPast ? const Color(0xFFF1F5F9) : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isPast ? AppColors.textSecondary : const Color(0xFF166534),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(date, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
              const Spacer(),
              Text(type, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.brandCyan)),
            ],
          ),
          if (!isPast && isVideo) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandCyan,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.videocam_outlined, color: Colors.white),
                label: Text(isBn ? 'ভিডিও কলে যুক্ত হন' : 'Join Video Consultation'),
                onPressed: () {},
              ),
            ),
          ],
        ],
      ),
    );
  }
}
