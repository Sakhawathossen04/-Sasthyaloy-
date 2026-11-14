class AppStrings {
  // App Identity
  static const String appNameBn = 'স্বাস্থ্যালয়';
  static const String appNameEn = 'Sasthyaloy';
  static const String taglineBn = 'সবার জন্য আধুনিক স্বাস্থ্যসেবা';
  static const String taglineEn = 'Modern Healthcare for Everyone';
  static const String subBrandingBn = 'স্বাস্থ্য ও পরিবার কল্যাণ সহযোগী';
  static const String subBrandingEn = 'Department of Digital Health';

  // Medical Disclaimer
  static const String disclaimerBn = 
      'স্বাস্থ্যালয় কোনো প্রত্যয়িত চিকিৎসকের বিকল্প নয়। যেকোনো ওষুধ বা চিকিৎসার পূর্বে অবশ্যই চিকিৎসকের পরামর্শ নিন।';
  static const String disclaimerEn = 
      'Sasthyaloy is not a substitute for professional medical advice. Always consult your physician first.';

  // Localized Map Helper
  static String tr(String key, {bool isBangla = true}) {
    final Map<String, Map<String, String>> localizedValues = {
      'welcome_banner_title': {
        'bn': 'স্বাস্থ্যালয়ে স্বাগতম!',
        'en': 'Welcome to Sasthyaloy!',
      },
      'welcome_banner_subtitle': {
        'bn': 'আপনার সুস্থতা ও স্বাচ্ছন্দ্যই আমাদের প্রধান অগ্রাধিকার।',
        'en': 'We look forward to your feedback. Enjoy the experience',
      },
      'records_banner_title': {
        'bn': 'সকল মেডিকেল রেকর্ড এক ঠিকানায়',
        'en': 'All your medical records in one place',
      },
      'records_banner_subtitle': {
        'bn': 'এক ট্যাপেই দেখুন আপনার অতীতের চিকিৎসা ইতিহাস ও রিপোর্ট।',
        'en': 'Access your medical history with a simple tap!',
      },
      'booking_banner_title': {
        'bn': 'সহজেই ডাক্তার অ্যাপয়েন্টমেন্ট',
        'en': 'Booking made Easy',
      },
      'booking_banner_subtitle': {
        'bn': 'পছন্দের বিশেষজ্ঞ চিকিৎসকের সাথে ইন-পার্সন বা ভিডিও কনসাল্ট।',
        'en': 'You can schedule a consultation with your preferred physician',
      },
      'ai_banner_title': {
        'bn': 'অসুস্থ বোধ করছেন?',
        'en': 'Feeling unwell?',
      },
      'ai_banner_subtitle': {
        'bn': 'আমাদের এআই সিম্পটম চেকার থেকে তাৎক্ষণিক পরামর্শ নিন!',
        'en': 'Let our AI Symptom Checker provide a quick assessment!',
      },
      'quick_actions': {
        'bn': 'দ্রুত সেবা (Quick Actions)',
        'en': 'Quick Actions',
      },
      'primary_care': {
        'bn': 'প্রাথমিক স্বাস্থ্যসেবা (Primary Care)',
        'en': 'Primary Care',
      },
      'primary_care_desc': {
        'bn': 'প্রাথমিক স্বাস্থ্যসেবার সুবিধা ও সার্বক্ষণিক সহায়তা জেনে নিন।',
        'en': 'Discover Primary Care and its benefits.',
      },
      'explore': {
        'bn': 'অন্বেষণ করুন',
        'en': 'Explore',
      },
      'book_appointment': {
        'bn': 'অ্যাপয়েন্টমেন্ট বুকিং',
        'en': 'Book an Appointment',
      },
      'book_appointment_desc': {
        'bn': 'আপনার পছন্দের চিকিৎসকের সাথে চেম্বারে বা ভিডিওতে দেখা করুন।',
        'en': 'You can schedule a consultation with your preferred physician, either in-person or teleconsultation.',
      },
      'speciality_or_name': {
        'bn': 'স্পেশালিটি বা ডাক্তারের নাম',
        'en': 'Speciality or Name',
      },
      'commonly_searched': {
        'bn': 'বহুল অনুসন্ধানকৃত স্পেশালিটি',
        'en': 'Commonly Searched Specialities',
      },
      'hospital_clinic': {
        'bn': 'হাসপাতাল বা ক্লিনিক নির্বাচন করুন',
        'en': 'Hospital or Clinic',
      },
      'in_person': {
        'bn': 'চেম্বারে সরাসরি',
        'en': 'In-Person',
      },
      'teleconsultation': {
        'bn': 'টেলি-কনসালটেশন',
        'en': 'Teleconsultation',
      },
      'search': {
        'bn': 'অনুসন্ধান করুন',
        'en': 'Search',
      },
      'wellness_title': {
        'bn': 'সুস্থ থাকুন, সক্রিয় থাকুন!',
        'en': 'Connect and Thrive!',
      },
      'wellness_desc': {
        'bn': 'আপনার স্মার্ট ডিভাইস যুক্ত করে সুস্থতার যাত্রা শুরু করুন!',
        'en': 'Unlock your wellness journey, today!',
      },
      'connect': {
        'bn': 'যুক্ত করুন',
        'en': 'Connect',
      },
      'guest_greeting': {
        'bn': 'স্বাগতম, অতিথি',
        'en': 'Hi, Guest',
      },
      'emergency_sos': {
        'bn': 'জরুরি SOS',
        'en': 'SOS',
      },
      // Bottom Tabs
      'tab_home': {'bn': 'হোম', 'en': 'Home'},
      'tab_health': {'bn': 'আমার স্বাস্থ্য', 'en': 'My Health'},
      'tab_ai': {'bn': 'স্বাস্থ্যালয় AI', 'en': 'Sasthyaloy AI'},
      'tab_appointments': {'bn': 'অ্যাপয়েন্টমেন্ট', 'en': 'Appointments'},
      'tab_menu': {'bn': 'মেনু', 'en': 'Menu'},
    };

    final langKey = isBangla ? 'bn' : 'en';
    return localizedValues[key]?[langKey] ?? key;
  }
}
