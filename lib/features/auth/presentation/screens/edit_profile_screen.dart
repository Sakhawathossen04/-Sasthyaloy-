import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../domain/controllers/auth_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameBnController;
  late TextEditingController _nameEnController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _emergencyController;
  late TextEditingController _addressBnController;
  late TextEditingController _addressEnController;
  late String _selectedBloodGroup;
  late String _selectedGenderBn;
  late String _selectedGenderEn;

  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  void initState() {
    super.initState();
    final user = AuthController.instance.currentUser;
    _nameBnController = TextEditingController(text: user.nameBn);
    _nameEnController = TextEditingController(text: user.nameEn);
    _emailController = TextEditingController(text: user.email);
    _ageController = TextEditingController(text: user.age > 0 ? user.age.toString() : '28');
    _emergencyController = TextEditingController(text: user.emergencyContact);
    _addressBnController = TextEditingController(text: user.addressBn);
    _addressEnController = TextEditingController(text: user.addressEn);
    _selectedBloodGroup = _bloodGroups.contains(user.bloodGroup) ? user.bloodGroup : 'B+';
    _selectedGenderBn = user.genderBn;
    _selectedGenderEn = user.genderEn;
  }

  @override
  void dispose() {
    _nameBnController.dispose();
    _nameEnController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _emergencyController.dispose();
    _addressBnController.dispose();
    _addressEnController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final age = int.tryParse(_ageController.text) ?? 28;
    AuthController.instance.updateProfile(
      nameBn: _nameBnController.text.trim(),
      nameEn: _nameEnController.text.trim(),
      email: _emailController.text.trim(),
      age: age,
      genderBn: _selectedGenderBn,
      genderEn: _selectedGenderEn,
      bloodGroup: _selectedBloodGroup,
      emergencyContact: _emergencyController.text.trim(),
      addressBn: _addressBnController.text.trim(),
      addressEn: _addressEnController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.emeraldGreen,
        behavior: SnackBarBehavior.floating,
        content: Text(
          AppLocaleController.instance.isBangla
              ? 'প্রোফাইল তথ্য সফলভাবে আপডেট করা হয়েছে!'
              : 'Profile updated successfully!',
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
            // Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: AppColors.brandCyan.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.brandCyan, width: 2),
                    ),
                    child: const Icon(Icons.person, size: 54, color: AppColors.primaryNavy),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryNavy,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Name BN
            _buildTextField(
              controller: _nameBnController,
              label: isBn ? 'নাম (বাংলায়)' : 'Full Name (Bangla)',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 14),

            // Name EN
            _buildTextField(
              controller: _nameEnController,
              label: isBn ? 'নাম (ইংরেজিতে)' : 'Full Name (English)',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 14),

            // Email
            _buildTextField(
              controller: _emailController,
              label: isBn ? 'ইমেইল ঠিকানা' : 'Email Address',
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
              icon: Icons.emergency_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),

            // Address
            _buildTextField(
              controller: isBn ? _addressBnController : _addressEnController,
              label: isBn ? 'ঠিকানা' : 'Residential Address',
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
