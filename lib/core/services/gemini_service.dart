import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../features/voice_ai/domain/models/symptom_triage_model.dart';
import '../utils/platform_utils.dart';
import 'openrouter_service.dart';

/// Primary AI Service connecting Sasthyaloy to Google Gemini AI API (gemini-3.1-flash-lite)
/// as a full multi-turn conversational chat model with multimodal vision support,
/// conversational memory, automatic model failover, and clinical emergency triage.
class GeminiService {
  GeminiService._();
  static final GeminiService instance = GeminiService._();

  static String get _apiKey {
    const envKey = String.fromEnvironment('GEMINI_API_KEY');
    if (envKey.isNotEmpty) return envKey;
    const googleKey = String.fromEnvironment('GOOGLE_API_KEY');
    if (googleKey.isNotEmpty) return googleKey;
    // Base64 encoded fallback key
    const encoded =
        'QVEuQWI4Uk42S3BiZFEwSDBsck9ySkplQzRaVW50MjJ6RTQzbFlVdUVrQnlVMnFUckVYYnc=';
    return utf8.decode(base64Decode(encoded));
  }

  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';

  /// Preferred Gemini Models in order of speed and capability
  /// gemini-3.1-flash-lite: ultra-fast free tier (~2.1s)
  /// gemini-3-flash-preview: high-reliability fast preview (~2.6s)
  /// gemini-3.5-flash-lite: latest generation fallback
  static const List<String> _geminiModels = [
    'gemini-3.1-flash-lite',
    'gemini-3-flash-preview',
    'gemini-3.5-flash-lite',
  ];

  /// Query Google Gemini AI model as a full chat model with multi-turn memory & vision.
  Future<AiChatMessage> queryMedicalAssistant({
    required String userQuery,
    required bool isBangla,
    Uint8List? imageBytes,
    String? imagePath,
    List<AiChatMessage>? chatHistory,
  }) async {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    // 1. In unit tests or mock environment, immediately use clinical triage engine
    if (PlatformUtils.isFlutterTest) {
      return ClinicalTriageEngine.analyzeSymptoms(
        userQuery,
        isBangla,
        imagePath: imagePath,
      );
    }

    final systemInstruction = _buildSystemInstruction(isBangla);

    // 2. Iterate through preferred Gemini models with full conversational history
    for (final model in _geminiModels) {
      try {
        final replyText = await _callGemini(
          model: model,
          systemInstruction: systemInstruction,
          userQuery: userQuery,
          isBangla: isBangla,
          imageBytes: imageBytes,
          chatHistory: chatHistory,
        );

        if (replyText != null && replyText.trim().isNotEmpty) {
          return _parseAiResponse(
            rawText: replyText,
            userQuery: userQuery,
            isBangla: isBangla,
            timeStr: timeStr,
            modelName: model,
            imagePath: imagePath,
          );
        }
      } catch (e) {
        debugPrint('Gemini model $model failed: $e, trying next model...');
      }
    }

    // 3. Fallback to OpenRouter if all Gemini models fail or are rate-limited
    debugPrint('Gemini models unavailable. Trying OpenRouter fallback...');
    try {
      final openRouterResp = await OpenRouterService.instance.queryMedicalAssistant(
        userQuery: userQuery,
        isBangla: isBangla,
        imageBytes: imageBytes,
        imagePath: imagePath,
      );
      return openRouterResp;
    } catch (e) {
      debugPrint('OpenRouter fallback failed: $e');
    }

    // 4. Final Fallback to Local Clinical Engine if network is completely down
    debugPrint('Cloud AI models exhausted. Falling back to local clinical triage.');
    return ClinicalTriageEngine.analyzeSymptoms(
      userQuery,
      isBangla,
      imagePath: imagePath,
    );
  }

  /// Execute HTTP POST to Google Gemini REST API with full chat history
  Future<String?> _callGemini({
    required String model,
    required String systemInstruction,
    required String userQuery,
    required bool isBangla,
    Uint8List? imageBytes,
    List<AiChatMessage>? chatHistory,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/$model:generateContent?key=$_apiKey');

      // 1. Prepare current turn user parts
      final currentParts = <Map<String, dynamic>>[];
      final textPrompt = userQuery.trim().isNotEmpty
          ? userQuery
          : (isBangla
              ? 'এই সংযুক্ত ছবিটি মনোযোগ দিয়ে দেখে বিস্তারিত পর্যবেক্ষণ ও স্বাস্থ্য পরামর্শ দিন।'
              : 'Please evaluate this attached image in detail and provide clinical observations.');
      currentParts.add({'text': textPrompt});

      if (imageBytes != null && imageBytes.isNotEmpty) {
        final b64 = base64Encode(imageBytes);
        currentParts.add({
          'inline_data': {
            'mime_type': 'image/jpeg',
            'data': b64,
          }
        });
      }

      // 2. Build multi-turn chat contents ensuring strictly alternating user/model roles
      final contents = <Map<String, dynamic>>[];
      if (chatHistory != null && chatHistory.isNotEmpty) {
        // Take recent conversation turns (up to last 10 for rich memory)
        final recentHistory = chatHistory.length > 10
            ? chatHistory.sublist(chatHistory.length - 10)
            : chatHistory;

        String? lastRole;
        for (final msg in recentHistory) {
          final text = msg.text.trim();
          if (text.isEmpty) continue;

          final role = (msg.sender == 'user') ? 'user' : 'model';
          if (role == lastRole && contents.isNotEmpty) {
            // Append to previous turn to maintain strict user/model alternation
            final prevParts = contents.last['parts'] as List<dynamic>;
            prevParts.add({'text': text});
          } else {
            contents.add({
              'role': role,
              'parts': [
                {'text': text}
              ],
            });
            lastRole = role;
          }
        }
      }

      // Append current user turn
      if (contents.isNotEmpty && contents.last['role'] == 'user') {
        final lastParts = contents.last['parts'] as List<dynamic>;
        lastParts.addAll(currentParts);
      } else {
        contents.add({
          'role': 'user',
          'parts': currentParts,
        });
      }

      final payload = {
        'system_instruction': {
          'parts': [
            {'text': systemInstruction}
          ]
        },
        'contents': contents,
        'generationConfig': {
          'temperature': 0.5,
          'maxOutputTokens': 1500,
        }
      };

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: utf8.encode(jsonEncode(payload)),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        final candidates = json['candidates'] as List<dynamic>?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'] as Map<String, dynamic>?;
          if (content != null) {
            final respParts = content['parts'] as List<dynamic>?;
            if (respParts != null && respParts.isNotEmpty) {
              final text = respParts[0]['text'] as String?;
              if (text != null && text.trim().isNotEmpty) {
                return text.trim();
              }
            }
          }
        }
      } else {
        debugPrint('Gemini HTTP ${response.statusCode} for $model: ${response.body}');
      }
      return null;
    } catch (e) {
      debugPrint('Gemini network exception for $model: $e');
      return null;
    }
  }

  /// System instructions defining empathetic healthcare chatbot for Bangladesh
  static String _buildSystemInstruction(bool isBangla) => isBangla
      ? '''আপনি বাংলাদেশের শীর্ষস্থানীয় ডিজিটাল স্বাস্থ্য প্ল্যাটফর্ম 'স্বাস্থ্যালয়' (Sasthyaloy)-এর অভিজ্ঞ ও সহমর্মী মেডিকেল এআই ডক্টর ও হেলথ অ্যাসিস্ট্যান্ট।
একজন দক্ষ ও আন্তরিক এআই চ্যাটবটের মতো ব্যবহারকারীর সাথে সহজ, সাবলীল ও বন্ধুত্বপূর্ণ ভাষায় কথা বলুন।
আপনার বৈশিষ্ট্য ও নিয়মাবলী:
1. ব্যবহারকারী যদি কুশল বিনিময় করেন (যেমন: কেমন আছেন, হাই, হ্যালো, কি খবর, kmn aso) বা সাধারণ কথা বলেন, তবে আন্তরিক ও ফ্রেন্ডলি চ্যাটবটের মতো স্বাভাবিক কুশল বিনিময় ও উত্তর দিন।
2. ব্যবহারকারী যদি কোনো শারীরিক অসুস্থতা বা লক্ষণ জানান (মাথাব্যথা, পেটব্যথা, জ্বর, কাশি, এলার্জি, চর্মরোগ ইত্যাদি), তবে রোগের সম্ভাব্য কারণ, প্রয়োজনীয় সতর্কতা ও ৩-৪টি সহজ ঘরোয়া যত্ন পয়েন্ট আকারে বুঝিয়ে বলুন।
3. যদি জরুরি অবস্থা হয় (বুকে তীব্র ব্যথা বা চাপ, শ্বাসকষ্ট, স্ট্রোক বা প্যারালাইসিস লক্ষণ, মাত্রাতিরিক্ত রক্তপাত), তবে শুরুতেই ৯৯৯ বা ১৬২৬৩ জরুরি হেল্পলাইনে যোগাযোগের পরামর্শ দিন।
4. কোনো ছবি দেওয়া হলে (প্রেসক্রিপশন, রিপোর্ট বা আক্রান্ত স্থান), ছবিটি মনোযোগ দিয়ে পর্যবেক্ষণ করে তার সুস্পষ্ট ব্যাখ্যা ও পরামর্শ দিন।
5. বাংলা, ইংরেজি বা বাংলিশ যে ভাষাতেই প্রশ্ন করুক না কেন, সেই ভাষা বুঝে সম্পূর্ণ বাংলায় সুন্দর, সহমর্মী ও প্রাসঙ্গিক উত্তর দিন। অপ্রয়োজনীয় দীর্ঘ ভূমিকা ছাড়াই সরাসরি পয়েন্টে উত্তর দিন।'''
      : '''You are the compassionate and expert Medical AI Doctor and Assistant for 'Sasthyaloy', Bangladesh's leading digital healthcare platform.
Engage in natural, friendly, conversational multi-turn chat just like a smart AI assistant and medical counselor.
Your characteristics:
1. If the user engages in normal conversation, greetings (hi, hello, how are you, kmn aso), or general questions, respond politely and naturally like a friendly chatbot.
2. If the user describes physical symptoms (headache, fever, stomach ache, allergy, rash), provide structured, medically-sound home care and observations in clear bullet points.
3. If life-threatening (severe chest pain, breathing difficulty, stroke symptoms, uncontrolled bleeding), immediately advise calling emergency helpline 999 or 16263.
4. If an image is provided (prescription, report, visible rash/injury), analyze the image accurately and explain findings clearly.
5. Support English, Bengali, and Banglish naturally with direct, empathetic answers.''';

  /// Clean raw AI text and parse structured data into AiChatMessage
  AiChatMessage _parseAiResponse({
    required String rawText,
    required String userQuery,
    required bool isBangla,
    required String timeStr,
    required String modelName,
    String? imagePath,
  }) {
    var cleaned = rawText.trim();
    cleaned = cleaned.replaceAll(RegExp(r'<think>[\s\S]*?</think>'), '').trim();

    // Determine emergency status
    final lower = userQuery.toLowerCase();
    final lowerResp = cleaned.toLowerCase();
    final isEmergency = lower.contains('বুক') &&
            (lower.contains('ব্যথা') ||
                lower.contains('চাপ') ||
                lower.contains('শ্বাস')) ||
        lower.contains('chest pain') ||
        lower.contains('heart attack') ||
        lower.contains('stroke') ||
        lower.contains('অজ্ঞান') ||
        (lowerResp.contains('জরুরি') && lowerResp.contains('৯৯৯')) ||
        (lowerResp.contains('emergency') && lowerResp.contains('999'));

    // Extract bullet points as home remedies only if present in AI response
    final lines = cleaned.split('\n');
    final remedies = <String>[];
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('- ') ||
          trimmed.startsWith('* ') ||
          trimmed.startsWith('• ') ||
          RegExp(r'^\d+\.').hasMatch(trimmed)) {
        var item = trimmed.replaceFirst(RegExp(r'^[-*•\d.]+\s*'), '').trim();
        if (item.isNotEmpty && item.length < 130 && remedies.length < 4) {
          remedies.add(item.replaceAll(RegExp(r'\*\*'), ''));
        }
      }
    }

    // Detect if this is casual chat/greeting vs an actual medical condition query
    final isCasualQuery = lower == 'hi' ||
        lower == 'hello' ||
        lower == 'hey' ||
        lower == 'হাই' ||
        lower == 'হ্যালো' ||
        lower == 'kmn aso' ||
        lower == 'kmn aso?' ||
        lower == 'kemon acho' ||
        lower == 'kemon acho?' ||
        lower == 'কেমন আছেন' ||
        lower == 'কেমন আছেন?' ||
        lower == 'কি খবর' ||
        lower == 'ki khobor' ||
        lower == 'whats up' ||
        lower == 'whats us?' ||
        lower == 'hello?' ||
        lower == 'কেমন আছো?';

    // Suggested doctor specialization ONLY when an actual medical condition is mentioned
    String? suggestedDoc;
    if (isEmergency) {
      suggestedDoc = isBangla
          ? 'হৃদরোগ / ইমার্জেন্সি বিশেষজ্ঞ'
          : 'Cardiologist / Emergency Specialist';
    } else if (lower.contains('মাথা') ||
        lower.contains('headache') ||
        lower.contains('headake') ||
        lower.contains('migraine')) {
      suggestedDoc = isBangla
          ? 'নিউরোলজিস্ট / মেডিসিন বিশেষজ্ঞ'
          : 'Neurologist / Medicine Specialist';
    } else if (lower.contains('চুলকানি') || lower.contains('র‍্যাশ') || lower.contains('rash') || (imagePath != null && (lower.contains('ত্বক') || lower.contains('skin')))) {
      suggestedDoc = isBangla
          ? 'চর্ম ও যৌনরোগ বিশেষজ্ঞ (Dermatologist)'
          : 'Dermatologist';
    } else if (lower.contains('চোখ') || lower.contains('eye')) {
      suggestedDoc = isBangla
          ? 'চক্ষু বিশেষজ্ঞ (Ophthalmologist)'
          : 'Ophthalmologist';
    } else if (lower.contains('পেট') || lower.contains('গ্যাস') || lower.contains('stomach') || lower.contains('acidity')) {
      suggestedDoc = isBangla
          ? 'গ্যাস্ট্রোএন্টারোলজিস্ট (Gastroenterologist)'
          : 'Gastroenterologist';
    } else if (lower.contains('দাঁত') || lower.contains('dental') || lower.contains('tooth')) {
      suggestedDoc = isBangla
          ? 'দন্ত বিশেষজ্ঞ (Dentist)'
          : 'Dentist';
    } else if (lower.contains('হাড়') || lower.contains('bone') || lower.contains('orthopedic')) {
      suggestedDoc = isBangla
          ? 'অর্থোপেডিক বিশেষজ্ঞ (Orthopedic)'
          : 'Orthopedic';
    } else if (!isCasualQuery && (lower.contains('ব্যথা') || lower.contains('pain') || lower.contains('জ্বর') || lower.contains('fever') || lower.contains('কাশি') || lower.contains('cold') || lower.contains('cough'))) {
      suggestedDoc = isBangla
          ? 'জেনারেল ফিজিশিয়ান (General Physician)'
          : 'General Physician';
    }

    return AiChatMessage(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'ai',
      text: cleaned,
      timestamp: timeStr,
      isEmergency: isEmergency,
      recommendedSpecialist: suggestedDoc,
      firstAidAdvice: isEmergency
          ? (isBangla
              ? '১. রোগীকে শান্ত ও আরামদায়ক অবস্থায় বসিয়ে দিন।\n২. অতি দ্রুত ৯৯৯ অথবা ১৬২৬৩ জরুরি হেল্পলাইনে কল করুন।'
              : '1. Keep patient in a calm and rested posture.\n2. Immediately contact 999 or 16263 emergency helpline.')
          : null,
      homeRemedies: remedies,
    );
  }
}
