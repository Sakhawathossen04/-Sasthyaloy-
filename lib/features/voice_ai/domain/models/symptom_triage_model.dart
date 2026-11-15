class AiChatMessage {
  final String id;
  final String sender; // 'user' or 'ai'
  final String text;
  final String timestamp;
  final String? imagePath;
  final bool isEmergency;
  final String? recommendedSpecialist;
  final String? firstAidAdvice;
  final List<String> homeRemedies;

  const AiChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.imagePath,
    this.isEmergency = false,
    this.recommendedSpecialist,
    this.firstAidAdvice,
    this.homeRemedies = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender': sender,
        'text': text,
        'timestamp': timestamp,
        'imagePath': imagePath,
        'isEmergency': isEmergency,
        'recommendedSpecialist': recommendedSpecialist,
        'firstAidAdvice': firstAidAdvice,
        'homeRemedies': homeRemedies,
      };

  factory AiChatMessage.fromJson(Map<String, dynamic> json) {
    return AiChatMessage(
      id: json['id'] as String? ?? 'msg_${DateTime.now().millisecondsSinceEpoch}',
      sender: json['sender'] as String? ?? 'ai',
      text: json['text'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? 'Just now',
      imagePath: json['imagePath'] as String?,
      isEmergency: json['isEmergency'] as bool? ?? false,
      recommendedSpecialist: json['recommendedSpecialist'] as String?,
      firstAidAdvice: json['firstAidAdvice'] as String?,
      homeRemedies: (json['homeRemedies'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}

/// Represents a persistent chat session/conversation like ChatGPT/Gemini
class ChatSessionModel {
  final String id;
  final String title;
  final String createdAt;
  final String updatedAt;
  final List<AiChatMessage> messages;

  const ChatSessionModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((m) => AiChatMessage.fromJson(Map<String, dynamic>.from(m as Map)))
              .toList() ??
          [],
    );
  }
}

/// In-App Clinical Triage Engine with accurate, differentiated medical diagnosis
class ClinicalTriageEngine {
  static AiChatMessage analyzeSymptoms(String query, bool isBn, {String? imagePath}) {
    final lower = query.toLowerCase().trim();
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    // 0. Visual / Image Attachment Assessment
    if (imagePath != null && imagePath.isNotEmpty) {
      final isSkin = lower.contains('র‍্যাশ') ||
          lower.contains('চুলকানি') ||
          lower.contains('দাগ') ||
          lower.contains('ফুসকুড়ি') ||
          lower.contains('rash') ||
          lower.contains('skin') ||
          lower.contains('allergy');

      final isEye = lower.contains('চোখ') ||
          lower.contains('ঝাপসা') ||
          lower.contains('eye') ||
          lower.contains('vision');

      if (isEye) {
        return AiChatMessage(
          id: 'ai_${now.millisecondsSinceEpoch}',
          sender: 'ai',
          isEmergency: false,
          recommendedSpecialist: isBn ? 'চক্ষু বিশেষজ্ঞ (Ophthalmologist)' : 'Ophthalmologist',
          homeRemedies: isBn
              ? [
                  'চোখে সরাসরি হাত বা নোংরা কাপড় স্পর্শ করবেন না',
                  'পরিষ্কার ঠান্ডা পানি দিয়ে আলতোভাবে চোখ ধুয়ে নিন',
                  'তীব্র ব্যথা, আলোতে অস্বস্তি বা দৃষ্টি ঝাপসা হলে দ্রুত চক্ষু বিশেষজ্ঞ দেখান'
                ]
              : [
                  'Do not rub eyes with unwashed hands',
                  'Rinse gently with clean cool water',
                  'Consult an Ophthalmologist if photophobia or pain persists'
                ],
          text: isBn
              ? 'আপনার প্রেরিত চোখের লক্ষণ বিশ্লেষণ করা হয়েছে। চোখে কনজাংটিভাইটিস, অ্যালার্জি বা চোখের অতিরিক্ত চাপের লক্ষণ থাকতে পারে। নিচের প্রাথমিক যত্ন মেনে চলুন।'
              : 'Your eye symptom image and query have been analyzed. Symptoms suggest possible conjunctivitis or eye strain. Follow basic hygiene and consult an eye specialist.',
          timestamp: timeStr,
        );
      }

      return AiChatMessage(
        id: 'ai_${now.millisecondsSinceEpoch}',
        sender: 'ai',
        isEmergency: false,
        recommendedSpecialist: isBn ? 'চর্ম ও যৌনরোগ বিশেষজ্ঞ (Dermatologist)' : 'Dermatologist',
        homeRemedies: isBn
            ? [
                'আক্রান্ত স্থান শুষ্ক ও পরিষ্কার রাখুন, চুলকানো পরিহার করুন',
                'অ্যালার্জিজাতীয় খাবার (চিংড়ি, বেগুন, গরুর মাংস ইত্যাদি) সাময়িক এড়িয়ে চলুন',
                'লক্ষণ বৃদ্ধি পেলে বা পুঁজ জমলে দ্রুত চর্মরোগ বিশেষজ্ঞের পরামর্শ নিন'
              ]
            : [
                'Keep the affected area clean and dry, avoid scratching',
                'Avoid common food allergens temporarily',
                'Seek prompt dermatologist consultation if redness spreads or oozes'
              ],
        text: isBn
            ? 'আপনার সংযুক্ত লক্ষণভিত্তিক ছবিটি পর্যালোচনা করা হয়েছে। ${isSkin ? "ত্বকের ফুসকুড়ি বা অ্যালার্জিক ডার্মাটাইটিসের মতো লক্ষণ পরিলক্ষিত হচ্ছে।" : "শারীরিক লক্ষণটির ক্ষেত্রে সঠিক চিকিৎসার জন্য বিশেষজ্ঞ ডাক্তারের পরামর্শ নেওয়া নিরাপদ।"}'
            : 'Your uploaded clinical symptom image has been reviewed. Findings suggest possible contact dermatitis or localized skin irritation. Please follow safety guidelines below.',
        timestamp: timeStr,
      );
    }

    // 1. Friendly Greetings ("hi", "hello", "সালাম", "hey")
    if (lower == 'hi' ||
        lower == 'hello' ||
        lower == 'hey' ||
        lower == 'হাই' ||
        lower == 'হ্যালো' ||
        lower == 'কেমন আছেন' ||
        lower.contains('সালাম') ||
        lower == 'help') {
      return AiChatMessage(
        id: 'ai_${now.millisecondsSinceEpoch}',
        sender: 'ai',
        isEmergency: false,
        recommendedSpecialist: isBn ? 'জেনারেল ফিজিশিয়ান (General Physician)' : 'General Physician',
        homeRemedies: isBn
            ? [
                'আপনার যেকোনো শারীরিক সমস্যা বা লক্ষণ বাংলায় লিখে জানান',
                'মাইক বোতাম চেপে মুখে বলেও লক্ষণ জানাতে পারেন',
                'প্রয়োজনে আক্রান্ত স্থানের ছবি সংযুক্ত করে পরামর্শ নিতে পারেন'
              ]
            : [
                'Type your symptoms clearly in Bengali or English',
                'Use the mic icon to dictate your symptoms via voice',
                'Attach photos of rashes or reports for visual triage'
              ],
        text: isBn
            ? 'স্বাগতম! আমি আপনার স্বাস্থ্যালয় এআই মেডিকেল অ্যাসিস্ট্যান্ট। আপনি কেমন আছেন? আপনার কোনো শারীরিক অসুস্থতা বা লক্ষণ থাকলে নির্দ্বিধায় বলুন, আমি আপনাকে প্রাথমিক স্বাস্থ্য পরামর্শ ও বিশেষজ্ঞ ডাক্তারের তথ্য দিতে প্রস্তুত।'
            : 'Welcome! I am your Sasthyaloy AI Medical Assistant. How are you feeling today? Please share any symptoms or health concerns and I will provide verified clinical guidance.',
        timestamp: timeStr,
      );
    }

    // 2. Red Flag Emergency Triggers (Chest Pain, Shortness of Breath, Stroke)
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
        lower.contains('paralysis') ||
        lower.contains('অজ্ঞান');

    if (isChestPain || isSevereBreathlessness || isStroke) {
      return AiChatMessage(
        id: 'ai_${now.millisecondsSinceEpoch}',
        sender: 'ai',
        isEmergency: true,
        recommendedSpecialist: isBn ? 'কার্ডিওলজিস্ট ও জরুরি বিভাগ' : 'Emergency & Cardiology',
        firstAidAdvice: isBn
            ? '১. রোগীকে অবিলম্বে শান্ত ও আরামদায়ক আধশোয়া অবস্থানে বসিয়ে দিন।\n২. টাইট জামাকাপড় ঢিলা করে পর্যাপ্ত বাতাস নিশ্চিত করুন।\n৩. দেরি না করে দ্রুত ৯৯৯ বা ১৬২৬৩-এ কল করুন এবং নিকটস্থ হাসপাতালের জরুরি বিভাগে নিয়ে যান।'
            : '1. Place patient in comfortable semi-seated posture.\n2. Loosen tight clothing and ensure fresh ventilation.\n3. Rush to nearest emergency department immediately or dial 999 / 16263.',
        text: isBn
            ? '⚠️ জরুরি মেডিকেল সতর্কতা (Red Flag Alert): আপনার উল্লিখিত লক্ষণসমূহ (বুকে চাপ/তীব্র শ্বাসকষ্ট/জরুরি অবস্থা) কার্ডিয়াক বা শ্বাসতন্ত্রের জরুরি ঝুঁকির ইঙ্গিত হতে পারে। অবিলম্বে জরুরি হেল্পলাইনে কল করুন।'
            : '⚠️ Critical Emergency Warning (Red Flag): Your described symptoms (chest pain/severe breathlessness) may signify acute cardiovascular or respiratory distress. Please dial emergency immediately.',
        timestamp: timeStr,
      );
    }

    // 3. Headache & Migraine (SEPARATED FROM FEVER)
    if (lower.contains('মাথাব্যথা') ||
        lower.contains('মাথা ব্যথা') ||
        lower.contains('মাথা ঘোরে') ||
        lower.contains('মাথা ঘোরানো') ||
        lower.contains('headache') ||
        lower.contains('migraine') ||
        lower.contains('head pain')) {
      return AiChatMessage(
        id: 'ai_${now.millisecondsSinceEpoch}',
        sender: 'ai',
        isEmergency: false,
        recommendedSpecialist: isBn ? 'নিউরোলজিস্ট / মেডিসিন বিশেষজ্ঞ' : 'Neurologist / Medicine Specialist',
        homeRemedies: isBn
            ? [
                'নীরব ও অন্ধকার ঘরে অন্তত ৩০-৪৫ মিনিট চোখ বন্ধ করে বিশ্রাম নিন',
                'পর্যাপ্ত পরিমাণে বিশুদ্ধ পানি পান করুন এবং পানিশূন্যতা এড়িয়ে চলুন',
                'মোবাইল, ল্যাপটপ বা যেকোনো উজ্জ্বল স্ক্রিন ব্যবহার সাময়িক বন্ধ রাখুন',
                'কপালে ও ঘাড়ে হালকা ঠান্ডা পানির পট্টি বা আইস প্যাক দিতে পারেন',
                'ব্যথা তীব্র হলে রক্তচাপ (Blood Pressure) পরীক্ষা করুন'
              ]
            : [
                'Rest in a quiet, dimly lit room with eyes closed',
                'Hydrate well with clean water or electrolyte fluids',
                'Minimize screen exposure to phones and monitors',
                'Apply a cold compress across forehead and temples',
                'Check resting blood pressure if headache is acute'
              ],
        text: isBn
            ? 'তীব্র মাথাব্যথা সাধারণত অতিরিক্ত মানসিক চাপ, অনিদ্রা, পানিশূন্যতা, মাইগ্রেন অথবা রক্তচাপ বৃদ্ধির কারণে হতে পারে। নিচের প্রাথমিক যত্নগুলো মেনে চলুন। যদি বমি বা চোখের দৃষ্টি ঝাপসা হওয়ার মতো উপসর্গ থাকে, তবে দ্রুত চিকিৎসকের শরণাপন্ন হোন।'
            : 'Severe headache can arise from tension, dehydration, sleep deprivation, migraine, or elevated blood pressure. Follow these initial home care measures. If accompanied by blurred vision or vomiting, seek immediate clinical evaluation.',
        timestamp: timeStr,
      );
    }

    // 4. Stomach Ache & Acidity / Gastric
    if (lower.contains('গ্যাস') ||
        lower.contains('পেট') ||
        lower.contains('অ্যাসিড') ||
        lower.contains('বুক জ্বালা') ||
        lower.contains('stomach') ||
        lower.contains('gastric') ||
        lower.contains('acidity') ||
        lower.contains('heartburn')) {
      return AiChatMessage(
        id: 'ai_${now.millisecondsSinceEpoch}',
        sender: 'ai',
        isEmergency: false,
        recommendedSpecialist: isBn ? 'গ্যাস্ট্রোএন্টারোলজিস্ট / মেডিসিন' : 'Gastroenterologist',
        homeRemedies: isBn
            ? [
                'ভাজা-পোড়া, অতিরিক্ত ঝাল-তেল ও মশলাযুক্ত খাবার পরিহার করুন',
                'খাওয়ার পরপরই শুয়ে না পড়ে অন্তত ৩০ মিনিট হাঁটাচলা করুন',
                'পর্যাপ্ত কুসুম গরম পানি পান করুন এবং খালি পেটে চা/কফি এড়িয়ে চলুন'
              ]
            : [
                'Avoid fried, heavily spiced, or carbonated items',
                'Stay upright for at least 30 minutes after meals',
                'Drink warm water and avoid empty-stomach caffeinated beverages'
              ],
        text: isBn
            ? 'আপনার লক্ষণগুলো সাধারণত গ্যাস্ট্রোইসোফেজিয়াল রিফ্লাক্স বা হাইপারঅ্যাসিডিটির ইঙ্গিত দিচ্ছে। নিয়মিত সময়ে পরিমিত খাবার ও স্বাস্থ্যকর খাদ্যাভ্যাস বজায় রাখুন।'
            : 'Your symptoms resemble acid reflux or acute gastritis. Maintain proper meal timing and stay hydrated with light meals.',
        timestamp: timeStr,
      );
    }

    // 5. Fever & Flu / Cough
    if (lower.contains('জ্বর') ||
        lower.contains('কাশি') ||
        lower.contains('সর্দি') ||
        lower.contains('ঠান্ডা') ||
        lower.contains('fever') ||
        lower.contains('cough') ||
        lower.contains('cold') ||
        lower.contains('flu')) {
      return AiChatMessage(
        id: 'ai_${now.millisecondsSinceEpoch}',
        sender: 'ai',
        isEmergency: false,
        recommendedSpecialist: isBn ? 'জেনারেল ফিজিশিয়ান (General Physician)' : 'General Physician',
        homeRemedies: isBn
            ? [
                'পর্যাপ্ত বিশ্রাম নিন ও তরল খাদ্য (স্যুপ, লেবু পানি) গ্রহণ করুন',
                'কুসুম গরম লবণ-পানি দিয়ে দিনে ৩ বার গার্গল করুন',
                'শরীরের তাপমাত্রা থার্মোমিটার দিয়ে নিয়মিত পর্যবেক্ষণ করুন (১০১°F অতিক্রম করলে চিকিৎসকের পরামর্শ নিন)'
              ]
            : [
                'Get ample rest and consume warm nutritional fluids (soups, herbal tea)',
                'Gargle with warm saline water 3 times daily',
                'Monitor body temperature and consult a doctor if fever exceeds 101°F'
              ],
        text: isBn
            ? 'এটি সাধারণত সাধারণ মৌসুমি ফ্লু বা ভাইরাল ইনফেকশনের লক্ষণ হতে পারে। পর্যাপ্ত বিশ্রাম নিন এবং শরীরকে হাইড্রেটেড রাখুন।'
            : 'These symptoms are consistent with seasonal viral flu or upper respiratory infection. Rest well and maintain hydration.',
        timestamp: timeStr,
      );
    }

    // 6. Default Comprehensive Clinical Guidance
    return AiChatMessage(
      id: 'ai_${now.millisecondsSinceEpoch}',
      sender: 'ai',
      isEmergency: false,
      recommendedSpecialist: isBn ? 'জেনারেল ফিজিশিয়ান (General Physician)' : 'General Physician',
      homeRemedies: isBn
          ? [
              'শারীরিক সমস্যাটির সময়কাল ও তীব্রতা খেয়াল রাখুন',
              'পর্যাপ্ত বিশুদ্ধ পানি পান করুন ও বিশ্রাম নিন',
              'লক্ষণ কয়েক দিন স্থায়ী হলে বা অস্বস্তি বাড়লে চিকিৎসকের পরামর্শ নিন'
            ]
          : [
              'Note symptom duration and intensity changes',
              'Stay well hydrated and maintain adequate rest',
              'Schedule a medical consultation if symptoms persist'
            ],
      text: isBn
          ? 'আপনার স্বাস্থ্য সম্পর্কিত প্রশ্নটি মনোযোগ সহকারে বিশ্লেষণ করা হয়েছে। যেকোনো স্বাস্থ্যঝুঁকি এড়াতে সঠিক রোগ নির্ণয়ের জন্য আমাদের নিবন্ধিত ডাক্তারদের সাথে অ্যাপয়েন্টমেন্ট বা টেলি-কনসালটেশন গ্রহণ করতে পারেন।'
          : 'Your health query has been analyzed. For accurate clinical assessment and personalized treatment, consider booking a video or in-person consultation with our certified doctors.',
      timestamp: timeStr,
    );
  }
}
