import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../appointments/domain/models/appointment_model.dart';
import '../../domain/models/doctor_model.dart';

class DoctorProfileScreen extends StatefulWidget {
  final DoctorModel doctor;
  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  bool _isVideoConsult = false;
  int _selectedDayIndex = 0;
  int _selectedSlotIndex = 0;
  bool _isFavorite = false;

  final List<String> _daysBn = ['আজ (Today)', 'আগামীকাল (Tomorrow)', 'পরশু (Day After)'];
  final List<String> _daysEn = ['Today', 'Tomorrow', 'Day After'];

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;
    final doc = widget.doctor;
    final activeFee = _isVideoConsult ? doc.teleconsultFee : doc.inPersonFee;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryNavy),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isBn ? 'ডাক্তারের প্রোফাইল' : 'Doctor Profile',
          style: const TextStyle(
            color: AppColors.primaryNavy,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isFavorite ? AppColors.sosRed : AppColors.primaryNavy,
            ),
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primaryNavy,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                  content: Text(
                    _isFavorite
                        ? (isBn ? 'প্রিয় চিকিৎসকদের তালিকায় যুক্ত হয়েছে' : 'Added to favorites')
                        : (isBn ? 'তালিকা থেকে সরানো হয়েছে' : 'Removed from favorites'),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.primaryNavy),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primaryNavy,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                  content: Text(
                    isBn ? 'ডাক্তারের প্রোফাইল লিংক কপি করা হয়েছে' : 'Profile link copied',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Doctor Header Info Card
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar with verified badge
                      Stack(
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              color: AppColors.brandCyan.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.brandCyan.withOpacity(0.3), width: 1.5),
                            ),
                            child: const Center(
                              child: Icon(Icons.person_rounded, size: 50, color: AppColors.primaryNavy),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: AppColors.emeraldGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check, size: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // Text details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isBn ? doc.nameBn : doc.nameEn,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryNavy,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isBn ? doc.degreesBn : doc.degreesEn,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.chipBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isBn ? doc.specialityBn : doc.specialityEn,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.chipText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Metrics Ribbon
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetric(
                          icon: Icons.history_edu_rounded,
                          label: isBn ? 'অভিজ্ঞতা' : 'Experience',
                          value: isBn ? '${doc.experienceYears}+ বছর' : '${doc.experienceYears}+ yrs',
                        ),
                        Container(width: 1, height: 32, color: AppColors.borderLight),
                        _buildMetric(
                          icon: Icons.star_rounded,
                          label: isBn ? 'রেটিং' : 'Rating',
                          value: '${doc.rating} ⭐',
                        ),
                        Container(width: 1, height: 32, color: AppColors.borderLight),
                        _buildMetric(
                          icon: Icons.rate_review_outlined,
                          label: isBn ? 'রিভিউ' : 'Reviews',
                          value: '${doc.reviewCount}+',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 2. Consultation Type Selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBn ? 'পরামর্শের ধরন নির্বাচন করুন' : 'Select Consultation Mode',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // In-Person Chamber
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _isVideoConsult = false),
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: !_isVideoConsult ? const Color(0xFFF0F7FF) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: !_isVideoConsult ? AppColors.brandCyan : AppColors.borderLight,
                                  width: !_isVideoConsult ? 2.0 : 1.0,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.apartment_rounded,
                                    color: !_isVideoConsult ? AppColors.brandCyan : AppColors.textSecondary,
                                    size: 26,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    isBn ? 'চেম্বারে সরাসরি' : 'In-Person',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: !_isVideoConsult ? AppColors.primaryNavy : AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '৳ ${doc.inPersonFee}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: !_isVideoConsult ? AppColors.brandCyan : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Teleconsultation
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _isVideoConsult = true),
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _isVideoConsult ? const Color(0xFFF0F7FF) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _isVideoConsult ? AppColors.brandCyan : AppColors.borderLight,
                                  width: _isVideoConsult ? 2.0 : 1.0,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.video_call_rounded,
                                    color: _isVideoConsult ? AppColors.brandCyan : AppColors.textSecondary,
                                    size: 26,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    isBn ? 'টেলি-কনসাল্ট' : 'Video Call',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: _isVideoConsult ? AppColors.primaryNavy : AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '৳ ${doc.teleconsultFee}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: _isVideoConsult ? AppColors.brandCyan : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 3. Appointment Date & Slot Selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBn ? 'তারিখ ও সময় নির্বাচন' : 'Select Date & Available Slot',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Days Row
                    Row(
                      children: List.generate(3, (index) {
                        final isSelected = _selectedDayIndex == index;
                        final label = isBn ? _daysBn[index] : _daysEn[index];
                        return Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _selectedDayIndex = index),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryNavy : AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? AppColors.primaryNavy : AppColors.borderLight,
                                ),
                              ),
                              child: Text(
                                label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    // Time Slots Wrap
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(doc.timeSlots.length, (slotIdx) {
                        final slot = doc.timeSlots[slotIdx];
                        final isSelected = _selectedSlotIndex == slotIdx;
                        return InkWell(
                          onTap: () => setState(() => _selectedSlotIndex = slotIdx),
                          borderRadius: BorderRadius.circular(10),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.brandCyan : AppColors.chipBackground,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? AppColors.brandCyan : AppColors.borderLight,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: isSelected ? Colors.white : AppColors.chipText,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  slot,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? Colors.white : AppColors.chipText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 4. Chamber & Hospital Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
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
                        const Icon(Icons.location_on_outlined, color: AppColors.primaryNavy, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          isBn ? 'চেম্বার ও হাসপাতালের ঠিকানা' : 'Chamber Location',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isBn ? doc.hospitalBn : doc.hospitalEn,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isBn ? doc.chamberAddressBn : doc.chamberAddressEn,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.3),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 5. About Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBn ? 'চিকিৎসক পরিচিতি (About Doctor)' : 'About Doctor',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isBn ? doc.aboutBn : doc.aboutEn,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.45),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: AppColors.borderLight)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBn ? 'মোট ফি' : 'Total Fee',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  Text(
                    '৳ $activeFee',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => _confirmBooking(isBn, activeFee),
                child: Text(
                  isBn ? 'অ্যাপয়েন্টমেন্ট নিশ্চিত করুন' : 'Confirm Appointment',
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric({required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.brandCyan),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  void _confirmBooking(bool isBn, int fee) {
    final doc = widget.doctor;
    final randomSerial = '#SL-${1000 + Random().nextInt(9000)}';
    final dateStr = isBn ? _daysBn[_selectedDayIndex] : _daysEn[_selectedDayIndex];
    final timeStr = doc.timeSlots[_selectedSlotIndex];

    // Save to AppointmentStore
    final newAppointment = AppointmentModel(
      id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
      doctorId: doc.id,
      doctorNameBn: doc.nameBn,
      doctorNameEn: doc.nameEn,
      specialityBn: doc.specialityBn,
      specialityEn: doc.specialityEn,
      date: dateStr,
      time: timeStr,
      hospitalBn: doc.hospitalBn,
      hospitalEn: doc.hospitalEn,
      fee: fee,
      isVideo: _isVideoConsult,
      statusBn: 'নিশ্চিতকৃত',
      statusEn: 'Confirmed',
      serialNumber: randomSerial,
    );
    AppointmentStore.instance.addAppointment(newAppointment);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.emeraldGreen, size: 40),
            ),
            const SizedBox(height: 12),
            Text(
              isBn ? 'অ্যাপয়েন্টমেন্ট সফল হয়েছে!' : 'Booking Confirmed!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfirmationRow(isBn ? 'সিরিয়াল নম্বর:' : 'Serial No:', randomSerial, isHighlight: true),
            const SizedBox(height: 6),
            _buildConfirmationRow(isBn ? 'চিকিৎসক:' : 'Doctor:', isBn ? doc.nameBn : doc.nameEn),
            const SizedBox(height: 6),
            _buildConfirmationRow(isBn ? 'তারিখ ও সময়:' : 'Slot:', '$dateStr ($timeStr)'),
            const SizedBox(height: 6),
            _buildConfirmationRow(
              isBn ? 'ধরন:' : 'Type:',
              _isVideoConsult ? (isBn ? 'ভিডিও টেলি-কনসাল্ট' : 'Video Teleconsult') : (isBn ? 'চেম্বার ভিজিট' : 'In-Person Chamber'),
            ),
            const SizedBox(height: 6),
            _buildConfirmationRow(isBn ? 'ভিজিট ফি:' : 'Fee:', '৳ $fee'),
            const Divider(height: 20),
            Text(
              isBn
                  ? 'আপনার মোবাইল নম্বরে একটি নিশ্চিতকরণ এসএমএস পাঠানো হয়েছে।'
                  : 'A confirmation SMS has been sent to your registered mobile number.',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to previous screen
            },
            child: Text(isBn ? 'সম্পন্ন (Done)' : 'Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isHighlight ? AppColors.brandCyan : AppColors.primaryNavy,
          ),
        ),
      ],
    );
  }
}
