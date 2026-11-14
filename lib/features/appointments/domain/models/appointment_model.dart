import 'package:flutter/foundation.dart';

class AppointmentModel {
  final String id;
  final String doctorId;
  final String doctorNameBn;
  final String doctorNameEn;
  final String specialityBn;
  final String specialityEn;
  final String date;
  final String time;
  final String hospitalBn;
  final String hospitalEn;
  final int fee;
  final bool isVideo;
  final String statusBn;
  final String statusEn;
  final String serialNumber;

  const AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.doctorNameBn,
    required this.doctorNameEn,
    required this.specialityBn,
    required this.specialityEn,
    required this.date,
    required this.time,
    required this.hospitalBn,
    required this.hospitalEn,
    required this.fee,
    required this.isVideo,
    required this.statusBn,
    required this.statusEn,
    required this.serialNumber,
  });
}

class AppointmentStore {
  AppointmentStore._();
  static final AppointmentStore instance = AppointmentStore._();

  final ValueNotifier<List<AppointmentModel>> appointments = ValueNotifier<List<AppointmentModel>>([
    const AppointmentModel(
      id: 'apt_101',
      doctorId: 'doc_1',
      doctorNameBn: 'অধ্যাপক ডা. তানভীর আহমেদ',
      doctorNameEn: 'Prof. Dr. Tanvir Ahmed',
      specialityBn: 'কার্ডিওলজিস্ট (হৃদরোগ বিশেষজ্ঞ)',
      specialityEn: 'Cardiologist',
      date: '16 Nov 2026',
      time: '05:30 PM',
      hospitalBn: 'স্কয়ার হাসপাতাল, ঢাকা',
      hospitalEn: 'Square Hospital, Dhaka',
      fee: 800,
      isVideo: true,
      statusBn: 'নিশ্চিতকৃত',
      statusEn: 'Confirmed',
      serialNumber: '#SL-4081',
    ),
    const AppointmentModel(
      id: 'apt_102',
      doctorId: 'doc_2',
      doctorNameBn: 'ডা. ফারহানা চৌধুরী',
      doctorNameEn: 'Dr. Farhana Chowdhury',
      specialityBn: 'স্ত্রীরোগ ও প্রসূতিবিদ্যা বিশেষজ্ঞ',
      specialityEn: 'Gynecologist',
      date: '19 Nov 2026',
      time: '05:00 PM',
      hospitalBn: 'ঢাকা মেডিকেল কলেজ হাসপাতাল',
      hospitalEn: 'Dhaka Medical College Hospital',
      fee: 1000,
      isVideo: false,
      statusBn: 'অপেক্ষমাণ',
      statusEn: 'Pending',
      serialNumber: '#SL-4082',
    ),
  ]);

  void addAppointment(AppointmentModel apt) {
    final list = List<AppointmentModel>.from(appointments.value);
    list.insert(0, apt);
    appointments.value = list;
  }
}
