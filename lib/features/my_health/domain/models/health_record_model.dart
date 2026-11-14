class TestParameter {
  final String name;
  final String result;
  final String unit;
  final String referenceRange;
  final bool isAbnormal;

  const TestParameter({
    required this.name,
    required this.result,
    required this.unit,
    required this.referenceRange,
    required this.isAbnormal,
  });
}

class LabReport {
  final String id;
  final String testNameBn;
  final String testNameEn;
  final String categoryBn;
  final String categoryEn;
  final String hospitalBn;
  final String hospitalEn;
  final String date;
  final String referringDoctorBn;
  final String referringDoctorEn;
  final String status; // 'Normal', 'Warning', 'Critical'
  final List<TestParameter> parameters;
  final String fileSize;
  final bool isDownloaded;

  const LabReport({
    required this.id,
    required this.testNameBn,
    required this.testNameEn,
    required this.categoryBn,
    required this.categoryEn,
    required this.hospitalBn,
    required this.hospitalEn,
    required this.date,
    required this.referringDoctorBn,
    required this.referringDoctorEn,
    required this.status,
    required this.parameters,
    required this.fileSize,
    required this.isDownloaded,
  });

  LabReport copyWith({bool? isDownloaded}) {
    return LabReport(
      id: id,
      testNameBn: testNameBn,
      testNameEn: testNameEn,
      categoryBn: categoryBn,
      categoryEn: categoryEn,
      hospitalBn: hospitalBn,
      hospitalEn: hospitalEn,
      date: date,
      referringDoctorBn: referringDoctorBn,
      referringDoctorEn: referringDoctorEn,
      status: status,
      parameters: parameters,
      fileSize: fileSize,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}

class VitalSignRecord {
  final String id;
  final int systolicBp;
  final int diastolicBp;
  final double bloodGlucose;
  final int heartRate;
  final int spO2;
  final double temperature;
  final double weightKg;
  final String recordedDate;
  final String recordedTime;
  final String notes;

  const VitalSignRecord({
    required this.id,
    required this.systolicBp,
    required this.diastolicBp,
    required this.bloodGlucose,
    required this.heartRate,
    required this.spO2,
    required this.temperature,
    required this.weightKg,
    required this.recordedDate,
    required this.recordedTime,
    required this.notes,
  });
}

class PrescribedMedicine {
  final String name;
  final String generic;
  final String dosage;
  final String instructionBn;
  final String instructionEn;
  final String duration;
  final bool beforeMeal;

  const PrescribedMedicine({
    required this.name,
    required this.generic,
    required this.dosage,
    required this.instructionBn,
    required this.instructionEn,
    required this.duration,
    required this.beforeMeal,
  });
}

class PrescriptionRecord {
  final String id;
  final String doctorNameBn;
  final String doctorNameEn;
  final String degrees;
  final String hospitalBn;
  final String hospitalEn;
  final String date;
  final String diagnosisBn;
  final String diagnosisEn;
  final List<PrescribedMedicine> medicines;
  final String adviceBn;
  final String adviceEn;

  const PrescriptionRecord({
    required this.id,
    required this.doctorNameBn,
    required this.doctorNameEn,
    required this.degrees,
    required this.hospitalBn,
    required this.hospitalEn,
    required this.date,
    required this.diagnosisBn,
    required this.diagnosisEn,
    required this.medicines,
    required this.adviceBn,
    required this.adviceEn,
  });
}
