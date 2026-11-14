import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';

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
    'Cardio-Thoracic Surgery',
    'Cardiology',
    'Dental Specialties',
    'Dermatology',
    'Gastroenterology',
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

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

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
            fontSize: 20,
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
                                isBn ? 'স্পেশালিটি (Speciality)' : 'Speciality',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
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
                                isBn ? 'চিকিৎসকের নাম (Physician name)' : 'Physician name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: _selectedTabIndex == 1 ? AppColors.primaryNavy : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2. Search Input
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.search, color: AppColors.textSecondary),
                        hintText: _selectedTabIndex == 0
                            ? (isBn ? 'স্পেশালিটি দিয়ে খুঁজুন' : 'Search by specialty')
                            : (isBn ? 'চিকিৎসকের নাম দিয়ে খুঁজুন' : 'Search by name'),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onChanged: (val) => setState(() {}),
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (_selectedTabIndex == 0) ...[
                    // 3. Most Common Speciality Header
                    Row(
                      children: [
                        const Icon(Icons.trending_up, color: AppColors.primaryNavy, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          isBn ? 'জনপ্রিয় স্পেশালিটি' : 'Most Common Speciality',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Chip Pills Wrap
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _mostCommonSpecialities.map((item) {
                        return InkWell(
                          onTap: () {
                            _searchController.text = item;
                            setState(() {});
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
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),

                    // 4. All Specialities Alphabetical Section
                    Row(
                      children: [
                        const Icon(Icons.medical_services_outlined, color: AppColors.primaryNavy, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          isBn ? 'সকল স্পেশালিটি (All Specialities)' : 'All Specialities',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

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
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                letter,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const Divider(height: 1, color: AppColors.borderLight),
                            ...list.map((specialityName) {
                              return InkWell(
                                onTap: () => _showDoctorListDialog(specialityName, isBn),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14.0),
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
                                          size: 20,
                                          color: AppColors.primaryNavy,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          specialityName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
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
                    // Physician Name Tab
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60.0),
                        child: Column(
                          children: [
                            Icon(Icons.person_search_outlined, size: 64, color: AppColors.textMuted.withOpacity(0.5)),
                            const SizedBox(height: 16),
                            Text(
                              isBn ? 'ডাক্তারের নাম লিখে অনুসন্ধান করুন' : 'Type physician name to search',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Alphabet Right Sidebar
          if (_selectedTabIndex == 0)
            Positioned(
              right: 4,
              top: 140,
              bottom: 40,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _alphabetSidebar.map((letter) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        letter,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
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

  void _showDoctorListDialog(String speciality, bool isBn) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                speciality,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
              ),
              const SizedBox(height: 8),
              Text(
                isBn ? 'এই স্পেশালিটিতে ৩ জন বিশেষজ্ঞ চিকিৎসক পাওয়া গেছে' : '3 specialists available in this category',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.chipBackground,
                  child: Icon(Icons.person, color: AppColors.primaryNavy),
                ),
                title: const Text('ডা. তানভীর আহমেদ', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('MBBS, FCPS | ভিজিট: ৳ ১০০০'),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(isBn ? 'বুকিং' : 'Book'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
