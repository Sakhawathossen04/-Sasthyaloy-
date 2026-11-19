import 'package:flutter_test/flutter_test.dart';
import 'package:sasthyaloy/core/constants/app_strings.dart';
import 'package:sasthyaloy/core/services/storage_service.dart';
import 'package:sasthyaloy/features/doctors/domain/models/doctor_model.dart';
import 'package:sasthyaloy/features/appointments/domain/models/appointment_model.dart';
import 'package:sasthyaloy/features/auth/domain/controllers/auth_controller.dart';
import 'package:sasthyaloy/features/auth/domain/models/user_profile_model.dart';
import 'package:sasthyaloy/features/my_health/domain/controllers/health_record_controller.dart';
import 'package:sasthyaloy/features/voice_ai/domain/models/symptom_triage_model.dart';
import 'package:sasthyaloy/features/teleconsultation/domain/models/payment_model.dart';
import 'package:sasthyaloy/features/teleconsultation/presentation/screens/payment_checkout_screen.dart';
import 'package:sasthyaloy/features/teleconsultation/presentation/screens/video_consultation_room_screen.dart';
import 'package:sasthyaloy/features/teleconsultation/presentation/screens/post_consultation_summary_screen.dart';
import 'package:sasthyaloy/features/navigation/presentation/screens/main_shell_screen.dart';
import 'package:sasthyaloy/features/onboarding/presentation/screens/language_selection_screen.dart';
import 'package:sasthyaloy/features/menu/presentation/screens/menu_screen.dart';
import 'package:sasthyaloy/features/auth/presentation/screens/edit_profile_screen.dart';
import 'package:sasthyaloy/features/auth/presentation/widgets/profile_avatar_widget.dart';
import 'package:sasthyaloy/core/services/emergency_call_service.dart';
import 'package:sasthyaloy/core/services/symptom_correction_service.dart';
import 'package:sasthyaloy/core/services/gemini_service.dart';
import 'package:sasthyaloy/core/services/openrouter_service.dart';
import 'package:sasthyaloy/core/services/tts_service.dart';
import 'package:sasthyaloy/core/services/speech_service.dart';
import 'package:sasthyaloy/features/voice_ai/presentation/screens/voice_ai_screen.dart';

void main() {
  test('Sasthyaloy brand identity test', () {
    expect(AppStrings.appNameBn, 'স্বাস্থ্যালয়');
    expect(AppStrings.appNameEn, 'Sasthyaloy');
  });

  test('Sasthyaloy doctor directory test', () {
    final doctors = DoctorModel.sampleDoctors;
    expect(doctors.isNotEmpty, true);
    expect(doctors.any((d) => d.id == 'doc_1'), true);
  });

  test('Sasthyaloy appointment store test', () {
    final initialCount = AppointmentStore.instance.appointments.value.length;
    const testApt = AppointmentModel(
      id: 'apt_test',
      doctorId: 'doc_1',
      doctorNameBn: 'ডা. টেস্ট',
      doctorNameEn: 'Dr. Test',
      specialityBn: 'টেস্ট',
      specialityEn: 'Test',
      date: 'Today',
      time: '10:00 AM',
      hospitalBn: 'টেস্ট হাসপাতাল',
      hospitalEn: 'Test Hospital',
      fee: 500,
      isVideo: false,
      statusBn: 'নিশ্চিতকৃত',
      statusEn: 'Confirmed',
      serialNumber: '#TEST-01',
    );
    AppointmentStore.instance.addAppointment(testApt);
    expect(AppointmentStore.instance.appointments.value.length, initialCount + 1);
  });

  test('Sasthyaloy auth controller initial blank state & dynamic profile test', () {
    final controller = AuthController.instance;

    // 1. Initial / Logged out state is blank
    controller.signOut();
    expect(controller.isLoggedIn, false);
    expect(controller.currentUser.nameEn, '');
    expect(controller.currentUser.familyMembers.isEmpty, true);

    // 2. Dynamic sign in / profile creation
    controller.signInWithPhone('+8801700000000', nameBn: 'শাখাওয়াত হোসেন', nameEn: 'Sakhawat Hossen');
    expect(controller.isLoggedIn, true);
    expect(controller.currentUser.phone, '+8801700000000');
    expect(controller.currentUser.nameEn, 'Sakhawat Hossen');

    // 3. Dynamic family member addition
    const member = FamilyMember(
      id: 'fam_test',
      nameBn: 'নুসরাত জাহান',
      nameEn: 'Nusrat Jahan',
      relationBn: 'স্ত্রী',
      relationEn: 'Spouse',
      age: 25,
      bloodGroup: 'O+',
    );
    controller.addFamilyMember(member);
    expect(controller.currentUser.familyMembers.length, 1);
    expect(controller.currentUser.familyMembers.first.nameEn, 'Nusrat Jahan');
  });

  test('Sasthyaloy storage service persistent session test', () {
    StorageService.setCompletedOnboarding(true);
    expect(StorageService.hasCompletedOnboarding(), true);
  });

  test('Sasthyaloy health records & vitals test', () {
    final controller = HealthRecordController.instance;
    expect(controller.labReportsNotifier.value.isNotEmpty, true);
    expect(controller.vitalsNotifier.value.isNotEmpty, true);
  });

  test('Sasthyaloy voice AI clinical triage test', () {
    final emergencyResult = ClinicalTriageEngine.analyzeSymptoms('আমার বুকে তীব্র ব্যথা ও শ্বাসকষ্ট', true);
    expect(emergencyResult.isEmergency, true);

    final routineResult = ClinicalTriageEngine.analyzeSymptoms('আমার হালকা জ্বর ও কাশি হচ্ছে', true);
    expect(routineResult.isEmergency, false);
  });

  test('Sasthyaloy payment & teleconsultation test', () {
    const receipt = TransactionReceipt(
      transactionId: 'TRX-BK948201',
      appointmentId: 'apt_101',
      doctorNameBn: 'অধ্যাপক ডা. তানভীর আহমেদ',
      doctorNameEn: 'Prof. Dr. Tanvir Ahmed',
      paymentMethod: 'bKash',
      doctorFee: 800,
      platformFee: 50,
      totalAmount: 850,
      date: 'Today',
      status: 'Success',
    );
    expect(receipt.totalAmount, 850);
    expect(receipt.paymentMethod, 'bKash');
  });

  testWidgets('Sasthyaloy teleconsultation screens instantiation test', (tester) async {
    const paymentScreen = PaymentCheckoutScreen(
      appointmentId: 'apt_101',
      doctorNameBn: 'ডা. টেস্ট',
      doctorNameEn: 'Dr. Test',
      specialityBn: 'কার্ডিওলজিস্ট',
      specialityEn: 'Cardiologist',
      fee: 800,
      isVideo: true,
    );
    expect(paymentScreen.fee, 800);

    const videoScreen = VideoConsultationRoomScreen(
      doctorNameBn: 'ডা. টেস্ট',
      doctorNameEn: 'Dr. Test',
      specialityBn: 'কার্ডিওলজিস্ট',
      specialityEn: 'Cardiologist',
    );
    expect(videoScreen.doctorNameBn, 'ডা. টেস্ট');

    const summaryScreen = PostConsultationSummaryScreen(
      doctorNameBn: 'ডা. টেস্ট',
      doctorNameEn: 'Dr. Test',
      specialityBn: 'কার্ডিওলজিস্ট',
      specialityEn: 'Cardiologist',
      callDuration: '12:35',
    );
    expect(summaryScreen.callDuration, '12:35');
  });

  testWidgets('Sasthyaloy back navigation & PopScope shell tests', (tester) async {
    const shellScreen = MainShellScreen(initialIndex: 0);
    expect(shellScreen.initialIndex, 0);

    const langScreenNormal = LanguageSelectionScreen();
    expect(langScreenNormal.isFromSettings, false);

    const langScreenSettings = LanguageSelectionScreen(isFromSettings: true);
    expect(langScreenSettings.isFromSettings, true);
  });

  testWidgets('Sasthyaloy menu, profile, and avatar widget sanity test', (tester) async {
    const menuScreen = MenuScreen();
    expect(menuScreen.key, null);

    const editProfileScreen = EditProfileScreen();
    expect(editProfileScreen.key, null);

    const avatarWidget = ProfileAvatarWidget(avatarId: 'avatar_1', size: 60, iconSize: 30);
    expect(avatarWidget.avatarId, 'avatar_1');
    expect(avatarWidget.size, 60);

    const customAvatar = ProfileAvatarWidget(avatarId: 'avatar_1', customImagePath: 'path/to/img.jpg', size: 60, iconSize: 30);
    expect(customAvatar.customImagePath, 'path/to/img.jpg');

    expect(ProfileAvatarInfo.all.length, 8);
    for (final avatar in ProfileAvatarInfo.all) {
      expect(avatar.id.isNotEmpty, true);
      expect(avatar.titleBn.isNotEmpty, true);
      expect(avatar.titleEn.isNotEmpty, true);
    }
  });

  test('Sasthyaloy emergency call phone cleaner test', () {
    expect(EmergencyCallService.cleanPhoneNumber('999'), '999');
    expect(EmergencyCallService.cleanPhoneNumber('16263'), '16263');
    expect(EmergencyCallService.cleanPhoneNumber('01811458524'), '01811458524');
    expect(EmergencyCallService.cleanPhoneNumber('02-55165088'), '0255165088');
    expect(EmergencyCallService.cleanPhoneNumber('+880 1819-876543'), '+8801819876543');
    expect(EmergencyCallService.cleanPhoneNumber(' (02) 5516-5088 '), '0255165088');
  });

  test('Sasthyaloy symptom auto-correction service test', () {
    final service = SymptomCorrectionService.instance;

    // 1. Banglish phonetic correction
    final banglishChest = service.correctSymptomText('buke betha', true);
    expect(banglishChest.contains('বুকে'), true);

    final banglishHead = service.correctSymptomText('matha betha', true);
    expect(banglishHead.contains('মাথাব্যথা'), true);

    // 2. English symptom normalization & typo correction
    final englishChest = service.correctSymptomText('chest pain', false);
    expect(englishChest.toLowerCase().contains('chest pain'), true);

    final englishHeadake = service.correctSymptomText('i have headake', true);
    expect(englishHeadake.toLowerCase().contains('headache'), true);

    // 3. Filler word removal
    final cleaned = service.correctSymptomText('um uh kashi', true);
    expect(cleaned.contains('um'), false);
    expect(cleaned.contains('কাশি'), true);
  });

  test('Sasthyaloy OpenRouter AI service test', () async {
    final aiService = OpenRouterService.instance;

    final emergencyResp = await aiService.queryMedicalAssistant(
      userQuery: 'আমার বুকে তীব্র ব্যথা ও চাপ লাগছে',
      isBangla: true,
    );
    expect(emergencyResp.isEmergency, true);

    final routineResp = await aiService.queryMedicalAssistant(
      userQuery: 'হালকা ঠান্ডা ও কাশি',
      isBangla: true,
    );
    expect(routineResp.isEmergency, false);
    expect(routineResp.homeRemedies.isNotEmpty, true);
  });

  test('Sasthyaloy Google Gemini AI service test', () async {
    final geminiService = GeminiService.instance;

    final emergencyResp = await geminiService.queryMedicalAssistant(
      userQuery: 'আমার বুকে তীব্র ব্যথা ও চাপ লাগছে',
      isBangla: true,
    );
    expect(emergencyResp.isEmergency, true);

    final routineResp = await geminiService.queryMedicalAssistant(
      userQuery: 'হালকা ঠান্ডা ও কাশি',
      isBangla: true,
    );
    expect(routineResp.isEmergency, false);
    expect(routineResp.homeRemedies.isNotEmpty, true);

    // Multi-turn chat model history test
    const chatHistory = [
      AiChatMessage(
        id: 'msg_hist_1',
        sender: 'user',
        text: 'আমার নাম শাফিন',
        timestamp: '10:00 AM',
      ),
      AiChatMessage(
        id: 'msg_hist_2',
        sender: 'ai',
        text: 'নমস্কার শাফিন। স্বাস্থ্যালয়ে স্বাগতম।',
        timestamp: '10:00 AM',
      ),
    ];
    final followUpResp = await geminiService.queryMedicalAssistant(
      userQuery: 'আমার পেটে ব্যথা করছে',
      isBangla: true,
      chatHistory: chatHistory,
    );
    expect(followUpResp.text.isNotEmpty, true);
  });

  test('Sasthyaloy TTS service text cleansing & state test', () async {
    final cleaned = TtsService.cleanTextForSpeech(
      '**জরুরি পরামর্শ:**\n- ১. পর্যাপ্ত পানি পান করুন\n• বিশ্রাম নিন',
    );
    expect(cleaned.contains('**'), false);
    expect(cleaned.contains('- '), false);
    expect(cleaned.contains('• '), false);

    await TtsService.instance.toggleSpeak(
      messageId: 'test_msg_101',
      text: 'হ্যালো স্বাস্থ্যালয়',
      isBangla: true,
    );
    expect(TtsService.instance.isPlaying, true);
    expect(TtsService.instance.currentSpeakingId, 'test_msg_101');

    await TtsService.instance.stop();
    expect(TtsService.instance.isPlaying, false);
    expect(TtsService.instance.currentSpeakingId, null);
  });

  test('Sasthyaloy Speech recognition service test', () async {
    final speechService = SpeechService.instance;
    final initSuccess = await speechService.initialize();
    expect(initSuccess, true);

    final started = await speechService.startListening(
      onResult: (text, isFinal) {},
      isBangla: true,
    );
    expect(started, true);
    expect(speechService.isListening, true);

    await speechService.stopListening();
    expect(speechService.isListening, false);
  });

  test('Sasthyaloy clinical triage headache vs fever vs greeting test', () {
    // 1. Headache should NEVER return fever or flu advice
    final headacheResult = ClinicalTriageEngine.analyzeSymptoms('আমার তীব্র মাথাব্যথা করছে', true);
    expect(headacheResult.isEmergency, false);
    expect(headacheResult.recommendedSpecialist?.contains('নিউরোলজিস্ট') ?? false, true);
    expect(headacheResult.text.contains('মাথাব্যথা'), true);
    expect(headacheResult.text.contains('১০১°F'), false);

    final headakeEngResult = ClinicalTriageEngine.analyzeSymptoms('i have headake', false);
    expect(headakeEngResult.isEmergency, false);
    expect(headakeEngResult.recommendedSpecialist?.contains('Neurologist') ?? false, true);

    // 2. Greeting should return polite welcome
    final greetingResult = ClinicalTriageEngine.analyzeSymptoms('hi', true);
    expect(greetingResult.text.contains('স্বাগতম'), true);

    // 3. Image attachment triage
    final imageResult = ClinicalTriageEngine.analyzeSymptoms(
      'ত্বকে র‍্যাশ উঠেছে',
      true,
      imagePath: 'test_path.jpg',
    );
    expect(imageResult.recommendedSpecialist?.contains('চর্ম') ?? false, true);
  });

  test('Sasthyaloy persistent chat session storage test', () async {
    const session = ChatSessionModel(
      id: 'session_test_999',
      title: 'মাথাব্যথা পরামর্শ',
      createdAt: '2026-11-15T15:30:00Z',
      updatedAt: '2026-11-15T15:30:00Z',
      messages: [
        AiChatMessage(
          id: 'msg_1',
          sender: 'user',
          text: 'আমার তীব্র মাথাব্যথা',
          timestamp: '03:30 PM',
        ),
        AiChatMessage(
          id: 'msg_2',
          sender: 'ai',
          text: 'বিশ্রাম নিন ও পানি পান করুন',
          timestamp: '03:30 PM',
        ),
      ],
    );

    await StorageService.saveChatSession(session);
    final sessions = StorageService.getChatSessions();
    expect(sessions.any((s) => s.id == 'session_test_999'), true);

    final retrieved = sessions.firstWhere((s) => s.id == 'session_test_999');
    expect(retrieved.title, 'মাথাব্যথা পরামর্শ');
    expect(retrieved.messages.length, 2);

    await StorageService.deleteChatSession('session_test_999');
    final afterDelete = StorageService.getChatSessions();
    expect(afterDelete.any((s) => s.id == 'session_test_999'), false);
  });

  testWidgets('Sasthyaloy Voice AI screen instantiation test', (tester) async {
    const voiceScreen = VoiceAiScreen();
    expect(voiceScreen.key, null);
  });
}
