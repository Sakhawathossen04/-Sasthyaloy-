/// Service dedicated to cleaning, normalizing, and correcting user speech-to-text
/// input for medical queries before sending to the AI model.
class SymptomCorrectionService {
  SymptomCorrectionService._();
  static final SymptomCorrectionService instance = SymptomCorrectionService._();

  /// Dictionary of symptom keyword corrections & expansions
  static final Map<String, String> _bengaliCorrections = {
    'বুকে ব্যথা': 'আমার বুকে চাপ ও ব্যথা অনুভূত হচ্ছে',
    'বুকে বেথা': 'আমার বুকে চাপ ও তীব্র ব্যথা হচ্ছে',
    'বুকে চিনচিন': 'আমার বুকে চিনচিন ব্যথা ও অস্বস্তি লাগছে',
    'শ্বাসকষ্ট': 'আমার শ্বাস নিতে কষ্ট ও শ্বাসকষ্ট হচ্ছে',
    'শ্বাস নিতে কষ্ট': 'আমার শ্বাস নিতে প্রচণ্ড কষ্ট হচ্ছে',
    'মাথা ব্যথা': 'আমার তীব্র মাথাব্যথা ও অস্বস্তি হচ্ছে',
    'মাথা বেথা': 'আমার মাথা ব্যথা করছে ও ভারী লাগছে',
    'মাথা ঘোরা': 'আমার মাথা ঘুরছে এবং শরীর দুর্বল লাগছে',
    'পেটে ব্যথা': 'আমার পেটে প্রচণ্ড ব্যথা ও মোচড় দিচ্ছে',
    'পেটে বেথা': 'আমার পেটে ব্যথা ও অস্বস্তি হচ্ছে',
    'গ্যাস': 'আমার পেটে গ্যাস ও বুক জ্বালাপোড়া করছে',
    'বুক জ্বালা': 'আমার খাবার পর বুক ও গলা জ্বালাপোড়া করছে',
    'জ্বর': 'আমার শরীরে জ্বর ও শরীর ব্যথা করছে',
    'সর্দি কাশি': 'আমার সর্দি, কাশি ও গলা ব্যথা করছে',
    'কাশি': 'আমার শুকনো কাশি ও গলায় খুসখুস করছে',
    'বমি': 'আমার বমি বমি ভাব ও বমি হচ্ছে',
    'পাতলা পায়খানা': 'আমার ঘনঘন পাতলা পায়খানা ও পেটে সমস্যা হচ্ছে',
    'ডায়রিয়া': 'আমার ডায়রিয়া ও পাতলা পায়খানা হচ্ছে',
    'প্রেসার হাই': 'আমার উচ্চ রক্তচাপ ও অস্বস্তি অনুভূত হচ্ছে',
    'চোখে ঝাপসা': 'আমার চোখে ঝাপসা দেখা ও চোখ ব্যথার সমস্যা হচ্ছে',
    'চুলকানি': 'আমার শরীরে এলার্জি ও চুলকানি হচ্ছে',
    'ঘুম হয় না': 'আমার রাতে অনিদ্রা ও ঘুমে সমস্যা হচ্ছে',
  };

  static final Map<String, String> _phoneticBanglish = {
    'buke betha': 'আমার বুকে তীব্র ব্যথা ও চাপ লাগছে',
    'buke batha': 'আমার বুকে অস্বস্তি ও ব্যথা হচ্ছে',
    'buke chap': 'আমার বুকে প্রচণ্ড চাপ ও শ্বাসকষ্ট হচ্ছে',
    'matha betha': 'আমার তীব্র মাথাব্যথা করছে',
    'matha batha': 'আমার মাথা ব্যথা ও মাথা ঘোরা হচ্ছে',
    'matha ghura': 'আমার মাথা ঘুরছে ও শরীর দুর্বল লাগছে',
    'pet betha': 'আমার পেটে তীব্র ব্যথা ও গ্যাস হচ্ছে',
    'pet batha': 'আমার পেটে ব্যথা ও অস্বস্তি লাগছে',
    'gas problem': 'আমার পেটে গ্যাস ও বুক জ্বালাপোড়া করছে',
    'buk jala': 'আমার বুক ও পেট জ্বালাপোড়া করছে',
    'jor': 'আমার গায়ে জ্বর ও শীত করছে',
    'jwer': 'আমার শরীরে উচ্চ জ্বর রয়েছে',
    'kashi': 'আমার খুসখুসে কাশি ও সর্দি হচ্ছে',
    'kash': 'আমার শুকনো কাশি ও গলায় ব্যথা',
    'shash kosto': 'আমার শ্বাসকষ্ট ও বুক ভার লাগছে',
    'vomit': 'আমার বমি বমি ভাব ও দুর্বলতা লাগছে',
    'patla paikhana': 'আমার বারবার পাতলা পায়খানা ও ডায়রিয়ার মতো লক্ষণ হচ্ছে',
    'chulkani': 'আমার শরীরে চুলকানি ও লালচে দাগ দেখা দিচ্ছে',
    'bp high': 'আমার প্রেসার বেড়ে গেছে ও মাথা ভার লাগছে',
  };

  static final Map<String, String> _englishCorrections = {
    'chest pain': 'I am experiencing chest pain and pressure',
    'heart pain': 'I feel tightness and pain in my chest',
    'headache': 'I have a severe headache and dizziness',
    'stomach pain': 'I have acute stomach pain and burning sensation',
    'stomach ache': 'I am suffering from severe stomach ache and cramps',
    'acidity': 'I have acid reflux and heartburn after meals',
    'gas': 'I am having stomach gas and bloating',
    'fever': 'I have a high fever and body chills',
    'cold cough': 'I have a persistent cough and sore throat',
    'cough': 'I have dry cough and throat irritation',
    'shortness of breath': 'I am experiencing shortness of breath and difficulty breathing',
    'breathless': 'I feel breathless and tight in the chest',
    'vomiting': 'I am feeling nauseous and vomiting repeatedly',
    'loose motion': 'I have diarrhea and dehydration symptoms',
    'high pressure': 'My blood pressure feels elevated with dizziness',
    'skin rash': 'I have an allergic skin rash and itching',
  };

  /// Clean, correct, and format raw voice transcription text.
  /// Returns a refined, clinically clear query sentence.
  String correctSymptomText(String rawText, bool isBangla) {
    var text = rawText.trim();
    if (text.isEmpty) return text;

    // 1. Remove filler words
    final fillerWords = ['um', 'uh', 'hmm', 'মানে', 'ইয়ে', 'like', 'actually'];
    for (final filler in fillerWords) {
      text = text.replaceAll(RegExp('\\b$filler\\b', caseSensitive: false), ' ');
    }
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    final lower = text.toLowerCase();

    // 2. Check phonetic Banglish matches
    for (final entry in _phoneticBanglish.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }

    // 3. Check language-specific correction dictionaries
    if (isBangla) {
      for (final entry in _bengaliCorrections.entries) {
        if (text.contains(entry.key)) {
          // If query is short, expand into full clinical sentence
          if (text.length <= entry.key.length + 8) {
            return entry.value;
          }
        }
      }
    } else {
      for (final entry in _englishCorrections.entries) {
        if (lower.contains(entry.key)) {
          if (text.length <= entry.key.length + 10) {
            return entry.value;
          }
        }
      }
    }

    // 4. Fallback: Clean capitalization and punctuation
    if (text.isNotEmpty) {
      // Capitalize first letter if English
      if (!isBangla) {
        text = text[0].toUpperCase() + text.substring(1);
      }
      // Ensure it doesn't end with awkward comma or dash
      text = text.replaceAll(RegExp(r'[, -]+$'), '');
    }

    return text;
  }
}
