import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../doctors/presentation/screens/speciality_search_screen.dart';
import '../../../teleconsultation/presentation/screens/payment_checkout_screen.dart';
import '../../../teleconsultation/presentation/screens/video_consultation_room_screen.dart';
import '../../domain/models/appointment_model.dart';

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
          automaticallyImplyLeading: false,
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
            // 1. Upcoming Appointments (Dynamic via AppointmentStore)
            ValueListenableBuilder<List<AppointmentModel>>(
              valueListenable: AppointmentStore.instance.appointments,
              builder: (context, appointments, _) {
                if (appointments.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.event_busy_rounded, size: 64, color: AppColors.textMuted),
                          const SizedBox(height: 16),
                          Text(
                            isBn ? 'কোনো আসন্ন অ্যাপয়েন্টমেন্ট নেই' : 'No upcoming appointments',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isBn
                                ? 'নতুন অ্যাপয়েন্টমেন্ট বুক করতে নিচের বাটনে চাপ দিন'
                                : 'Tap the button below to schedule your consultation',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: appointments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final apt = appointments[index];
                    return _buildAppointmentCard(
                      context: context,
                      isBn: isBn,
                      doctorName: isBn ? apt.doctorNameBn : apt.doctorNameEn,
                      speciality: isBn ? apt.specialityBn : apt.specialityEn,
                      date: '${apt.date}, ${apt.time}',
                      type: apt.isVideo
                          ? (isBn ? 'ভিডিও টেলি-কনসাল্টেশন' : 'Video Teleconsultation')
                          : (isBn ? 'চেম্বারে সরাসরি' : 'In-Person Consultation'),
                      isVideo: apt.isVideo,
                      status: isBn ? apt.statusBn : apt.statusEn,
                      serialNumber: apt.serialNumber,
                      fee: apt.fee,
                      hospital: isBn ? apt.hospitalBn : apt.hospitalEn,
                    );
                  },
                );
              },
            ),

            // 2. Past Appointments
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
                  serialNumber: '#SL-3019',
                  fee: 1000,
                  hospital: isBn ? 'বঙ্গবন্ধু শেখ মুজিব মেডিকেল বিশ্ববিদ্যালয়' : 'BSMMU, Dhaka',
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
    required String serialNumber,
    required int fee,
    required String hospital,
    bool isPast = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPast
                      ? AppColors.chipBackground
                      : (isVideo ? const Color(0xFFE0F2FE) : const Color(0xFFDCFCE7)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      isVideo ? Icons.videocam_rounded : Icons.apartment_rounded,
                      size: 14,
                      color: isPast
                          ? AppColors.textSecondary
                          : (isVideo ? AppColors.brandCyan : AppColors.emeraldGreen),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isPast
                            ? AppColors.textSecondary
                            : (isVideo ? AppColors.brandCyan : AppColors.emeraldGreen),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  serialNumber,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            doctorName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            speciality,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            hospital,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Divider(height: 18, color: AppColors.borderLight),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '৳ $fee',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
            ],
          ),
          if (!isPast) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isVideo ? AppColors.brandCyan : AppColors.primaryNavy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  _showAppointmentActionSheet(context, isBn, doctorName, isVideo, serialNumber);
                },
                icon: Icon(isVideo ? Icons.videocam : Icons.directions, size: 18),
                label: Text(
                  isVideo
                      ? (isBn ? 'ভিডিও কল রুমে প্রবেশ' : 'Join Video Consultation')
                      : (isBn ? 'চেম্বারের দিকনির্দেশনা ও ম্যাপ' : 'Directions & Map'),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAppointmentActionSheet(
    BuildContext context,
    bool isBn,
    String doctorName,
    bool isVideo,
    String serialNumber,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isVideo ? const Color(0xFFE0F2FE) : const Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isVideo ? Icons.videocam_rounded : Icons.local_hospital_rounded,
                  color: isVideo ? AppColors.brandCyan : AppColors.emeraldGreen,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isVideo
                    ? (isBn ? 'টেলি-কনসালটেশন ভিডিও রুম' : 'Teleconsultation Room')
                    : (isBn ? 'চেম্বার অ্যাপয়েন্টমেন্ট তথ্য' : 'Chamber Consultation Details'),
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
              ),
              const SizedBox(height: 6),
              Text(
                isBn
                    ? '$doctorName-এর সাথে আপনার সিরিয়াল $serialNumber নির্ধারিত সময়ে স্বয়ংক্রিয়ভাবে সক্রিয় হবে।'
                    : 'Your appointment ($serialNumber) with $doctorName is scheduled.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              if (isVideo) ...[
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandCyan,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VideoConsultationRoomScreen(
                            doctorNameBn: doctorName,
                            doctorNameEn: doctorName,
                            specialityBn: 'টেলিমেডিসিন কনসালটেশন',
                            specialityEn: 'Teleconsultation',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.videocam_rounded, size: 20),
                    label: Text(
                      isBn ? 'ভিডিও কল রুমে প্রবেশ করুন' : 'Join Video Consultation Room',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryNavy,
                      side: const BorderSide(color: AppColors.borderLight),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PaymentCheckoutScreen(
                            appointmentId: serialNumber,
                            doctorNameBn: doctorName,
                            doctorNameEn: doctorName,
                            specialityBn: 'টেলিমেডিসিন',
                            specialityEn: 'Teleconsultation',
                            fee: 800,
                            isVideo: true,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.payment_rounded, size: 18),
                    label: Text(
                      isBn ? 'বিকাশ / নগদ পেমেন্ট চেকআউট' : 'bKash / Nagad Checkout',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNavy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(isBn ? 'ঠিক আছে (Got it)' : 'OK'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
