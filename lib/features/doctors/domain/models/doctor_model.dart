class DoctorModel {
  final String id;
  final String nameBn;
  final String nameEn;
  final String degreesBn;
  final String degreesEn;
  final String specialityBn;
  final String specialityEn;
  final String hospitalBn;
  final String hospitalEn;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final int inPersonFee;
  final int teleconsultFee;
  final bool isAvailableToday;
  final String chamberAddressBn;
  final String chamberAddressEn;
  final String aboutBn;
  final String aboutEn;
  final List<String> availableDaysBn;
  final List<String> availableDaysEn;
  final List<String> timeSlots;

  const DoctorModel({
    required this.id,
    required this.nameBn,
    required this.nameEn,
    required this.degreesBn,
    required this.degreesEn,
    required this.specialityBn,
    required this.specialityEn,
    required this.hospitalBn,
    required this.hospitalEn,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.inPersonFee,
    required this.teleconsultFee,
    required this.isAvailableToday,
    required this.chamberAddressBn,
    required this.chamberAddressEn,
    required this.aboutBn,
    required this.aboutEn,
    required this.availableDaysBn,
    required this.availableDaysEn,
    required this.timeSlots,
  });

  static List<DoctorModel> get sampleDoctors => [
        const DoctorModel(
          id: 'doc_1',
          nameBn: 'অধ্যাপক ডা. তানভীর আহমেদ',
          nameEn: 'Prof. Dr. Tanvir Ahmed',
          degreesBn: 'এমবিবিএস, এফসিপিএস (কার্ডিওলজি), এমডি (কার্ড)',
          degreesEn: 'MBBS, FCPS (Cardiology), MD (Card)',
          specialityBn: 'কার্ডিওলজিস্ট (হৃদরোগ বিশেষজ্ঞ)',
          specialityEn: 'Cardiologist',
          hospitalBn: 'জাতীয় হৃদরোগ ইনস্টিটিউট ও হাসপাতাল',
          hospitalEn: 'National Institute of Cardiovascular Diseases',
          experienceYears: 16,
          rating: 4.9,
          reviewCount: 342,
          inPersonFee: 1200,
          teleconsultFee: 800,
          isAvailableToday: true,
          chamberAddressBn: 'স্কয়ার হাসপাতাল, পান্থপথ, ঢাকা (রুম নং ৩১৪)',
          chamberAddressEn: 'Square Hospital, Panthapath, Dhaka (Room 314)',
          aboutBn:
              'অধ্যাপক ডা. তানভীর আহমেদ দীর্ঘ ১৬ বছর ধরে হৃদরোগ চিকিৎসায় সুনামের সাথে দায়িত্ব পালন করছেন। হার্ট ফেইলিউর, উচ্চ রক্তচাপ ও জটিল কার্ডিয়াক ইন্টারভেনশনে তিনি অত্যন্ত অভিজ্ঞ।',
          aboutEn:
              'Prof. Dr. Tanvir Ahmed is a renowned cardiologist with over 16 years of clinical excellence in cardiovascular care, heart failure, and complex interventions.',
          availableDaysBn: ['রবি', 'মঙ্গল', 'বৃহস্পতি'],
          availableDaysEn: ['Sun', 'Tue', 'Thu'],
          timeSlots: [
            '05:00 PM',
            '05:30 PM',
            '06:00 PM',
            '06:30 PM',
            '07:00 PM',
            '07:30 PM',
          ],
        ),
        const DoctorModel(
          id: 'doc_2',
          nameBn: 'ডা. ফারহানা চৌধুরী',
          nameEn: 'Dr. Farhana Chowdhury',
          degreesBn: 'এমবিবিএস, ডিজিও, এফসিপিএস (গাইনি ও অবস)',
          degreesEn: 'MBBS, DGO, FCPS (Obs & Gynae)',
          specialityBn: 'স্ত্রীরোগ ও প্রসূতিবিদ্যা বিশেষজ্ঞ',
          specialityEn: 'Gynecologist & Obstetrician',
          hospitalBn: 'ঢাকা মেডিকেল কলেজ হাসপাতাল (DMCH)',
          hospitalEn: 'Dhaka Medical College Hospital',
          experienceYears: 12,
          rating: 4.8,
          reviewCount: 280,
          inPersonFee: 1000,
          teleconsultFee: 700,
          isAvailableToday: true,
          chamberAddressBn: 'ধানমন্ডি পপুলার ডায়াগনস্টিক সেন্টার, রোড ২, ঢাকা',
          chamberAddressEn: 'Popular Diagnostic Centre, Road 2, Dhanmondi, Dhaka',
          aboutBn:
              'ডা. ফারহানা চৌধুরী হাই-রিস্ক প্রেগন্যান্সি, নরমাল ডেলিভারি এবং ল্যাপারোস্কোপিক সার্জারিতে বিশেষভাবে অভিজ্ঞ।',
          aboutEn:
              'Dr. Farhana Chowdhury specializes in high-risk pregnancies, normal deliveries, and advanced gynecological laparoscopic surgeries.',
          availableDaysBn: ['শনি', 'সোম', 'বুধ'],
          availableDaysEn: ['Sat', 'Mon', 'Wed'],
          timeSlots: [
            '04:30 PM',
            '05:00 PM',
            '05:30 PM',
            '06:00 PM',
            '06:30 PM',
          ],
        ),
        const DoctorModel(
          id: 'doc_3',
          nameBn: 'ডা. রফিকুল ইসলাম',
          nameEn: 'Dr. Rafiqul Islam',
          degreesBn: 'এমবিবিএস, বিসিএস (স্বাস্থ্য), এফসিপিএস (মেডিসিন)',
          degreesEn: 'MBBS, BCS (Health), FCPS (Medicine)',
          specialityBn: 'জেনারেল ফিজিশিয়ান ও মেডিসিন বিশেষজ্ঞ',
          specialityEn: 'General Practitioner / Internal Medicine',
          hospitalBn: 'বঙ্গবন্ধু শেখ মুজিব মেডিকেল বিশ্ববিদ্যালয় (BSMMU)',
          hospitalEn: 'Bangabandhu Sheikh Mujib Medical University',
          experienceYears: 14,
          rating: 4.9,
          reviewCount: 410,
          inPersonFee: 1000,
          teleconsultFee: 600,
          isAvailableToday: true,
          chamberAddressBn: 'ইবনে সিনা স্পেশালাইজড হসপিটাল, ধানমন্ডি ১৫, ঢাকা',
          chamberAddressEn: 'Ibn Sina Specialized Hospital, Dhanmondi 15, Dhaka',
          aboutBn:
              'ডায়াবেটিস, দীর্ঘমেয়াদী জ্বর, শ্বাসকষ্ট ও অন্যান্য সাধারণ ও জটিল মেডিসিন সমস্যার নির্ভরযোগ্য বিশেষজ্ঞ পরামর্শ প্রদান করেন।',
          aboutEn:
              'Provides comprehensive clinical care for chronic diabetes, acute fevers, respiratory conditions, and internal medicine ailments.',
          availableDaysBn: ['প্রতিদিন (Daily)'],
          availableDaysEn: ['Everyday'],
          timeSlots: [
            '06:00 PM',
            '06:30 PM',
            '07:00 PM',
            '07:30 PM',
            '08:00 PM',
            '08:30 PM',
          ],
        ),
        const DoctorModel(
          id: 'doc_4',
          nameBn: 'অধ্যাপক ডা. কাজী শফিকুল হাসান',
          nameEn: 'Prof. Dr. Kazi Shafiqul Hasan',
          degreesBn: 'এমবিবিএস, এফসিপিএস (সার্জারি), এমএস (ইউরোলজি)',
          degreesEn: 'MBBS, FCPS (Surgery), MS (Urology)',
          specialityBn: 'ইউরোলজিস্ট ও কিডনি রোগ বিশেষজ্ঞ',
          specialityEn: 'Urologist & Kidney Specialist',
          hospitalBn: 'ইউনাইটেড হাসপাতাল ঢাকা',
          hospitalEn: 'United Hospital Dhaka',
          experienceYears: 20,
          rating: 5.0,
          reviewCount: 520,
          inPersonFee: 1500,
          teleconsultFee: 1000,
          isAvailableToday: false,
          chamberAddressBn: 'ইউনাইটেড হাসপাতাল, প্লট ১৫, রোড ৭১, গুলশান ২, ঢাকা',
          chamberAddressEn: 'United Hospital, Plot 15, Road 71, Gulshan 2, Dhaka',
          aboutBn:
              'কিডনি পাথর অপসারণ, প্রোস্টেট সমস্যা ও লেজার এন্ড্রোলজি সার্জারিতে দেশের অন্যতম প্রথিতযশা বিশেষজ্ঞ চিকিৎসক।',
          aboutEn:
              'One of Bangladesh\'s most reputed urological surgeons, specializing in laser stone removal, prostate treatments, and andrology.',
          availableDaysBn: ['রবি', 'বুধ'],
          availableDaysEn: ['Sun', 'Wed'],
          timeSlots: [
            '07:00 PM',
            '07:30 PM',
            '08:00 PM',
            '08:30 PM',
          ],
        ),
        const DoctorModel(
          id: 'doc_5',
          nameBn: 'ডা. মেহরীন আনজুম',
          nameEn: 'Dr. Mehreen Anjum',
          degreesBn: 'এমবিবিএস, ডিডিভি (ডার্মাটোলজি), এফসিপিএস (চর্ম ও যৌন)',
          degreesEn: 'MBBS, DDV (Dermatology), FCPS (Skin & VD)',
          specialityBn: 'চর্ম, এলার্জি ও যৌনরোগ বিশেষজ্ঞ',
          specialityEn: 'Dermatologist & Cosmetologist',
          hospitalBn: 'এভারকেয়ার হাসপাতাল ঢাকা',
          hospitalEn: 'Evercare Hospital Dhaka',
          experienceYears: 9,
          rating: 4.7,
          reviewCount: 195,
          inPersonFee: 1200,
          teleconsultFee: 750,
          isAvailableToday: true,
          chamberAddressBn: 'এভারকেয়ার হাসপাতাল, বসুন্ধরা আ/এ, ঢাকা',
          chamberAddressEn: 'Evercare Hospital, Bashundhara R/A, Dhaka',
          aboutBn:
              'ব্রণ, চুল পড়া, একজিমা, সোরিয়াসিস ও কসমেটিক লেজার থেরাপিতে আধুনিক ও ফলপ্রসূ চিকিৎসা প্রদানে সুপরিচিত।',
          aboutEn:
              'Specialist in acne treatments, alopecia, eczema, psoriasis, and advanced clinical cosmetology procedures.',
          availableDaysBn: ['শনি', 'মঙ্গল', 'বৃহস্পতি'],
          availableDaysEn: ['Sat', 'Tue', 'Thu'],
          timeSlots: [
            '05:00 PM',
            '05:30 PM',
            '06:00 PM',
            '06:30 PM',
          ],
        ),
        const DoctorModel(
          id: 'doc_6',
          nameBn: 'ডা. আসাদুজ্জামান খান',
          nameEn: 'Dr. Asaduzzaman Khan',
          degreesBn: 'এমবিবিএস, ডিসিএইচ, এমডি (শিশু রোগ)',
          degreesEn: 'MBBS, DCH, MD (Pediatrics)',
          specialityBn: 'নবজাতক ও শিশুরোগ বিশেষজ্ঞ',
          specialityEn: 'Pediatrician & Neonatologist',
          hospitalBn: 'ঢাকা শিশু হাসপাতাল',
          hospitalEn: 'Dhaka Shishu Hospital',
          experienceYears: 11,
          rating: 4.9,
          reviewCount: 310,
          inPersonFee: 900,
          teleconsultFee: 600,
          isAvailableToday: true,
          chamberAddressBn: 'গ্রীন লাইফ হাসপাতাল, গ্রীন রোড, ধানমন্ডি, ঢাকা',
          chamberAddressEn: 'Green Life Hospital, Green Road, Dhanmondi, Dhaka',
          aboutBn:
              'শিশুদের বিকাশ, পুষ্টি, টিকাদান এবং নবজাতকের নিবিড় চিকিৎসায় একজন অত্যন্ত ধৈর্যশীল ও অভিজ্ঞ শিশুরোগ বিশেষজ্ঞ।',
          aboutEn:
              'Expert in pediatric growth, infant nutrition, childhood vaccinations, and neonatal intensive monitoring.',
          availableDaysBn: ['শনি', 'সোম', 'বুধ', 'বৃহস্পতি'],
          availableDaysEn: ['Sat', 'Mon', 'Wed', 'Thu'],
          timeSlots: [
            '04:00 PM',
            '04:30 PM',
            '05:00 PM',
            '05:30 PM',
            '06:00 PM',
          ],
        ),
      ];
}
