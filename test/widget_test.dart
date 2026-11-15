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
}
