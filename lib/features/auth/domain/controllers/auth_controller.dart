import 'package:flutter/foundation.dart';
import '../models/user_profile_model.dart';

class AuthController {
  AuthController._();
  static final AuthController instance = AuthController._();

  final ValueNotifier<UserProfileModel> userNotifier =
      ValueNotifier<UserProfileModel>(UserProfileModel.defaultUser);

  bool get isLoggedIn => userNotifier.value.isLoggedIn;
  UserProfileModel get currentUser => userNotifier.value;

  void signInWithPhone(String phone, {String? nameBn, String? nameEn}) {
    userNotifier.value = userNotifier.value.copyWith(
      phone: phone,
      nameBn: nameBn ?? 'মোঃ শাকাওয়াত হোসেন',
      nameEn: nameEn ?? 'Md. Sakhawat Hossen',
      isLoggedIn: true,
      id: 'PT-98421',
    );
  }

  void updateProfile({
    required String nameBn,
    required String nameEn,
    required String email,
    required int age,
    required String genderBn,
    required String genderEn,
    required String bloodGroup,
    required String emergencyContact,
    required String addressBn,
    required String addressEn,
  }) {
    userNotifier.value = userNotifier.value.copyWith(
      nameBn: nameBn,
      nameEn: nameEn,
      email: email,
      age: age,
      genderBn: genderBn,
      genderEn: genderEn,
      bloodGroup: bloodGroup,
      emergencyContact: emergencyContact,
      addressBn: addressBn,
      addressEn: addressEn,
    );
  }

  void switchFamilyMember(String memberId) {
    userNotifier.value = userNotifier.value.copyWith(activeMemberId: memberId);
  }

  void signOut() {
    userNotifier.value = UserProfileModel.guestUser;
  }
}
