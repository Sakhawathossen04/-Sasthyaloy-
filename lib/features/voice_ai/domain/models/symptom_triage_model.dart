class AiChatMessage {
  final String id;
  final String sender; // 'user' or 'ai'
  final String text;
  final String timestamp;
  final bool isEmergency;
  final String? recommendedSpecialist;
  final String? firstAidAdvice;
  final List<String> homeRemedies;

  const AiChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.isEmergency = false,
    this.recommendedSpecialist,
    this.firstAidAdvice,
    this.homeRemedies = const [],
  });
}

class ClinicalTriageEngine {
  static AiChatMessage analyzeSymptoms(String query, bool isBn) {
    final lower = query.toLowerCase();

    // 1. Red Flag Emergency Triggers
    final isChestPain = lower.contains('বুক') ||
        lower.contains('বুকে') ||
        lower.contains('হার্ট') ||
        lower.contains('chest') ||
        lower.contains('heart');

    final isSevereBreathlessness = lower.contains('শ্বাসকষ্ট') ||
        lower.contains('দম') ||
        lower.contains('breath') ||
        lower.contains('choking');

    final isStroke = lower.contains('প্যারালাইসিস') ||
        lower.contains('মুখ বাকা') ||
        lower.contains('কথা জড়িয়ে') ||
        lower.contains('stroke') ||
        lower.contains('paralysis');

    if (isChestPain || isSevereBreathlessness || isStroke) {
      return AiChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'ai',
        isEmergency: true,
        recommendedSpecialist: isBn ? 'কার্ডিওলজিস্ট ও জরুরি বিভাগ' : 'Emergency & Cardiology',
        firstAidAdvice: isBn
            ? '১. রোগীকে অবিলম্বে শান্ত ও আরামদায়ক অবস্থানে বসিয়ে দিন।\n২. টাইট জামাকাপড় ঢিলা করে পর্যাপ্ত বাতাস নিশ্চিত করুন।\n৩. দেরি না করে দ্রুত নিকটস্থ হাসপাতালের জরুরি বিভাগে নিয়ে যান।'
            : '1. Place patient in comfortable semi-seated posture.\n2. Loosen tight clothing and ensure fresh ventilation.\n3. Rush to nearest emergency department without delay.',
        text: isBn
            ? '⚠️ জরুরি মেডিকেল সতর্কতা (Red Flag Alert): আপনার উল্লিখিত লক্ষণসমূহ (বুকে চাপ/তীব্র শ্বাসকষ্ট) একটি জরুরি কার্ডিয়াক বা শ্বাসতন্ত্রের ঝুঁকির ইঙ্গিত দিতে পারে। অনুগ্রহ করে এখনই জরুরি হেল্পলাইনে কল করুন।'
            : '⚠️ Critical Emergency Warning (Red Flag): Your described symptoms (chest pain/severe breathlessness) may signify acute cardiovascular or respiratory distress. Please dial emergency immediately.',
        timestamp: 'Just now',
      );
    }

    // 2. Gastric / Acidity
    if (lower.contains('গ্যাস') ||
        lower.contains('পেট') ||
        lower.contains('অ্যাসিড') ||
        lower.contains('stomach') ||
        lower.contains('gastric') ||
        lower.contains('acidity')) {
      return AiChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'ai',
        isEmergency: false,
        recommendedSpecialist: isBn ? 'গ্যাস্ট্রোএন্টারোলজিস্ট / মেডিসিন' : 'Gastroenterologist',
        homeRemedies: isBn
            ? [
                'ভাজা-পোড়া ও অতিরিক্ত মশলাযুক্ত খাবার পরিহার করুন',
                'খাওয়ার পরপরই শুয়ে না পড়ে অন্তত ৩০ মিনিট অপেক্ষা করুন',
                'পর্যাপ্ত কুসুম গরম পানি ও ফাইবারযুক্ত খাবার গ্রহণ করুন'
              ]
            : [
                'Avoid fried, highly spiced or carbonated items',
                'Stay upright for at least 30 minutes after dining',
                'Drink warm water and consume soluble fiber'
              ],
        text: isBn
            ? 'আপনার লক্ষণগুলো সাধারণত গ্যাস্ট্রোইসোফেজিয়াল রিফ্লাক্স বা হাইপারঅ্যাসিডিটির লক্ষণ হতে পারে। নিচের ঘরোয়া নিয়ম মেনে চলুন এবং প্রয়োজনে বিশেষজ্ঞ চিকিৎসকের পরামর্শ নিন।'
            : 'Your symptoms resemble acid reflux or gastritis. Consider dietary adjustments and schedule a consultation with a Gastroenterologist if discomfort persists.',
        timestamp: 'Just now',
      );
    }

    // 3. Fever / Flu / Headache
    if (lower.contains('জ্বর') ||
        lower.contains('কাশি') ||
        lower.contains('মাথাব্যথা') ||
        lower.contains('fever') ||
        lower.contains('cough') ||
        lower.contains('headache')) {
      return AiChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'ai',
        isEmergency: false,
        recommendedSpecialist: isBn ? 'জেনারেল ফিজিশিয়ান (General Practitioner)' : 'General Practitioner',
        homeRemedies: isBn
            ? [
                'পর্যাপ্ত বিশ্রাম ও স্বাভাবিক পানীয় গ্রহণ করুন',
                'কুসুম গরম লবণ-পানি দিয়ে দিনে ৩ বার গার্গল করুন',
                'শরীরের তাপমাত্রা ১০১°F এর বেশি হলে চিকিৎসকের পরামর্শ নিন'
              ]
            : [
                'Get ample rest and maintain electrolyte hydration',
                'Gargle with warm saline water thrice daily',
                'Seek medical evaluation if fever exceeds 101°F for >48h'
              ],
        text: isBn
            ? 'এটি সাধারণ মৌসুমি ফ্লু বা ভাইরাল ইনফেকশন হতে পারে। প্রচুর পানি পান করুন ও পর্যাপ্ত বিশ্রাম নিন। ৩ দিনের বেশি অব্যাহত থাকলে ডাক্তারের পরামর্শ নেওয়া বাঞ্ছনীয়।'
            : 'These symptoms are consistent with seasonal viral flu or mild pharyngitis. Rest well, hydrate, and book a consultation if symptoms persist over 3 days.',
        timestamp: 'Just now',
      );
    }

    // 4. Default Clinical Guidance
    return AiChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'ai',
      isEmergency: false,
      recommendedSpecialist: isBn ? 'জেনারেল ফিজিশিয়ান (General Physician)' : 'General Physician',
      homeRemedies: isBn
          ? [
              'নিয়মিত রক্তচাপ ও পর্যাপ্ত পানি পান বজায় রাখুন',
              'লক্ষণগুলোর সময়কাল ও তীব্রতা নোট করে রাখুন'
            ]
          : [
              'Monitor baseline vitals and fluid intake',
              'Record onset duration and intensity of symptoms'
            ],
      text: isBn
          ? 'আপনার স্বাস্থ্য সম্পর্কিত প্রশ্নটি বিশ্লেষণ করা হয়েছে। সঠিক রোগ নির্ণয়ের জন্য আমাদের বিশেষজ্ঞ ডাক্তারদের সাথে অ্যাপয়েন্টমেন্ট বা টেলি-কনসাল্টেশন গ্রহণ করতে পারেন।'
          : 'Your symptom description has been reviewed. For accurate clinical diagnosis, consider booking an in-person or video consultation with our verified doctors.',
      timestamp: 'Just now',
    );
  }
}
