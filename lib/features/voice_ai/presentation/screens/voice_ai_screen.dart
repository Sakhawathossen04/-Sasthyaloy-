import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../../core/services/emergency_call_service.dart';
import '../../../../core/services/openrouter_service.dart';
import '../../../../core/services/speech_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/symptom_correction_service.dart';
import '../../../../core/services/tts_service.dart';
import '../../../doctors/presentation/screens/speciality_search_screen.dart';
import '../../domain/models/symptom_triage_model.dart';

class VoiceAiScreen extends StatefulWidget {
  const VoiceAiScreen({super.key});

  @override
  State<VoiceAiScreen> createState() => _VoiceAiScreenState();
}

class _VoiceAiScreenState extends State<VoiceAiScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();

  late AnimationController _waveController;

  bool _isListening = false;
  bool _isAnalyzing = false;

  // Attached Image state
  XFile? _attachedImageFile;
  Uint8List? _attachedImageBytes;

  // Active Chat Session state
  late String _currentSessionId;
  String _currentSessionTitle = '';

  final List<AiChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    SpeechService.instance.isListeningNotifier.addListener(_onSpeechListeningChanged);

    _initializeChatSession();
  }

  void _onSpeechListeningChanged() {
    if (mounted) {
      setState(() {
        _isListening = SpeechService.instance.isListening;
      });
    }
  }

  /// Load most recent session or create a new welcome session
  void _initializeChatSession() {
    final sessions = StorageService.getChatSessions();
    if (sessions.isNotEmpty) {
      final latest = sessions.first;
      _currentSessionId = latest.id;
      _currentSessionTitle = latest.title;
      _messages.addAll(latest.messages);
    } else {
      _startNewChat(preserveSessions: true);
    }
  }

  void _startNewChat({bool preserveSessions = false}) {
    TtsService.instance.stop();
    SpeechService.instance.stopListening();

    final isBn = AppLocaleController.instance.isBangla;
    final now = DateTime.now();

    setState(() {
      _currentSessionId = 'session_${now.millisecondsSinceEpoch}';
      _currentSessionTitle = isBn ? 'নতুন স্বাস্থ্য পরামর্শ' : 'New Health Triage';
      _messages.clear();
      _attachedImageFile = null;
      _attachedImageBytes = null;
      _textController.clear();

      _messages.add(
        AiChatMessage(
          id: 'msg_welcome_${now.millisecondsSinceEpoch}',
          sender: 'ai',
          text: isBn
              ? 'স্বাগতম! আমি আপনার স্বাস্থ্যালয় এআই হেলথ অ্যাসিস্ট্যান্ট। আপনার যেকোনো শারীরিক লক্ষণ বা সমস্যা সম্পর্কে কথা বলতে পারেন, লিখে জানাতে পারেন অথবা আক্রান্ত স্থানের ছবি সংযুক্ত করে পাঠাতে পারেন।'
              : 'Welcome! I am your Sasthyaloy AI Medical Assistant. Feel free to describe symptoms via voice, text, or by attaching a photo of affected areas.',
          timestamp: '08:00 AM',
          homeRemedies: [
            isBn ? 'বাংলা, ইংরেজি ও বাংলিশ যেকোনো ভাষায় কথা বলুন' : 'Speak or type in Bengali, English, or Banglish',
            isBn ? 'গ্যালারি বা ক্যামেরা থেকে ছবি সংযুক্ত করার সুবিধা' : 'Attach clinical photos or prescriptions from gallery/camera',
            isBn ? 'জরুরি অবস্থায় তাৎক্ষণিক ৯৯৯ ও ১৬২৬৩ ডায়াল সহায়তা' : 'Direct 999 & 16263 emergency dial assistance',
          ],
        ),
      );
    });

    _persistCurrentSession();
  }

  void _persistCurrentSession() {
    final nowStr = DateTime.now().toIso8601String();
    final session = ChatSessionModel(
      id: _currentSessionId,
      title: _currentSessionTitle.isNotEmpty
          ? _currentSessionTitle
          : (AppLocaleController.instance.isBangla ? 'স্বাস্থ্য পরামর্শ' : 'Health Triage'),
      createdAt: nowStr,
      updatedAt: nowStr,
      messages: List.from(_messages),
    );
    StorageService.saveChatSession(session);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Stop voice playback when app is paused, minimized or backgrounded
    if (state != AppLifecycleState.resumed) {
      TtsService.instance.stop();
    }
  }

  @override
  void deactivate() {
    TtsService.instance.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SpeechService.instance.isListeningNotifier.removeListener(_onSpeechListeningChanged);
    TtsService.instance.stop();
    SpeechService.instance.stopListening();
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

  /// Handles incoming user query (either typed or spoken, with optional attached image)
  Future<void> _handleUserQuery([String? manualQuery]) async {
    final queryText = (manualQuery ?? _textController.text).trim();
    final hasImage = _attachedImageBytes != null || _attachedImageFile != null;

    if (queryText.isEmpty && !hasImage) return;

    final isBn = AppLocaleController.instance.isBangla;

    // Apply symptom auto-correction & clinical expansion
    final correctedQuery = queryText.isNotEmpty
        ? SymptomCorrectionService.instance.correctSymptomText(queryText, isBn)
        : '';

    // Snapshot image to send
    final sendingImageBytes = _attachedImageBytes;
    final sendingImagePath = _attachedImageFile?.path;

    // Clear input bar state
    _textController.clear();
    setState(() {
      _attachedImageBytes = null;
      _attachedImageFile = null;
    });

    await SpeechService.instance.stopListening();

    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final userMsg = AiChatMessage(
      id: 'user_${now.millisecondsSinceEpoch}',
      sender: 'user',
      text: correctedQuery.isNotEmpty
          ? correctedQuery
          : (isBn ? '[সংযুক্ত ছবির বিশ্লেষণ]' : '[Image Analysis Request]'),
      timestamp: timeStr,
      imagePath: sendingImagePath,
    );

    // Update conversation title based on first query
    if (_currentSessionTitle.isEmpty ||
        _currentSessionTitle == 'নতুন স্বাস্থ্য পরামর্শ' ||
        _currentSessionTitle == 'New Health Triage') {
      _currentSessionTitle = correctedQuery.isNotEmpty
          ? (correctedQuery.length > 32
              ? '${correctedQuery.substring(0, 32)}...'
              : correctedQuery)
          : (isBn ? 'ছবিসহ স্বাস্থ্য পরামর্শ' : 'Visual Symptom Query');
    }

    setState(() {
      _messages.add(userMsg);
      _isAnalyzing = true;
    });
    _scrollToBottom();
    _persistCurrentSession();

    try {
      // Query OpenRouter AI (with multimodal vision & local triage fallback)
      final aiResponse = await OpenRouterService.instance.queryMedicalAssistant(
        userQuery: correctedQuery,
        isBangla: isBn,
        imageBytes: sendingImageBytes,
        imagePath: sendingImagePath,
      );

      if (!mounted) return;

      setState(() {
        _isAnalyzing = false;
        _messages.add(aiResponse);
      });
      _scrollToBottom();
      _persistCurrentSession();

      // Note: Voice over is NOT played automatically.
      // User can click "কথা শুনুন" (Listen) whenever they want!
    } catch (e) {
      if (!mounted) return;
      final fallbackResponse = ClinicalTriageEngine.analyzeSymptoms(
        correctedQuery,
        isBn,
        imagePath: sendingImagePath,
      );
      setState(() {
        _isAnalyzing = false;
        _messages.add(fallbackResponse);
      });
      _scrollToBottom();
      _persistCurrentSession();
    }
  }

  /// Toggle Speech-to-Text Microphone
  Future<void> _toggleMic() async {
    final isBn = AppLocaleController.instance.isBangla;

    // Stop TTS if currently speaking
    await TtsService.instance.stop();

    if (_isListening) {
      // User tapped mic to stop speaking
      await SpeechService.instance.stopListening();
      final capturedText = _textController.text.trim();
      if (capturedText.isNotEmpty) {
        final corrected = SymptomCorrectionService.instance.correctSymptomText(capturedText, isBn);
        setState(() {
          _textController.text = corrected;
        });
      }
      return;
    }

    // Start listening
    final started = await SpeechService.instance.startListening(
      isBangla: isBn,
      onResult: (recognizedWords, isFinal) {
        if (!mounted) return;
        setState(() {
          _textController.text = recognizedWords;
        });

        // When speech recognition finishes, auto-correct and paste into text box for user confirmation
        if (isFinal && recognizedWords.trim().isNotEmpty) {
          final corrected = SymptomCorrectionService.instance.correctSymptomText(recognizedWords, isBn);
          setState(() {
            _textController.text = corrected;
          });
        }
      },
    );

    if (!started && mounted) {
      _showMicPermissionDialog(isBn);
    }
  }

  void _showMicPermissionDialog(bool isBn) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.mic_off_rounded, color: AppColors.sosRed),
            const SizedBox(width: 8),
            Text(
              isBn ? 'মাইক্রোফোন অনুমতি' : 'Microphone Permission',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          isBn
              ? 'ভয়েস ইনপুটের জন্য আপনার ডিভাইসে মাইক্রোফোন ব্যবহারের অনুমতি প্রয়োজন। অনুগ্রহ করে অ্যাপ সেটিংসে গিয়ে মাইক্রোফোন অনুমতি চালু করুন অথবা টেক্সট বক্সে লিখে জানান।'
              : 'Microphone permission is required for voice recognition. Please enable microphone access in device settings or type in the text box.',
          style: const TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isBn ? 'ঠিক আছে' : 'OK', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  /// Image Attachment Picker Modal
  void _showImagePickerSheet(bool isBn) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isBn ? 'ছবি সংযুক্ত করুন' : 'Attach Image',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
              ),
              const SizedBox(height: 6),
              Text(
                isBn
                    ? 'শারীরিক লক্ষণ (যেমন: ফুসকুড়ি, এলার্জি, চোখের সমস্যা) বা প্রেসক্রিপশনের ছবি দিতে পারেন'
                    : 'Attach photos of symptoms (rash, eye irritation) or medical reports',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.brandCyan.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library_rounded, color: AppColors.brandCyan),
                ),
                title: Text(isBn ? 'গ্যালারি থেকে নির্বাচন' : 'Choose from Gallery', style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldGreen.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt_rounded, color: AppColors.emeraldGreen),
                ),
                title: Text(isBn ? 'ক্যামেরা দিয়ে ছবি তুলুন' : 'Take a Photo', style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warningOrange.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.science_rounded, color: AppColors.warningOrange),
                ),
                title: Text(isBn ? 'ক্লিনিক্যাল টেস্ট স্যাম্পল (ত্বকের র‍্যাশ / রিপোর্ট)' : 'Test Clinical Sample (Skin Rash / Report)', style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  _attachSampleClinicalImage(isBn);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) {
      _attachSampleClinicalImage(AppLocaleController.instance.isBangla);
      return;
    }

    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 75,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _attachedImageFile = picked;
          _attachedImageBytes = bytes;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _attachSampleClinicalImage(bool isBn) {
    // 1x1 base64 transparent PNG for instant sample attachment
    const sampleB64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==';
    final bytes = base64Decode(sampleB64);
    setState(() {
      _attachedImageBytes = bytes;
      _attachedImageFile = XFile('sample_clinical_rash.png');
      if (_textController.text.trim().isEmpty) {
        _textController.text = isBn
            ? 'আমার ত্বকে এই লালচে র‍্যাশ ও চুলকানি দেখা যাচ্ছে'
            : 'I have this skin rash and itching for 2 days';
      }
    });
  }

  /// Previous Chat History Dashboard Modal (OpenAI / Gemini style)
  void _showChatHistoryDashboard(bool isBn) {
    final sessions = StorageService.getChatSessions();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with New Chat Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.history_rounded, color: AppColors.primaryNavy),
                            const SizedBox(width: 8),
                            Text(
                              isBn ? 'পূর্ববর্তী চ্যাট হিস্ট্রি' : 'Chat History',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryNavy,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandCyan,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            _startNewChat();
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: Text(
                            isBn ? 'নতুন চ্যাট' : 'New Chat',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Sessions List
                    if (sessions.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat_bubble_outline_rounded, size: 48, color: Colors.grey.shade300),
                              const SizedBox(height: 8),
                              Text(
                                isBn ? 'কোনো পূর্ববর্তী কথোপকথন নেই' : 'No previous conversations found',
                                style: const TextStyle(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.separated(
                          itemCount: sessions.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final session = sessions[index];
                            final isCurrent = session.id == _currentSessionId;

                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isCurrent
                                      ? AppColors.brandCyan.withOpacity(0.15)
                                      : AppColors.backgroundLight,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.chat_outlined,
                                  color: isCurrent ? AppColors.brandCyan : AppColors.textSecondary,
                                  size: 18,
                                ),
                              ),
                              title: Text(
                                session.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                                  color: isCurrent ? AppColors.primaryNavy : AppColors.textPrimary,
                                ),
                              ),
                              subtitle: Text(
                                '${session.messages.length} ${isBn ? "টি বার্তা" : "messages"} • ${session.createdAt.split("T").first}',
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.grey),
                                onPressed: () async {
                                  await StorageService.deleteChatSession(session.id);
                                  setSheetState(() {
                                    sessions.removeAt(index);
                                  });
                                  if (session.id == _currentSessionId) {
                                    _startNewChat(preserveSessions: true);
                                  }
                                },
                              ),
                              onTap: () {
                                Navigator.pop(ctx);
                                TtsService.instance.stop();
                                setState(() {
                                  _currentSessionId = session.id;
                                  _currentSessionTitle = session.title;
                                  _messages.clear();
                                  _messages.addAll(session.messages);
                                });
                                _scrollToBottom();
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        TtsService.instance.stop();
        SpeechService.instance.stopListening();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  Text(
                    isBn ? 'ওপেনরাউটার ক্লিনিক্যাল এআই' : 'OpenRouter Clinical AI',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            // Dashboard / History Button (OpenAI / Gemini style)
            IconButton(
              tooltip: isBn ? 'চ্যাট হিস্ট্রি ড্যাশবোর্ড' : 'Chat History',
              icon: const Icon(Icons.history_rounded, color: AppColors.primaryNavy),
              onPressed: () => _showChatHistoryDashboard(isBn),
            ),
            // Language Switch
            IconButton(
              tooltip: isBn ? 'ভাষা পরিবর্তন' : 'Switch Language',
              icon: const Icon(Icons.language, color: AppColors.primaryNavy),
              onPressed: () {
                setState(() {
                  AppLocaleController.instance.toggleLanguage();
                });
                TtsService.instance.stop();
              },
            ),
            // New Chat / Reset
            IconButton(
              tooltip: isBn ? 'নতুন চ্যাট শুরু করুন' : 'Start New Chat',
              icon: const Icon(Icons.add_comment_outlined, color: AppColors.textSecondary),
              onPressed: () => _startNewChat(),
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
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                            color: AppColors.sosRed.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.mic, color: AppColors.sosRed, size: 22),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isBn
                              ? 'আপনার কথা শুনছি... কথা শেষ হলে মাইক বোতাম চাপুন'
                              : 'Listening... Tap mic when done speaking',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

              // Analyzing Indicator
              if (_isAnalyzing)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandCyan),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isBn
                            ? 'ওপেনরাউটার এআই লক্ষণ বিশ্লেষণ করছে...'
                            : 'OpenRouter AI analyzing clinical symptoms...',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brandCyan,
                        ),
                      ),
                    ],
                  ),
                ),

              // Attached Image Preview Banner
              if (_attachedImageBytes != null || _attachedImageFile != null)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.brandCyan, width: 1.5),
                          color: AppColors.backgroundLight,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _attachedImageBytes != null
                            ? Image.memory(_attachedImageBytes!, fit: BoxFit.cover)
                            : const Icon(Icons.image_rounded, color: AppColors.brandCyan),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isBn ? 'ছবি সংযুক্ত করা হয়েছে' : 'Image Attached',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                            ),
                            Text(
                              isBn ? 'লক্ষণ লিখে পাঠান বোতামে চাপুন' : 'Add text if needed, then tap Send',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel_rounded, color: Colors.grey, size: 20),
                        onPressed: () {
                          setState(() {
                            _attachedImageBytes = null;
                            _attachedImageFile = null;
                          });
                        },
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
                      _buildPromptChip(
                        isBn ? 'বুকে চাপ ও তীব্র ব্যথা' : 'Chest pressure & severe pain',
                        isEmergency: true,
                      ),
                      const SizedBox(width: 8),
                      _buildPromptChip(
                        isBn ? 'তীব্র মাথাব্যথা ও মাথা ঘোরা' : 'Severe headache & dizziness',
                      ),
                      const SizedBox(width: 8),
                      _buildPromptChip(
                        isBn ? 'খাবারের পর পেটে গ্যাস ও বুক জ্বালা' : 'Acidity & heartburn',
                      ),
                      const SizedBox(width: 8),
                      _buildPromptChip(
                        isBn ? 'হালকা জ্বর ও খুসখুসে কাশি' : 'Mild fever & dry cough',
                      ),
                      const SizedBox(width: 8),
                      _buildPromptChip(
                        isBn ? 'ত্বকে র‍্যাশ ও চুলকানি' : 'Skin rash & itching',
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Input Bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Row(
                  children: [
                    // Microphone Button
                    InkWell(
                      onTap: _toggleMic,
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _isListening ? AppColors.sosRed : AppColors.primaryNavy,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (_isListening ? AppColors.sosRed : AppColors.primaryNavy)
                                  .withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Image Attachment Button
                    InkWell(
                      onTap: () => _showImagePickerSheet(isBn),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: AppColors.primaryNavy,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

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
                            hintText: isBn
                                ? 'লক্ষণ লিখুন বা মাইকে বলুন...'
                                : 'Type symptoms or tap mic...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onSubmitted: (val) => _handleUserQuery(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Send Button
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: AppColors.brandCyan),
                      onPressed: () => _handleUserQuery(),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: const BoxDecoration(
            color: AppColors.primaryNavy,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Display Attached Image in User Message if present
              if (msg.imagePath != null && msg.imagePath!.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.black12,
                    child: (File(msg.imagePath!).existsSync())
                        ? Image.file(File(msg.imagePath!), fit: BoxFit.cover)
                        : Container(
                            color: Colors.white10,
                            child: const Center(
                              child: Icon(Icons.image, color: Colors.white70, size: 36),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 6),
              ],
              Text(
                msg.text,
                style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.35),
              ),
            ],
          ),
        ),
      );
    }

    // AI Response Card with Manual Voice Playback ("কথা শুনুন" Button)
    return ValueListenableBuilder<bool>(
      valueListenable: TtsService.instance.isPlayingNotifier,
      builder: (context, isPlaying, _) {
        return ValueListenableBuilder<String?>(
          valueListenable: TtsService.instance.currentMessageIdNotifier,
          builder: (context, speakingId, _) {
            final isSpeaking = isPlaying && speakingId == msg.id;

            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.92),
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
                    color: msg.isEmergency
                        ? AppColors.sosRed.withOpacity(0.4)
                        : AppColors.borderLight,
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
                    // AI Header with Manual "কথা শুনুন" / "Listen" Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              msg.isEmergency
                                  ? Icons.warning_rounded
                                  : Icons.health_and_safety_rounded,
                              color: msg.isEmergency
                                  ? AppColors.sosRed
                                  : AppColors.brandCyan,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              msg.isEmergency
                                  ? (isBn
                                      ? 'জরুরি ট্রায়াজ এলার্ট (Emergency)'
                                      : 'Critical Emergency Alert')
                                  : (isBn
                                      ? 'স্বাস্থ্যালয় AI ট্রায়াজ'
                                      : 'Sasthyaloy AI Guidance'),
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: msg.isEmergency
                                    ? AppColors.sosRed
                                    : AppColors.primaryNavy,
                              ),
                            ),
                          ],
                        ),
                        // Listen / Speaking Toggle Button
                        InkWell(
                          onTap: () {
                            TtsService.instance.toggleSpeak(
                              messageId: msg.id,
                              text: msg.text,
                              isBangla: isBn,
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: isSpeaking
                                  ? AppColors.brandCyan.withOpacity(0.2)
                                  : AppColors.chipBackground,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSpeaking
                                    ? AppColors.brandCyan
                                    : AppColors.borderLight,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSpeaking
                                      ? Icons.volume_up_rounded
                                      : Icons.volume_down_rounded,
                                  size: 16,
                                  color: isSpeaking
                                      ? AppColors.brandCyan
                                      : AppColors.primaryNavy,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isSpeaking
                                      ? (isBn ? 'শুনছেন...' : 'Playing...')
                                      : (isBn ? 'কথা শুনুন' : 'Listen'),
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: isSpeaking
                                        ? AppColors.brandCyan
                                        : AppColors.primaryNavy,
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
                        color: msg.isEmergency
                            ? const Color(0xFF991B1B)
                            : AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),

                    // If Emergency: Display Immediate Actions
                    if (msg.isEmergency) ...[
                      const SizedBox(height: 12),
                      if (msg.firstAidAdvice != null &&
                          msg.firstAidAdvice!.isNotEmpty) ...[
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
                                isBn
                                    ? 'প্রাথমিক জরুরি পদক্ষেপ:'
                                    : 'Immediate First Aid:',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.sosRed,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                msg.firstAidAdvice!,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.textPrimary,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.sosRed,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => _callEmergency('999', isBn),
                              icon: const Icon(Icons.call, size: 16),
                              label: const Text(
                                '৯৯৯ কল করুন',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryNavy,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => _callEmergency('16263', isBn),
                              icon: const Icon(Icons.support_agent, size: 16),
                              label: const Text(
                                '১৬২৬৩ স্বাস্থ্য বাতায়ন',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.5,
                                ),
                              ),
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
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryNavy,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ...msg.homeRemedies.map((remedy) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 3.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '• ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.brandCyan,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        remedy,
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPromptChip(String prompt, {bool isEmergency = false}) {
    return InkWell(
      onTap: () => _handleUserQuery(prompt),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isEmergency
              ? AppColors.sosRed.withOpacity(0.08)
              : AppColors.chipBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEmergency
                ? AppColors.sosRed.withOpacity(0.3)
                : AppColors.borderLight,
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
    EmergencyCallService.instance.makeEmergencyCall(
      context: context,
      phoneNumber: number,
      isBangla: isBn,
    );
  }
}
