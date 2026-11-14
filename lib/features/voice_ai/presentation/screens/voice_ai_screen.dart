import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../doctors/presentation/screens/speciality_search_screen.dart';
import '../../domain/models/symptom_triage_model.dart';

class VoiceAiScreen extends StatefulWidget {
  const VoiceAiScreen({super.key});

  @override
  State<VoiceAiScreen> createState() => _VoiceAiScreenState();
}

class _VoiceAiScreenState extends State<VoiceAiScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _waveController;

  bool _isListening = false;
  bool _isPlayingAudio = false;
  String? _currentlySpeakingMsgId;

  final List<AiChatMessage> _messages = [
    const AiChatMessage(
      id: 'msg_welcome',
      sender: 'ai',
      text:
          'স্বাগতম! আমি আপনার স্বাস্থ্যালয় এআই হেলথ অ্যাসিস্ট্যান্ট। আপনার যেকোনো শারীরিক লক্ষণ বা সমস্যা সম্পর্কে কথা বলতে পারেন অথবা লিখে জানাতে পারেন।',
      timestamp: '08:00 AM',
      homeRemedies: [
        'বাংলা ও ইংরেজি উভয় ভাষায় নির্ভুলভাবে লক্ষণ যাচাই করতে সক্ষম',
        'জরুরি অবস্থায় তাৎক্ষণিক ৯৯৯ ও ১৬২৬৩ ডায়াল সহায়তা',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleUserQuery(String query) {
    if (query.trim().isEmpty) return;
    _textController.clear();
    final isBn = AppLocaleController.instance.isBangla;

    final userMsg = AiChatMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'user',
      text: query,
      timestamp: 'Just now',
    );

    setState(() {
      _messages.add(userMsg);
      _isListening = true;
    });
    _scrollToBottom();

    // Clinical Triage Engine Analysis
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final aiResponse = ClinicalTriageEngine.analyzeSymptoms(query, isBn);
      setState(() {
        _isListening = false;
        _messages.add(aiResponse);
        _currentlySpeakingMsgId = aiResponse.id;
        _isPlayingAudio = true;
      });
      _scrollToBottom();

      // Stop audio simulation after 4 seconds
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            _isPlayingAudio = false;
            _currentlySpeakingMsgId = null;
          });
        }
      });
    });
  }

  void _toggleMic() {
    if (_isListening) {
      setState(() => _isListening = false);
    } else {
      final isBn = AppLocaleController.instance.isBangla;
      // Simulate voice capture
      final simulatedPrompts = isBn
          ? [
              'আমার বুকে প্রচণ্ড চাপ ও শ্বাসকষ্ট হচ্ছে',
              'মাথাব্যথা ও হালকা জ্বর ২ দিন ধরে',
              'খাবারের পর পেটে গ্যাস ও বুক জ্বালাপোড়া করে',
            ]
          : [
              'I feel sudden chest tightness and shortness of breath',
              'I have mild fever and sore throat for 2 days',
              'Severe acidity and stomach burning after eating',
            ];
      final prompt = simulatedPrompts[DateTime.now().second % simulatedPrompts.length];
      _handleUserQuery(prompt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.brandCyan, AppColors.emeraldGreen],
                ),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBn ? 'স্বাস্থ্যালয় AI অ্যাসিস্ট্যান্ট' : 'Sasthyaloy AI Voice',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
                Text(
                  isBn ? 'ক্লিনিক্যাল সিম্পটম ট্রায়াজিং' : 'Clinical Symptom Triage',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: AppColors.primaryNavy),
            onPressed: () {
              setState(() {
                AppLocaleController.instance.toggleLanguage();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(
                  AiChatMessage(
                    id: 'msg_welcome',
                    sender: 'ai',
                    text: isBn
                        ? 'চ্যাট হিস্ট্রি রিসেট করা হয়েছে। আপনার বর্তমান লক্ষণ বা স্বাস্থ্য সমস্যা সম্পর্কে বলুন।'
                        : 'Conversation reset. Describe your symptoms or ask a medical query.',
                    timestamp: 'Just now',
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat Messages View
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                itemCount: _messages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildMessageItem(msg, isBn);
                },
              ),
            ),

            // Sound Wave Visualizer when Listening
            if (_isListening)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.85, end: 1.15).animate(
                        CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.brandCyan.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.graphic_eq_rounded, color: AppColors.brandCyan, size: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isBn ? 'আপনার ভয়েস বিশ্লেষণ করা হচ্ছে...' : 'Listening & analyzing clinical context...',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                    ),
                  ],
                ),
              ),

            // Suggestion Chips
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildPromptChip(isBn ? 'বুকে চাপ ও শ্বাসকষ্ট' : 'Chest pressure & breathless', isEmergency: true),
                    const SizedBox(width: 8),
                    _buildPromptChip(isBn ? 'হালকা জ্বর ও কাশি' : 'Mild fever & cough'),
                    const SizedBox(width: 8),
                    _buildPromptChip(isBn ? 'গ্যাস্ট্রিক ও বুক জ্বালাপোড়া' : 'Acidity & gastric burn'),
                    const SizedBox(width: 8),
                    _buildPromptChip(isBn ? 'ডায়াবেটিস নিয়ন্ত্রণ পরামর্শ' : 'Diabetes diet guidance'),
                  ],
                ),
              ),
            ),

            // Bottom Input Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  // Microphone Button
                  InkWell(
                    onTap: _toggleMic,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: _isListening ? AppColors.sosRed : AppColors.primaryNavy,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isListening ? AppColors.sosRed : AppColors.primaryNavy).withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Text Field
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: isBn ? 'লক্ষণ লিখুন বা মাইকে কথা বলুন...' : 'Type symptoms or tap mic...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onSubmitted: _handleUserQuery,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Send Button
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: AppColors.brandCyan),
                    onPressed: () => _handleUserQuery(_textController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(AiChatMessage msg, bool isBn) {
    final isUser = msg.sender == 'user';

    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryNavy,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Text(
            msg.text,
            style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.35),
          ),
        ),
      );
    }

    // AI Response Card
    final isSpeaking = _currentlySpeakingMsgId == msg.id && _isPlayingAudio;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.92),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: msg.isEmergency ? const Color(0xFFFEF2F2) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          border: Border.all(
            color: msg.isEmergency ? AppColors.sosRed.withOpacity(0.4) : AppColors.borderLight,
            width: msg.isEmergency ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Header with TTS Speaker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      msg.isEmergency ? Icons.warning_rounded : Icons.health_and_safety_rounded,
                      color: msg.isEmergency ? AppColors.sosRed : AppColors.brandCyan,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      msg.isEmergency
                          ? (isBn ? 'জরুরি ট্রায়াজ এলার্ট (Emergency)' : 'Critical Emergency Alert')
                          : (isBn ? 'স্বাস্থ্যালয় AI ট্রায়াজ' : 'Sasthyaloy AI Guidance'),
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: msg.isEmergency ? AppColors.sosRed : AppColors.primaryNavy,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (isSpeaking) {
                        _isPlayingAudio = false;
                        _currentlySpeakingMsgId = null;
                      } else {
                        _currentlySpeakingMsgId = msg.id;
                        _isPlayingAudio = true;
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSpeaking ? AppColors.brandCyan.withOpacity(0.15) : AppColors.chipBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSpeaking ? Icons.volume_up_rounded : Icons.volume_mute_rounded,
                          size: 16,
                          color: isSpeaking ? AppColors.brandCyan : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isSpeaking ? 'Playing' : 'Listen',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSpeaking ? AppColors.brandCyan : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Message Body Text
            Text(
              msg.text,
              style: TextStyle(
                fontSize: 13.5,
                color: msg.isEmergency ? const Color(0xFF991B1B) : AppColors.textPrimary,
                height: 1.4,
              ),
            ),

            // If Emergency: Display Immediate Actions
            if (msg.isEmergency) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.sosRed.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBn ? 'প্রাথমিক জরুরি পদক্ষেপ:' : 'Immediate First Aid:',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.sosRed),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      msg.firstAidAdvice ?? '',
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textPrimary, height: 1.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.sosRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _callEmergency('999', isBn),
                      icon: const Icon(Icons.call, size: 16),
                      label: const Text('৯৯৯ কল করুন', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _callEmergency('16263', isBn),
                      icon: const Icon(Icons.support_agent, size: 16),
                      label: const Text('১৬২৬৩ স্বাস্থ্য বাতায়ন', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5)),
                    ),
                  ),
                ],
              ),
            ],

            // If Routine: Home Remedies
            if (!msg.isEmergency && msg.homeRemedies.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBn ? 'পরামর্শ ও সতর্কতা:' : 'Guidance & Advice:',
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                    ),
                    const SizedBox(height: 4),
                    ...msg.homeRemedies.map((remedy) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.brandCyan)),
                            Expanded(child: Text(remedy, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],

            // Specialist Recommendation Action Button
            if (msg.recommendedSpecialist != null && !msg.isEmergency) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 38,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNavy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SpecialitySearchScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.calendar_today_rounded, size: 15),
                  label: Text(
                    isBn
                        ? '${msg.recommendedSpecialist} বুক করুন'
                        : 'Book ${msg.recommendedSpecialist}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPromptChip(String prompt, {bool isEmergency = false}) {
    return InkWell(
      onTap: () => _handleUserQuery(prompt),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isEmergency ? AppColors.sosRed.withOpacity(0.08) : AppColors.chipBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEmergency ? AppColors.sosRed.withOpacity(0.3) : AppColors.borderLight,
          ),
        ),
        child: Text(
          prompt,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: isEmergency ? AppColors.sosRed : AppColors.chipText,
          ),
        ),
      ),
    );
  }

  void _callEmergency(String number, bool isBn) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryNavy,
        behavior: SnackBarBehavior.floating,
        content: Text(
          isBn ? '$number নম্বরে সরাসরি জরুরি কল সংযোগ করা হচ্ছে...' : 'Initiating immediate emergency call to $number...',
        ),
      ),
    );
  }
}
