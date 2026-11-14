import 'package:flutter_test/flutter_test.dart';
import 'package:sasthyaloy/core/constants/app_strings.dart';
import 'package:sasthyaloy/features/doctors/domain/models/doctor_model.dart';
import 'package:sasthyaloy/features/appointments/domain/models/appointment_model.dart';

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
}
