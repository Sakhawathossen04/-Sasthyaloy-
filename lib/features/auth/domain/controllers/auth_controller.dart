import 'package:flutter/foundation.dart';
import '../../../../core/services/storage_service.dart';
import '../models/user_profile_model.dart';

class AuthController {
  AuthController._();
  static final AuthController instance = AuthController._();

  final ValueNotifier<UserProfileModel> userNotifier =
      ValueNotifier<UserProfileModel>(UserProfileModel.blankGuest);

  bool get isLoggedIn => userNotifier.value.isLoggedIn;
  UserProfileModel get currentUser => userNotifier.value;

  Future<void> init() async {
    final savedUser = StorageService.loadUserProfile();
    if (savedUser != null) {
      userNotifier.value = savedUser;
    } else {
      userNotifier.value = UserProfileModel.blankGuest;
    }
  }

  void signInWithPhone(String phone, {String? nameBn, String? nameEn}) {
    final current = userNotifier.value;
    final updated = current.copyWith(
      phone: phone,
      nameBn: nameBn ?? (current.nameBn.isNotEmpty ? current.nameBn : ''),
      nameEn: nameEn ?? (current.nameEn.isNotEmpty ? current.nameEn : ''),
      isLoggedIn: true,
      id: (current.id.isEmpty || current.id == 'GUEST-00')
          ? 'PT-${(DateTime.now().millisecondsSinceEpoch % 90000) + 10000}'
          : current.id,
    );
    userNotifier.value = updated;
    StorageService.saveUserProfile(updated);
    StorageService.setCompletedOnboarding(true);
  }

  void updateProfile({
    required String nameBn,
    required String nameEn,
    String? phone,
    required String email,
    required int age,
    required String genderBn,
    required String genderEn,
    required String bloodGroup,
    required String emergencyContact,
    required String addressBn,
    required String addressEn,
    String? avatarId,
    String? customImagePath,
  }) {
    final current = userNotifier.value;
    final updated = current.copyWith(
      nameBn: nameBn,
      nameEn: nameEn,
      phone: phone ?? current.phone,
      email: email,
      age: age,
      genderBn: genderBn,
      genderEn: genderEn,
      bloodGroup: bloodGroup,
      emergencyContact: emergencyContact,
      addressBn: addressBn,
      addressEn: addressEn,
      avatarId: avatarId ?? current.avatarId,
      customImagePath: customImagePath ?? current.customImagePath,
      isLoggedIn: true,
      id: (current.id.isEmpty || current.id == 'GUEST-00')
          ? 'PT-${(DateTime.now().millisecondsSinceEpoch % 90000) + 10000}'
          : current.id,
    );
    userNotifier.value = updated;
    StorageService.saveUserProfile(updated);
    StorageService.setCompletedOnboarding(true);
  }

  void addFamilyMember(FamilyMember member) {
    final current = userNotifier.value;
    final updatedList = List<FamilyMember>.from(current.familyMembers)..add(member);
    final updated = current.copyWith(
      familyMembers: updatedList,
      activeMemberId: current.activeMemberId.isEmpty ? member.id : current.activeMemberId,
    );
    userNotifier.value = updated;
    StorageService.saveUserProfile(updated);
  }

  void removeFamilyMember(String memberId) {
    final current = userNotifier.value;
    final updatedList = current.familyMembers.where((m) => m.id != memberId).toList();
    final activeId = current.activeMemberId == memberId
        ? (updatedList.isNotEmpty ? updatedList.first.id : 'self')
        : current.activeMemberId;
    final updated = current.copyWith(
      familyMembers: updatedList,
      activeMemberId: activeId,
    );
    userNotifier.value = updated;
    StorageService.saveUserProfile(updated);
  }

  void switchFamilyMember(String memberId) {
    final updated = userNotifier.value.copyWith(activeMemberId: memberId);
    userNotifier.value = updated;
    StorageService.saveUserProfile(updated);
  }

  void signOut() {
    userNotifier.value = UserProfileModel.blankGuest;
    StorageService.clearAuthSession();
  }
}
