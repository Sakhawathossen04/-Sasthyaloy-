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

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameBn': nameBn,
        'nameEn': nameEn,
        'relationBn': relationBn,
        'relationEn': relationEn,
        'age': age,
        'bloodGroup': bloodGroup,
      };

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
        id: json['id'] as String? ?? '',
        nameBn: json['nameBn'] as String? ?? '',
        nameEn: json['nameEn'] as String? ?? '',
        relationBn: json['relationBn'] as String? ?? '',
        relationEn: json['relationEn'] as String? ?? '',
        age: (json['age'] is num) ? (json['age'] as num).toInt() : 0,
        bloodGroup: json['bloodGroup'] as String? ?? 'N/A',
      );
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
  final String avatarId;

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
    this.avatarId = 'avatar_1',
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
    String? avatarId,
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
      avatarId: avatarId ?? this.avatarId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameBn': nameBn,
        'nameEn': nameEn,
        'phone': phone,
        'email': email,
        'age': age,
        'genderBn': genderBn,
        'genderEn': genderEn,
        'bloodGroup': bloodGroup,
        'emergencyContact': emergencyContact,
        'addressBn': addressBn,
        'addressEn': addressEn,
        'isLoggedIn': isLoggedIn,
        'familyMembers': familyMembers.map((m) => m.toJson()).toList(),
        'activeMemberId': activeMemberId,
        'avatarId': avatarId,
      };

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        id: json['id'] as String? ?? 'GUEST-00',
        nameBn: json['nameBn'] as String? ?? '',
        nameEn: json['nameEn'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        email: json['email'] as String? ?? '',
        age: (json['age'] is num) ? (json['age'] as num).toInt() : 0,
        genderBn: json['genderBn'] as String? ?? 'অনির্দিষ্ট',
        genderEn: json['genderEn'] as String? ?? 'Unspecified',
        bloodGroup: json['bloodGroup'] as String? ?? 'N/A',
        emergencyContact: json['emergencyContact'] as String? ?? '',
        addressBn: json['addressBn'] as String? ?? '',
        addressEn: json['addressEn'] as String? ?? '',
        isLoggedIn: json['isLoggedIn'] as bool? ?? false,
        familyMembers: (json['familyMembers'] as List<dynamic>?)
                ?.map((item) => FamilyMember.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [],
        activeMemberId: json['activeMemberId'] as String? ?? 'self',
        avatarId: json['avatarId'] as String? ?? 'avatar_1',
      );

  /// Initially blank / logged-out user (Guest)
  static UserProfileModel get blankGuest => const UserProfileModel(
        id: 'GUEST-00',
        nameBn: '',
        nameEn: '',
        phone: '',
        email: '',
        age: 0,
        genderBn: 'অনির্দিষ্ট',
        genderEn: 'Unspecified',
        bloodGroup: 'N/A',
        emergencyContact: '',
        addressBn: '',
        addressEn: '',
        isLoggedIn: false,
        familyMembers: [],
        activeMemberId: 'self',
        avatarId: 'avatar_1',
      );

  /// Alias for backward compatibility
  static UserProfileModel get guestUser => blankGuest;

  /// Sample demo user for testing/seeding if needed
  static UserProfileModel get sampleDemoUser => const UserProfileModel(
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
        familyMembers: [],
        activeMemberId: 'self',
        avatarId: 'avatar_1',
      );
}
