import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../domain/models/doctor_model.dart';
import 'doctor_profile_screen.dart';

class SpecialitySearchScreen extends StatefulWidget {
  final String? initialSearch;
  const SpecialitySearchScreen({super.key, this.initialSearch});

  @override
  State<SpecialitySearchScreen> createState() => _SpecialitySearchScreenState();
}

class _SpecialitySearchScreenState extends State<SpecialitySearchScreen> {
  int _selectedTabIndex = 0; // 0 = Speciality, 1 = Physician name
  late TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();

  final List<String> _mostCommonSpecialities = [
    'Family Medicine',
    'General Practitioner',
    'Audiology',
    'Cardiac Surgery',
    'Cardiology',
    'Dental Specialties',
    'Dermatology',
    'Gastroenterology',
    'Gynecology',
    'Pediatrics',
    'Urology',
  ];

  final Map<String, List<String>> _allSpecialities = {
    'A': [
      'Aviation and aerospace Medicine',
      'Aviation Medicine',
      'Audiology',
    ],
    'C': [
      'Cardiology',
      'Cardiac Surgery',
      'Cardio-Thoracic Surgery',
      'Clinical Pathology',
    ],
    'D': [
      'Dental Specialties',
      'Dermatology',
    ],
    'F': [
      'Family Medicine',
    ],
    'G': [
      'General Practitioner',
      'Gynecology',
      'General Dentist',
      'GP Dentist',
      'Gastroenterology',
      'General Surgery',
    ],
    'I': [
      'Internal Medicine',
      'Infectious Diseases',
    ],
    'N': [
      'Neurology',
      'Nephrology',
      'Neurosurgery',
    ],
    'O': [
      'Orthopedic Surgery',
      'Ophthalmology',
      'Oncology',
    ],
    'P': [
      'Pediatrics',
      'Psychiatry',
      'Pulmonology',
    ],
    'U': [
      'Urology',
    ],
  };

  final List<String> _alphabetSidebar = ['A', 'C', 'D', 'F', 'G', 'I', 'N', 'O', 'P', 'U'];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearch ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<DoctorModel> _getFilteredDoctors() {
    final query = _searchController.text.trim().toLowerCase();
    final all = DoctorModel.sampleDoctors;
    if (query.isEmpty) return all;

    return all.where((doc) {
      final nameBn = doc.nameBn.toLowerCase();
      final nameEn = doc.nameEn.toLowerCase();
      final specBn = doc.specialityBn.toLowerCase();
      final specEn = doc.specialityEn.toLowerCase();
      final hospBn = doc.hospitalBn.toLowerCase();
      final hospEn = doc.hospitalEn.toLowerCase();
      return nameBn.contains(query) ||
          nameEn.contains(query) ||
          specBn.contains(query) ||
          specEn.contains(query) ||
          hospBn.contains(query) ||
          hospEn.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;
    final doctors = _getFilteredDoctors();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryNavy),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isBn ? 'স্পেশালিটি বা চিকিৎসকের নাম' : 'Speciality or Name',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // 1. Segmented Control Toggle
                  Container(
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _selectedTabIndex = 0),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _selectedTabIndex == 0 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: _selectedTabIndex == 0
                                    ? [const BoxShadow(color: Color(0x10000000), blurRadius: 4, offset: Offset(0, 1))]
                                    : null,
                              ),
                              child: Text(
                                isBn ? 'স্পেশালিটি' : 'Speciality',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                  color: _selectedTabIndex == 0 ? AppColors.primaryNavy : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _selectedTabIndex = 1),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _selectedTabIndex == 1 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: _selectedTabIndex == 1
                                    ? [const BoxShadow(color: Color(0x10000000), blurRadius: 4, offset: Offset(0, 1))]
                                    : null,
                              ),
                              child: Text(
                                isBn ? 'চিকিৎসকদের তালিকা (${DoctorModel.sampleDoctors.length})' : 'Doctors (${DoctorModel.sampleDoctors.length})',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                  color: _selectedTabIndex == 1 ? AppColors.primaryNavy : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 2. Search Input Field
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.search, color: AppColors.textSecondary),
                        hintText: _selectedTabIndex == 0
                            ? (isBn ? 'স্পেশালিটি দিয়ে খুঁজুন' : 'Search by specialty')
                            : (isBn ? 'চিকিৎসক, স্পেশালিটি বা হাসপাতাল' : 'Search doctor, specialty or hospital'),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                      ),
                      onChanged: (val) => setState(() {}),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // TAB 0: SPECIALITIES
                  if (_selectedTabIndex == 0) ...[
                    // Common Specialities
                    Row(
                      children: [
                        const Icon(Icons.trending_up, color: AppColors.primaryNavy, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          isBn ? 'জনপ্রিয় স্পেশালিটি' : 'Most Common Speciality',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Chip Pills Wrap
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _mostCommonSpecialities.map((item) {
                        return InkWell(
                          onTap: () {
                            _showDoctorsForSpeciality(item, isBn);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.chipBackground,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item,
                              style: const TextStyle(
                                color: AppColors.chipText,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // All Specialities Alphabetical Section
                    Row(
                      children: [
                        const Icon(Icons.medical_services_outlined, color: AppColors.primaryNavy, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          isBn ? 'সকল স্পেশালিটি' : 'All Specialities',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Alphabet Grouped List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _allSpecialities.keys.length,
                      itemBuilder: (context, idx) {
                        final letter = _allSpecialities.keys.elementAt(idx);
                        final list = _allSpecialities[letter]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Text(
                                letter,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const Divider(height: 1, color: AppColors.borderLight),
                            ...list.map((specialityName) {
                              return InkWell(
                                onTap: () => _showDoctorsForSpeciality(specialityName, isBn),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.borderLight),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.medical_information_outlined,
                                          size: 18,
                                          color: AppColors.primaryNavy,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          specialityName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color: AppColors.textMuted,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ] else ...[
                    // TAB 1: PHYSICIAN / DOCTOR DIRECTORY
                    if (doctors.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Column(
                            children: [
                              const Icon(Icons.person_off_rounded, size: 54, color: AppColors.textMuted),
                              const SizedBox(height: 12),
                              Text(
                                isBn
                                    ? 'কোনো চিকিৎসক পাওয়া যায়নি'
                                    : 'No doctors matched your search',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isBn ? 'অন্য কোনো নাম বা স্পেশালিটি দিয়ে চেষ্টা করুন' : 'Try searching another specialty or name',
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: doctors.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final doc = doctors[index];
                          return _buildDoctorCard(doc, isBn);
                        },
                      ),
                    const SizedBox(height: 40),
                  ],
                ],
              ),
            ),
          ),

          // Alphabet Right Sidebar for Specialities
          if (_selectedTabIndex == 0)
            Positioned(
              right: 2,
              top: 140,
              bottom: 40,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _alphabetSidebar.map((letter) {
                    return InkWell(
                      onTap: () {
                        // Filter by letter
                        _searchController.text = letter;
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(DoctorModel doc, bool isBn) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
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
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: AppColors.brandCyan.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.person, color: AppColors.primaryNavy, size: 36),
                  ),
                  if (doc.isAvailableToday)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.emeraldGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBn ? doc.nameBn : doc.nameEn,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isBn ? doc.degreesBn : doc.degreesEn,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isBn ? doc.specialityBn : doc.specialityEn,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brandCyan,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Hospital info
          Row(
            children: [
              const Icon(Icons.apartment_rounded, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isBn ? doc.hospitalBn : doc.hospitalEn,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(height: 18, color: AppColors.borderLight),
          // Rating and Booking Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${doc.rating} (${doc.reviewCount})',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isBn ? '• ${doc.experienceYears}+ বছর' : '• ${doc.experienceYears}+ yrs',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '৳ ${doc.inPersonFee} (ভিজিট)',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.emeraldGreen),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DoctorProfileScreen(doctor: doc),
                    ),
                  );
                },
                child: Text(
                  isBn ? 'বুকিং করুন' : 'Book Now',
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDoctorsForSpeciality(String speciality, bool isBn) {
    // Find matching doctors or use first few
    final all = DoctorModel.sampleDoctors;
    final matched = all.where((d) =>
        d.specialityEn.toLowerCase().contains(speciality.toLowerCase()) ||
        speciality.toLowerCase().contains(d.specialityEn.toLowerCase())).toList();
    final displayDocs = matched.isNotEmpty ? matched : all.take(2).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
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
                speciality,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
              ),
              const SizedBox(height: 4),
              Text(
                isBn
                    ? '${displayDocs.length} জন বিশেষজ্ঞ চিকিৎসক পাওয়া গেছে'
                    : '${displayDocs.length} specialist doctors available',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: displayDocs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, idx) {
                    final doc = displayDocs[idx];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.brandCyan.withOpacity(0.15),
                            child: const Icon(Icons.person, color: AppColors.primaryNavy, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isBn ? doc.nameBn : doc.nameEn,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                                ),
                                Text(
                                  isBn ? doc.degreesBn : doc.degreesEn,
                                  style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '৳ ${doc.inPersonFee}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.emeraldGreen),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryNavy,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DoctorProfileScreen(doctor: doc),
                                ),
                              );
                            },
                            child: Text(
                              isBn ? 'প্রোফাইল' : 'View',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
