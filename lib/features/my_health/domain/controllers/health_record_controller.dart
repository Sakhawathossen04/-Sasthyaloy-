import 'package:flutter/foundation.dart';
import '../models/health_record_model.dart';

class HealthRecordController {
  HealthRecordController._();
  static final HealthRecordController instance = HealthRecordController._();

  final ValueNotifier<List<LabReport>> labReportsNotifier =
      ValueNotifier<List<LabReport>>([
    const LabReport(
      id: 'rpt_01',
      testNameBn: 'কমপ্লিট ব্লাড কাউন্ট (CBC Routine)',
      testNameEn: 'Complete Blood Count (CBC Routine)',
      categoryBn: 'ল্যাবরেটরি টেস্ট',
      categoryEn: 'Laboratory',
      hospitalBn: 'পপুলার ডায়াগনস্টিক সেন্টার, ধানমন্ডি',
      hospitalEn: 'Popular Diagnostic Centre, Dhanmondi',
      date: '10 Nov 2026',
      referringDoctorBn: 'ডা. রফিকুল ইসলাম',
      referringDoctorEn: 'Dr. Rafiqul Islam',
      status: 'Normal',
      fileSize: '1.4 MB',
      isDownloaded: true,
      parameters: [
        TestParameter(
          name: 'Hemoglobin (Hb)',
          result: '14.2',
          unit: 'g/dL',
          referenceRange: '13.0 - 17.5',
          isAbnormal: false,
        ),
        TestParameter(
          name: 'Total WBC Count',
          result: '7,800',
          unit: '/cumm',
          referenceRange: '4,000 - 11,000',
          isAbnormal: false,
        ),
        TestParameter(
          name: 'Platelet Count',
          result: '280,000',
          unit: '/cumm',
          referenceRange: '150,000 - 450,000',
          isAbnormal: false,
        ),
        TestParameter(
          name: 'ESR (1st Hour)',
          result: '12',
          unit: 'mm',
          referenceRange: '0 - 15',
          isAbnormal: false,
        ),
      ],
    ),
    const LabReport(
      id: 'rpt_02',
      testNameBn: 'ফাস্টিং লিপিড প্রোফাইল (Lipid Profile)',
      testNameEn: 'Fasting Lipid Profile',
      categoryBn: 'ল্যাবরেটরি টেস্ট',
      categoryEn: 'Laboratory',
      hospitalBn: 'স্কয়ার হাসপাতাল লিমিটেড, ঢাকা',
      hospitalEn: 'Square Hospital Ltd, Dhaka',
      date: '02 Nov 2026',
      referringDoctorBn: 'অধ্যাপক ডা. তানভীর আহমেদ',
      referringDoctorEn: 'Prof. Dr. Tanvir Ahmed',
      status: 'Warning',
      fileSize: '2.1 MB',
      isDownloaded: false,
      parameters: [
        TestParameter(
          name: 'Total Cholesterol',
          result: '215',
          unit: 'mg/dL',
          referenceRange: '< 200',
          isAbnormal: true,
        ),
        TestParameter(
          name: 'Triglycerides',
          result: '165',
          unit: 'mg/dL',
          referenceRange: '< 150',
          isAbnormal: true,
        ),
        TestParameter(
          name: 'HDL (Good) Cholesterol',
          result: '48',
          unit: 'mg/dL',
          referenceRange: '> 40',
          isAbnormal: false,
        ),
        TestParameter(
          name: 'LDL (Bad) Cholesterol',
          result: '134',
          unit: 'mg/dL',
          referenceRange: '< 100',
          isAbnormal: true,
        ),
      ],
    ),
    const LabReport(
      id: 'rpt_03',
      testNameBn: 'চেস্ট এক্স-রে পিএ ভিউ (Chest X-Ray PA)',
      testNameEn: 'Digital Chest X-Ray PA View',
      categoryBn: 'রেডিওলজি ও ইমেজিং',
      categoryEn: 'Radiology',
      hospitalBn: 'ঢাকা মেডিকেল কলেজ হাসপাতাল',
      hospitalEn: 'Dhaka Medical College Hospital',
      date: '18 Oct 2026',
      referringDoctorBn: 'ডা. ফারহানা চৌধুরী',
      referringDoctorEn: 'Dr. Farhana Chowdhury',
      status: 'Normal',
      fileSize: '4.8 MB',
      isDownloaded: false,
      parameters: [
        TestParameter(
          name: 'Cardiac Silhouette',
          result: 'Normal in size and shape',
          unit: '-',
          referenceRange: 'Normal',
          isAbnormal: false,
        ),
        TestParameter(
          name: 'Bony Thorax',
          result: 'Intact, no fracture',
          unit: '-',
          referenceRange: 'Intact',
          isAbnormal: false,
        ),
        TestParameter(
          name: 'Lung Fields',
          result: 'Clear, no active focal lesion',
          unit: '-',
          referenceRange: 'Clear',
          isAbnormal: false,
        ),
      ],
    ),
  ]);

  final ValueNotifier<List<VitalSignRecord>> vitalsNotifier =
      ValueNotifier<List<VitalSignRecord>>([
    const VitalSignRecord(
      id: 'vt_01',
      systolicBp: 120,
      diastolicBp: 80,
      bloodGlucose: 5.6,
      heartRate: 74,
      spO2: 98,
      temperature: 98.4,
      weightKg: 68.5,
      recordedDate: 'আজ (Today)',
      recordedTime: '08:30 AM',
      notes: 'নিয়ন্ত্রিত ও স্বাভাবিক রিডিং',
    ),
    const VitalSignRecord(
      id: 'vt_02',
      systolicBp: 125,
      diastolicBp: 82,
      bloodGlucose: 5.8,
      heartRate: 76,
      spO2: 99,
      temperature: 98.6,
      weightKg: 68.7,
      recordedDate: 'গতকাল (Yesterday)',
      recordedTime: '09:00 PM',
      notes: 'রাতের খাবারের ২ ঘণ্টা পর',
    ),
  ]);

  final ValueNotifier<List<PrescriptionRecord>> prescriptionsNotifier =
      ValueNotifier<List<PrescriptionRecord>>([
    const PrescriptionRecord(
      id: 'rx_01',
      doctorNameBn: 'অধ্যাপক ডা. তানভীর আহমেদ',
      doctorNameEn: 'Prof. Dr. Tanvir Ahmed',
      degrees: 'MBBS, FCPS (Cardiology), MD',
      hospitalBn: 'স্কয়ার হাসপাতাল, পান্থপথ, ঢাকা',
      hospitalEn: 'Square Hospital, Panthapath, Dhaka',
      date: '10 Nov 2026',
      diagnosisBn: 'প্রাথমিক উচ্চ রক্তচাপ ও ডিসলিপিডেমিয়া',
      diagnosisEn: 'Primary Hypertension & Dyslipidemia',
      adviceBn:
          'প্রতিদিন ৩০ মিনিট হাঁটুন, অতিরিক্ত লবণ বর্জন করুন এবং তৈলাক্ত খাবার পরিহার করুন।',
      adviceEn:
          'Daily 30 minutes brisk walking, low salt intake and restrict oily foods.',
      medicines: [
        PrescribedMedicine(
          name: 'Tab. Concor 2.5mg',
          generic: 'Bisoprolol Fumarate',
          dosage: '১ + ০ + ০',
          instructionBn: 'সকালে নাস্তার পর ১টি',
          instructionEn: '1 tablet in the morning after breakfast',
          duration: '১ মাস (1 Month)',
          beforeMeal: false,
        ),
        PrescribedMedicine(
          name: 'Tab. Lipiget 10mg',
          generic: 'Atorvastatin Calcium',
          dosage: '০ + ০ + ১',
          instructionBn: 'রাতে খাবারের পর ১টি',
          instructionEn: '1 tablet at night after dinner',
          duration: '১ মাস (1 Month)',
          beforeMeal: false,
        ),
        PrescribedMedicine(
          name: 'Cap. Seclo 20mg',
          generic: 'Omeprazole',
          dosage: '১ + ০ + ১',
          instructionBn: 'খাবারের ৩০ মিনিট পূর্বে',
          instructionEn: '30 mins before breakfast and dinner',
          duration: '১৪ দিন (14 Days)',
          beforeMeal: true,
        ),
      ],
    ),
  ]);

  void addVitalSign(VitalSignRecord record) {
    final list = List<VitalSignRecord>.from(vitalsNotifier.value);
    list.insert(0, record);
    vitalsNotifier.value = list;
  }

  void toggleDownloadReport(String id) {
    final list = List<LabReport>.from(labReportsNotifier.value);
    final idx = list.indexWhere((r) => r.id == id);
    if (idx != -1) {
      final current = list[idx];
      list[idx] = current.copyWith(isDownloaded: !current.isDownloaded);
      labReportsNotifier.value = list;
    }
  }
}
