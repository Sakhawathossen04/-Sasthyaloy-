import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../domain/controllers/auth_controller.dart';
import '../widgets/profile_avatar_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameBnController;
  late TextEditingController _nameEnController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _emergencyController;
  late TextEditingController _addressBnController;
  late TextEditingController _addressEnController;
  late String _selectedBloodGroup;
  late String _selectedGenderBn;
  late String _selectedGenderEn;
  late String _selectedAvatarId;
  String? _customImagePath;

  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  void initState() {
    super.initState();
    final user = AuthController.instance.currentUser;
    _nameBnController = TextEditingController(text: user.nameBn);
    _nameEnController = TextEditingController(text: user.nameEn);
    _phoneController = TextEditingController(text: user.phone);
    _emailController = TextEditingController(text: user.email);
    _ageController = TextEditingController(text: user.age > 0 ? user.age.toString() : '');
    _emergencyController = TextEditingController(text: user.emergencyContact);
    _addressBnController = TextEditingController(text: user.addressBn);
    _addressEnController = TextEditingController(text: user.addressEn);
    _selectedBloodGroup = _bloodGroups.contains(user.bloodGroup) ? user.bloodGroup : 'B+';
    _selectedGenderBn = user.genderBn.isNotEmpty ? user.genderBn : 'পুরুষ';
    _selectedGenderEn = user.genderEn.isNotEmpty ? user.genderEn : 'Male';
    _selectedAvatarId = user.avatarId.isNotEmpty ? user.avatarId : 'avatar_1';
    _customImagePath = user.customImagePath;
  }

  @override
  void dispose() {
    _nameBnController.dispose();
    _nameEnController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _emergencyController.dispose();
    _addressBnController.dispose();
    _addressEnController.dispose();
    super.dispose();
  }

  void _showAvatarPickerModal(BuildContext context, bool isBn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isBn
                            ? 'প্রোফাইল ছবি বা অবতার বাছুন'
                            : 'Select Profile Photo / Avatar',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  Text(
                    isBn
                        ? 'আপনার পছন্দমতো গ্যালারি থেকে ছবি আপলোড করুন অথবা অবতার বেছে নিন:'
                        : 'Upload a custom photo from gallery or choose an avatar:',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),

                  // Option 1: Gallery Upload Button
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.brandCyan.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.brandCyan.withOpacity(0.3)),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.brandCyan.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.photo_library_rounded, color: AppColors.brandCyan),
                      ),
                      title: Text(
                        isBn ? 'গ্যালারি থেকে ছবি নির্বাচন (Upload from Gallery)' : 'Upload from Gallery',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                      subtitle: Text(
                        isBn ? 'ফোনের গ্যালারি থেকে নিজস্ব ছবি যুক্ত করুন' : 'Choose a picture from your gallery',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: AppColors.brandCyan),
                      onTap: () async {
                        Navigator.of(ctx).pop();
                        try {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(
                            source: ImageSource.gallery,
                            maxWidth: 800,
                            maxHeight: 800,
                            imageQuality: 80,
                          );
                          if (picked != null) {
                            setState(() {
                              _customImagePath = picked.path;
                            });
                          }
                        } catch (e) {
                          debugPrint('Error picking from gallery: $e');
                        }
                      },
                    ),
                  ),

                  // Option 2: Camera Photo
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.emeraldGreen.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.emeraldGreen.withOpacity(0.3)),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldGreen.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: AppColors.emeraldGreen),
                      ),
                      title: Text(
                        isBn ? 'ক্যামেরা দিয়ে ছবি তুলুন (Take Photo)' : 'Take Photo with Camera',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                      subtitle: Text(
                        isBn ? 'নতুন সেলফি বা প্রোফাইল ছবি তুলুন' : 'Capture a new selfie or profile photo',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: AppColors.emeraldGreen),
                      onTap: () async {
                        Navigator.of(ctx).pop();
                        try {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(
                            source: ImageSource.camera,
                            maxWidth: 800,
                            maxHeight: 800,
                            imageQuality: 80,
                          );
                          if (picked != null) {
                            setState(() {
                              _customImagePath = picked.path;
                            });
                          }
                        } catch (e) {
                          debugPrint('Error capturing from camera: $e');
                        }
                      },
                    ),
                  ),

                  if (_customImagePath != null && _customImagePath!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.sosRed,
                          side: const BorderSide(color: AppColors.sosRed),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          minimumSize: const Size(double.infinity, 44),
                        ),
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: Text(isBn ? 'কাস্টম ছবি বাতিল করে অবতার ব্যবহার করুন' : 'Remove Custom Photo & Use Avatar'),
                        onPressed: () {
                          setState(() {
                            _customImagePath = null;
                          });
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ),

                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          isBn ? 'অথবা অবতার বেছে নিন' : 'Or choose an avatar',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Avatars Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ProfileAvatarInfo.all.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final avatar = ProfileAvatarInfo.all[index];
                      final isSelected = _customImagePath == null && _selectedAvatarId == avatar.id;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedAvatarId = avatar.id;
                            _customImagePath = null;
                          });
                          Navigator.of(ctx).pop();
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.brandCyan.withOpacity(0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? AppColors.brandCyan : AppColors.borderLight,
                              width: isSelected ? 2.5 : 1.0,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ProfileAvatarWidget(
                                avatarId: avatar.id,
                                size: 46,
                                iconSize: 24,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                isBn ? avatar.titleBn.split(' ').first : avatar.titleEn.split(' ').first,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? AppColors.primaryNavy : AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _saveProfile() {
    final age = int.tryParse(_ageController.text) ?? 0;
    final nameBn = _nameBnController.text.trim();
    final nameEn = _nameEnController.text.trim();
    final phone = _phoneController.text.trim();

    if (nameBn.isEmpty && nameEn.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.sosRed,
          behavior: SnackBarBehavior.floating,
          content: Text(
            AppLocaleController.instance.isBangla
                ? 'অনুগ্রহ করে অন্তত আপনার নাম বাংলায় বা ইংরেজিতে লিখুন।'
                : 'Please enter your name in Bangla or English.',
          ),
        ),
      );
      return;
    }

    AuthController.instance.updateProfile(
      nameBn: nameBn.isNotEmpty ? nameBn : nameEn,
      nameEn: nameEn.isNotEmpty ? nameEn : nameBn,
      phone: phone.isNotEmpty ? phone : null,
      email: _emailController.text.trim(),
      age: age,
      genderBn: _selectedGenderBn,
      genderEn: _selectedGenderEn,
      bloodGroup: _selectedBloodGroup,
      emergencyContact: _emergencyController.text.trim(),
      addressBn: _addressBnController.text.trim(),
      addressEn: _addressEnController.text.trim(),
      avatarId: _selectedAvatarId,
      customImagePath: _customImagePath,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.emeraldGreen,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              AppLocaleController.instance.isBangla
                  ? 'প্রোফাইল তথ্য সফলভাবে সংরক্ষিত ও আপডেট হয়েছে!'
                  : 'Profile saved & session stored successfully!',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isBn ? 'প্রোফাইল সম্পাদনা' : 'Edit Profile',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryNavy),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Interactive Avatar with Camera Button
            Center(
              child: InkWell(
                onTap: () => _showAvatarPickerModal(context, isBn),
                borderRadius: BorderRadius.circular(50),
                child: Stack(
                  children: [
                    ProfileAvatarWidget(
                      avatarId: _selectedAvatarId,
                      customImagePath: _customImagePath,
                      size: 92,
                      iconSize: 50,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.primaryNavy,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: () => _showAvatarPickerModal(context, isBn),
                icon: const Icon(Icons.palette, size: 16, color: AppColors.brandCyan),
                label: Text(
                  isBn ? 'ছবি বা অবতার পরিবর্তন করুন' : 'Change Avatar',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandCyan,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name BN
            _buildTextField(
              controller: _nameBnController,
              label: isBn ? 'নাম (বাংলায়)' : 'Full Name (Bangla)',
              hint: isBn ? 'উদা: মোঃ শাকাওয়াত হোসেন' : 'e.g., মোঃ শাকাওয়াত হোসেন',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 14),

            // Name EN
            _buildTextField(
              controller: _nameEnController,
              label: isBn ? 'নাম (ইংরেজিতে)' : 'Full Name (English)',
              hint: 'e.g., Md. Sakhawat Hossen',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 14),

            // Phone Number
            _buildTextField(
              controller: _phoneController,
              label: isBn ? 'মোবাইল নম্বর' : 'Phone Number',
              hint: '+880 1712-345678',
              icon: Icons.phone_android_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),

            // Email
            _buildTextField(
              controller: _emailController,
              label: isBn ? 'ইমেইল ঠিকানা' : 'Email Address',
              hint: 'name@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),

            // Age & Blood Group Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _ageController,
                    label: isBn ? 'বয়স' : 'Age',
                    hint: '28',
                    icon: Icons.calendar_today_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedBloodGroup,
                        isExpanded: true,
                        items: _bloodGroups.map((bg) {
                          return DropdownMenuItem<String>(
                            value: bg,
                            child: Row(
                              children: [
                                const Icon(Icons.bloodtype_rounded, color: AppColors.sosRed, size: 18),
                                const SizedBox(width: 6),
                                Text(bg, style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedBloodGroup = val);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Emergency Contact
            _buildTextField(
              controller: _emergencyController,
              label: isBn ? 'জরুরি যোগাযোগের নম্বর' : 'Emergency Contact',
              hint: '+880 1819-876543',
              icon: Icons.phone_in_talk_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),

            // Address
            _buildTextField(
              controller: isBn ? _addressBnController : _addressEnController,
              label: isBn ? 'বর্তমান ঠিকানা' : 'Residential Address',
              hint: isBn ? 'বাড়ি, রোড, এলাকা, ঢাকা' : 'House, Road, Area, City',
              icon: Icons.home_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _saveProfile,
                child: Text(
                  isBn ? 'তথ্য সংরক্ষণ করুন' : 'Save Changes',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primaryNavy, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        filled: true,
        fillColor: AppColors.backgroundLight,
      ),
    );
  }
}
