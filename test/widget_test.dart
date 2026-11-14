import 'package:flutter_test/flutter_test.dart';
import 'package:sasthyaloy/core/constants/app_strings.dart';
import 'package:sasthyaloy/features/doctors/domain/models/doctor_model.dart';
import 'package:sasthyaloy/features/appointments/domain/models/appointment_model.dart';
import 'package:sasthyaloy/features/auth/domain/controllers/auth_controller.dart';
import 'package:sasthyaloy/features/my_health/domain/controllers/health_record_controller.dart';
import 'package:sasthyaloy/features/voice_ai/domain/models/symptom_triage_model.dart';

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

  test('Sasthyaloy auth controller test', () {
    final controller = AuthController.instance;
    expect(controller.currentUser.nameEn, 'Md. Sakhawat Hossen');
    expect(controller.isLoggedIn, true);
  });

  test('Sasthyaloy health records & vitals test', () {
    final controller = HealthRecordController.instance;
    expect(controller.labReportsNotifier.value.isNotEmpty, true);
    expect(controller.vitalsNotifier.value.isNotEmpty, true);
  });

  test('Sasthyaloy voice AI clinical triage test', () {
    // 1. Red Flag Emergency Test
    final emergencyResult = ClinicalTriageEngine.analyzeSymptoms('আমার বুকে তীব্র ব্যথা ও শ্বাসকষ্ট', true);
    expect(emergencyResult.isEmergency, true);
    expect(emergencyResult.firstAidAdvice != null, true);

    // 2. Routine Symptom Test
    final routineResult = ClinicalTriageEngine.analyzeSymptoms('আমার হালকা জ্বর ও কাশি হচ্ছে', true);
    expect(routineResult.isEmergency, false);
    expect(routineResult.homeRemedies.isNotEmpty, true);
  });
}
