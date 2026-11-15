import 'package:flutter/material.dart';

class ProfileAvatarInfo {
  final String id;
  final String titleBn;
  final String titleEn;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;

  const ProfileAvatarInfo({
    required this.id,
    required this.titleBn,
    required this.titleEn,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
  });

  static const List<ProfileAvatarInfo> all = [
    ProfileAvatarInfo(
      id: 'avatar_1',
      titleBn: 'পুরুষ চিকিৎসক / প্রফেশনাল',
      titleEn: 'Male Physician / Pro',
      icon: Icons.medical_services_rounded,
      primaryColor: Color(0xFF0F3E6D),
      secondaryColor: Color(0xFF0891B2),
    ),
    ProfileAvatarInfo(
      id: 'avatar_2',
      titleBn: 'নারী চিকিৎসক / প্রফেশনাল',
      titleEn: 'Female Physician / Pro',
      icon: Icons.health_and_safety_rounded,
      primaryColor: Color(0xFF0D9488),
      secondaryColor: Color(0xFF06B6D4),
    ),
    ProfileAvatarInfo(
      id: 'avatar_3',
      titleBn: 'তরুণ রোগী',
      titleEn: 'Young Patient (Male)',
      icon: Icons.person_rounded,
      primaryColor: Color(0xFF2563EB),
      secondaryColor: Color(0xFF38BDF8),
    ),
    ProfileAvatarInfo(
      id: 'avatar_4',
      titleBn: 'তরুণী রোগী',
      titleEn: 'Female Patient',
      icon: Icons.face_rounded,
      primaryColor: Color(0xFF7C3AED),
      secondaryColor: Color(0xFFA855F7),
    ),
    ProfileAvatarInfo(
      id: 'avatar_5',
      titleBn: 'প্রবীণ নাগরিক',
      titleEn: 'Senior Citizen',
      icon: Icons.elderly_rounded,
      primaryColor: Color(0xFFD97706),
      secondaryColor: Color(0xFFF59E0B),
    ),
    ProfileAvatarInfo(
      id: 'avatar_6',
      titleBn: 'হিজাব পরিহিতা',
      titleEn: 'Modest Patient',
      icon: Icons.person_pin_rounded,
      primaryColor: Color(0xFFE11D48),
      secondaryColor: Color(0xFFFB7185),
    ),
    ProfileAvatarInfo(
      id: 'avatar_7',
      titleBn: 'শিশু স্বাস্থ্য',
      titleEn: 'Child Care',
      icon: Icons.child_care_rounded,
      primaryColor: Color(0xFF059669),
      secondaryColor: Color(0xFF34D399),
    ),
    ProfileAvatarInfo(
      id: 'avatar_8',
      titleBn: 'সাধারণ নাগরিক',
      titleEn: 'Classic Member',
      icon: Icons.account_circle_rounded,
      primaryColor: Color(0xFF475569),
      secondaryColor: Color(0xFF64748B),
    ),
  ];

  static ProfileAvatarInfo getById(String id) {
    return all.firstWhere(
      (a) => a.id == id,
      orElse: () => all.first,
    );
  }
}

class ProfileAvatarWidget extends StatelessWidget {
  final String avatarId;
  final double size;
  final double iconSize;

  const ProfileAvatarWidget({
    super.key,
    required this.avatarId,
    this.size = 88,
    this.iconSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    final info = ProfileAvatarInfo.getById(avatarId);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [info.primaryColor, info.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: info.primaryColor.withOpacity(0.3),
            blurRadius: size * 0.15,
            offset: Offset(0, size * 0.05),
          ),
        ],
        border: Border.all(color: Colors.white, width: size > 60 ? 3 : 2),
      ),
      child: Center(
        child: Icon(
          info.icon,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
