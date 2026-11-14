class FamilyMember {
  final String id;
  final String nameBn;
  final String nameEn;
  final String relationBn;
  final String relationEn;
  final int age;
  final String bloodGroup;

  const FamilyMember({
    required this.id,
    required this.nameBn,
    required this.nameEn,
    required this.relationBn,
    required this.relationEn,
    required this.age,
    required this.bloodGroup,
  });
}

class UserProfileModel {
  final String id;
  final String nameBn;
  final String nameEn;
  final String phone;
  final String email;
  final int age;
  final String genderBn;
  final String genderEn;
  final String bloodGroup;
  final String emergencyContact;
  final String addressBn;
  final String addressEn;
  final bool isLoggedIn;
  final List<FamilyMember> familyMembers;
  final String activeMemberId;

  const UserProfileModel({
    required this.id,
    required this.nameBn,
    required this.nameEn,
    required this.phone,
    required this.email,
    required this.age,
    required this.genderBn,
    required this.genderEn,
    required this.bloodGroup,
    required this.emergencyContact,
    required this.addressBn,
    required this.addressEn,
    required this.isLoggedIn,
    required this.familyMembers,
    required this.activeMemberId,
  });

  UserProfileModel copyWith({
    String? id,
    String? nameBn,
    String? nameEn,
    String? phone,
    String? email,
    int? age,
    String? genderBn,
    String? genderEn,
    String? bloodGroup,
    String? emergencyContact,
    String? addressBn,
    String? addressEn,
    bool? isLoggedIn,
    List<FamilyMember>? familyMembers,
    String? activeMemberId,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      nameBn: nameBn ?? this.nameBn,
      nameEn: nameEn ?? this.nameEn,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      age: age ?? this.age,
      genderBn: genderBn ?? this.genderBn,
      genderEn: genderEn ?? this.genderEn,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      addressBn: addressBn ?? this.addressBn,
      addressEn: addressEn ?? this.addressEn,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      familyMembers: familyMembers ?? this.familyMembers,
      activeMemberId: activeMemberId ?? this.activeMemberId,
    );
  }

  static UserProfileModel get guestUser => const UserProfileModel(
        id: 'GUEST-00',
        nameBn: 'অতিথি ব্যবহারকারী',
        nameEn: 'Guest User',
        phone: '',
        email: '',
        age: 0,
        genderBn: 'অনির্দিষ্ট',
        genderEn: 'Unspecified',
        bloodGroup: 'N/A',
        emergencyContact: '',
        addressBn: 'ঢাকা, বাংলাদেশ',
        addressEn: 'Dhaka, Bangladesh',
        isLoggedIn: false,
        familyMembers: [],
        activeMemberId: 'self',
      );

  static UserProfileModel get defaultUser => const UserProfileModel(
        id: 'PT-98421',
        nameBn: 'মোঃ শাকাওয়াত হোসেন',
        nameEn: 'Md. Sakhawat Hossen',
        phone: '+880 1712-345678',
        email: 'sakhawat.hossen@example.com',
        age: 28,
        genderBn: 'পুরুষ',
        genderEn: 'Male',
        bloodGroup: 'B+',
        emergencyContact: '+880 1819-876543',
        addressBn: 'বাড়ি #১২, রোড #০৫, ধানমন্ডি, ঢাকা',
        addressEn: 'House #12, Road #05, Dhanmondi, Dhaka',
        isLoggedIn: true,
        familyMembers: [
          FamilyMember(
            id: 'self',
            nameBn: 'মোঃ শাকাওয়াত হোসেন (নিজে)',
            nameEn: 'Md. Sakhawat Hossen (Self)',
            relationBn: 'নিজে',
            relationEn: 'Self',
            age: 28,
            bloodGroup: 'B+',
          ),
          FamilyMember(
            id: 'fam_1',
            nameBn: 'নুসরাত জাহান (স্ত্রী)',
            nameEn: 'Nusrat Jahan (Spouse)',
            relationBn: 'স্ত্রী',
            relationEn: 'Spouse',
            age: 25,
            bloodGroup: 'O+',
          ),
          FamilyMember(
            id: 'fam_2',
            nameBn: 'আয়ান হোসেন (সন্তান)',
            nameEn: 'Ayaan Hossen (Child)',
            relationBn: 'সন্তান',
            relationEn: 'Child',
            age: 3,
            bloodGroup: 'B+',
          ),
        ],
        activeMemberId: 'self',
      );
}
