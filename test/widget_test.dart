import 'package:flutter_test/flutter_test.dart';
import 'package:sasthyaloy/core/constants/app_strings.dart';
import 'package:sasthyaloy/features/doctors/domain/models/doctor_model.dart';
import 'package:sasthyaloy/features/appointments/domain/models/appointment_model.dart';
import 'package:sasthyaloy/features/auth/domain/controllers/auth_controller.dart';
import 'package:sasthyaloy/features/my_health/domain/controllers/health_record_controller.dart';
import 'package:sasthyaloy/features/my_health/domain/models/health_record_model.dart';

void main() {
  test('Sasthyaloy brand identity test', () {
    expect(AppStrings.appNameBn, 'স্বাস্থ্যালয়');
    expect(AppStrings.appNameEn, 'Sasthyaloy');
  });

  test('Sasthyaloy doctor directory test', () {
    final doctors = DoctorModel.sampleDoctors;
    expect(doctors.isNotEmpty, true);
    expect(doctors.any((d) => d.id == 'doc_1'), true);
    expect(doctors.first.nameBn.contains('তানভীর'), true);
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
    expect(controller.currentUser.familyMembers.length, 3);
  });

  test('Sasthyaloy health records & vitals test', () {
    final controller = HealthRecordController.instance;
    expect(controller.labReportsNotifier.value.isNotEmpty, true);
    expect(controller.vitalsNotifier.value.isNotEmpty, true);
    expect(controller.prescriptionsNotifier.value.isNotEmpty, true);

    final initialVitals = controller.vitalsNotifier.value.length;
    controller.addVitalSign(
      const VitalSignRecord(
        id: 'vt_test',
        systolicBp: 118,
        diastolicBp: 78,
        bloodGlucose: 5.2,
        heartRate: 70,
        spO2: 99,
        temperature: 98.6,
        weightKg: 68.0,
        recordedDate: 'Today',
        recordedTime: '12:00 PM',
        notes: 'Test record',
      ),
    );
    expect(controller.vitalsNotifier.value.length, initialVitals + 1);
  });
}
