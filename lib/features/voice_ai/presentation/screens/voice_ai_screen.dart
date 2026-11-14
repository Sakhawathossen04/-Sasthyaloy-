import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/localization/app_locale_controller.dart';

class VoiceAiScreen extends StatefulWidget {
  const VoiceAiScreen({super.key});

  @override
  State<VoiceAiScreen> createState() => _VoiceAiScreenState();
}

class _VoiceAiScreenState extends State<VoiceAiScreen> with SingleTickerProviderStateMixin {
  bool _isListening = false;
  String _userSpeech = '';
  String _aiResponse = '';
  bool _isEmergencyDetected = false;

  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _simulateVoiceInput(String text) {
    setState(() {
      _isListening = true;
      _userSpeech = text;
      _aiResponse = '';
      _isEmergencyDetected = false;
    });

    // Check emergency triggers
    final isCritical = text.contains('বুকে') || text.contains('ব্যথা') || text.contains('chest') || text.contains('pain');

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        _isListening = false;
        if (isCritical) {
          _isEmergencyDetected = true;
          _aiResponse = AppLocaleController.instance.isBangla
              ? '⚠️ জরুরি সতর্কতা: বুকে ব্যথা বা অস্বস্তি একটি গুরুতর লক্ষণ হতে পারে। অনুগ্রহ করে তাৎক্ষণিকভাবে জরুরি হেল্পলাইনে কল করুন অথবা নিকটস্থ হাসপাতালের জরুরি বিভাগে যোগাযোগ করুন।'
              : '⚠️ EMERGENCY ALERT: Chest discomfort or pain can be critical. Please call emergency services immediately or visit the nearest emergency room.';
        } else {
          _aiResponse = AppLocaleController.instance.isBangla
              ? 'আপনার লক্ষণগুলো সাধারণ পানিশূন্যতা বা ভাইরাল ফ্লু হতে পারে। প্রচুর পানি ও বিশ্রাম গ্রহণ করুন। লক্ষণ অব্যাহত থাকলে একজন জেনারেল ফিজিশিয়ানের পরামর্শ নিন।'
              : 'Your symptoms may indicate dehydration or seasonal viral fatigue. Rest well and hydrate. If fever persists for >48h, consult a General Practitioner.';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.brandCyan, AppColors.emeraldGreen],
                ),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Text(
              isBn ? 'স্বাস্থ্যালয় AI অ্যাসিস্ট্যান্ট' : 'Sasthyaloy AI Voice',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: AppColors.primaryNavy),
            onPressed: () => AppLocaleController.instance.toggleLanguage(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Subtitle
              Text(
                isBn
                    ? 'বাংলা বা ইংরেজিতে কথা বলুন—আপনার লক্ষণ বিশ্লেষণ করে সঠিক পরামর্শ দেবে আমাদের এআই।'
                    : 'Speak in Bengali or English—our AI analyzes symptoms and guides your care.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
              ),

              const SizedBox(height: 24),

              // Conversation Area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_userSpeech.isNotEmpty) ...[
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.chipBackground,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.mic, size: 16, color: AppColors.primaryNavy),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    _userSpeech,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryNavy,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      if (_isListening) ...[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Column(
                              children: [
                                const CircularProgressIndicator(color: AppColors.brandCyan),
                                const SizedBox(height: 12),
                                Text(
                                  isBn ? 'আপনার কথা শুনছি ও বিশ্লেষণ করছি...' : 'Listening & analyzing clinical context...',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      if (_aiResponse.isNotEmpty) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _isEmergencyDetected ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
                              border: Border.all(
                                color: _isEmergencyDetected ? AppColors.sosRed.withOpacity(0.5) : AppColors.emeraldGreen.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _isEmergencyDetected ? Icons.emergency : Icons.check_circle_outline,
                                      color: _isEmergencyDetected ? AppColors.sosRed : AppColors.emeraldGreen,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isBn ? 'স্বাস্থ্যালয় এআই মূল্যায়ন' : 'AI Clinical Assessment',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: _isEmergencyDetected ? AppColors.sosRed : AppColors.emeraldGreen,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _aiResponse,
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.4,
                                    color: _isEmergencyDetected ? const Color(0xFF991B1B) : AppColors.textPrimary,
                                  ),
                                ),
                                if (_isEmergencyDetected) ...[
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.sosRed),
                                      icon: const Icon(Icons.phone_in_talk, color: Colors.white),
                                      label: Text(isBn ? 'জরুরি হেল্পলাইনে কল করুন (16263)' : 'Call Emergency (16263)'),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Suggestion Pills
              Text(
                isBn ? 'উদাহরণ লক্ষণসমূহ (ট্যাপ করে টেস্ট করুন):' : 'Suggested questions (tap to test):',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: [
                  _buildPromptChip(isBn ? 'আমার হালকা জ্বর ও কাশি' : 'I have mild fever and cough'),
                  _buildPromptChip(isBn ? 'বুকে চাপ ও শ্বাসকষ্ট হচ্ছে' : 'Chest pressure & breathlessness'),
                  _buildPromptChip(isBn ? 'গ্যাস্ট্রিকের ঘরোয়া সমাধান কী?' : 'Remedies for acidity'),
                ],
              ),

              const SizedBox(height: 24),

              // Pulsating Glowing Mic Button
              Center(
                child: InkWell(
                  onTap: () {
                    _simulateVoiceInput(isBn ? 'আমার হালকা জ্বর ও ক্লান্তি লাগছে' : 'I feel mild fever and fatigue');
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.brandCyan, AppColors.primaryNavy],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.brandCyan.withOpacity(0.3 * _waveController.value),
                              blurRadius: 20 * _waveController.value + 5,
                              spreadRadius: 8 * _waveController.value,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.mic,
                            size: 38,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isBn ? 'কথা বলতে ট্যাপ করুন' : 'Tap to speak',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromptChip(String text) {
    return ActionChip(
      backgroundColor: AppColors.backgroundLight,
      side: const BorderSide(color: AppColors.borderLight),
      label: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.primaryNavy)),
      onPressed: () => _simulateVoiceInput(text),
    );
  }
}
