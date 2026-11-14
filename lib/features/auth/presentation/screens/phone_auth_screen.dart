import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import 'otp_verification_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '1712345678');
  bool _isLoading = false;

  String _getCarrierName(String phone) {
    if (phone.length < 3) return '';
    final prefix = phone.substring(0, 3);
    switch (prefix) {
      case '17':
      case '13':
        return 'Grameenphone (জিপি)';
      case '18':
        return 'Robi (রবি)';
      case '19':
      case '14':
        return 'Banglalink (বাংলালিংক)';
      case '16':
        return 'Airtel (এয়ারটেল)';
      case '15':
        return 'Teletalk (টেলিটক)';
      default:
        return 'Mobile Operator';
    }
  }

  void _sendOtp(bool isBn) {
    final text = _phoneController.text.trim();
    if (text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.sosRed,
          behavior: SnackBarBehavior.floating,
          content: Text(
            isBn
                ? 'অনুগ্রহ করে সঠিক ১০ সংখ্যার মোবাইল নম্বর দিন (যেমন: 17XXXXXXXX)'
                : 'Please enter a valid 10-digit mobile number',
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      final fullPhone = '+880 $text';
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(phoneNumber: fullPhone),
        ),
      );
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;
    final carrier = _getCarrierName(_phoneController.text);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryNavy),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryNavy.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.phone_android_rounded,
                  color: AppColors.primaryNavy,
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                isBn ? 'আপনার মোবাইল নম্বর দিন' : 'Enter your mobile number',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isBn
                    ? 'আমরা আপনার নম্বরে একটি ৬-ডিজিটের ওটিপি ভেরিফিকেশন কোড পাঠাবো।'
                    : 'We will send a 6-digit verification code to confirm your account.',
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 32),

              // Phone Input Field with BD Flag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    // BD Flag and Country Code
                    Row(
                      children: const [
                        Text('🇧🇩', style: TextStyle(fontSize: 22)),
                        SizedBox(width: 8),
                        Text(
                          '+880',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                    Container(width: 1, height: 26, color: AppColors.borderLight),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: AppColors.textPrimary,
                        ),
                        decoration: const InputDecoration(
                          hintText: '1XXXXXXXXX',
                          counterText: '',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),

              if (carrier.isNotEmpty) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.signal_cellular_alt_rounded, size: 14, color: AppColors.emeraldGreen),
                      const SizedBox(width: 6),
                      Text(
                        carrier,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 36),

              // Send OTP Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNavy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isLoading ? null : () => _sendOtp(isBn),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                      : Text(
                          isBn ? 'ওটিপি কোড পাঠান (Send OTP)' : 'Send OTP',
                          style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Privacy & Security Notice
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.security_rounded, color: AppColors.emeraldGreen, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isBn
                            ? 'আপনার ব্যক্তিগত স্বাস্থ্য তথ্য সম্পূর্ণ এনক্রিপ্ট করা ও সুরক্ষিত।'
                            : 'Your healthcare records are strictly confidential and encrypted.',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
