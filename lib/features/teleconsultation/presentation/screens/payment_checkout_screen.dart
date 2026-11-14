import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../domain/models/payment_model.dart';
import 'video_consultation_room_screen.dart';

class PaymentCheckoutScreen extends StatefulWidget {
  final String appointmentId;
  final String doctorNameBn;
  final String doctorNameEn;
  final String specialityBn;
  final String specialityEn;
  final int fee;
  final bool isVideo;

  const PaymentCheckoutScreen({
    super.key,
    required this.appointmentId,
    required this.doctorNameBn,
    required this.doctorNameEn,
    required this.specialityBn,
    required this.specialityEn,
    required this.fee,
    required this.isVideo,
  });

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  String _selectedMethod = 'bkash'; // 'bkash', 'nagad', 'card'
  bool _isProcessing = false;

  void _processPayment(bool isBn) {
    if (_selectedMethod == 'bkash') {
      _showBkashModal(isBn);
    } else if (_selectedMethod == 'nagad') {
      _showNagadModal(isBn);
    } else {
      _showCardModal(isBn);
    }
  }

  void _onPaymentSuccess(String method) {
    final randomTrx = 'TRX-${method.toUpperCase()}${100000 + Random().nextInt(900000)}';
    final receipt = TransactionReceipt(
      transactionId: randomTrx,
      appointmentId: widget.appointmentId,
      doctorNameBn: widget.doctorNameBn,
      doctorNameEn: widget.doctorNameEn,
      paymentMethod: method,
      doctorFee: widget.fee,
      platformFee: 50,
      totalAmount: widget.fee + 50,
      date: 'Today, Just now',
      status: 'Success',
    );

    _showReceiptDialog(receipt);
  }

  void _showBkashModal(bool isBn) {
    final pinController = TextEditingController(text: '1234');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFD12053),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'bKash Payment Gateway',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '৳ ${widget.fee + 50}',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(color: Colors.white30, height: 20),
            Text(
              isBn ? 'আপনার বিকাশ পিন কোড দিয়ে পেমেন্ট নিশ্চিত করুন' : 'Enter your bKash PIN to confirm payment',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 4),
                decoration: const InputDecoration(
                  hintText: '••••',
                  counterText: '',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFD12053),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _onPaymentSuccess('bKash');
                },
                child: Text(
                  isBn ? 'নিশ্চিত করুন (Confirm ৳ ${widget.fee + 50})' : 'Confirm ৳ ${widget.fee + 50}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNagadModal(bool isBn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFEA580C),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nagad Payment Gateway',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '৳ ${widget.fee + 50}',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(color: Colors.white30, height: 20),
            Text(
              isBn ? 'নগদ ৪-ডিজিট পিন নম্বর দিন' : 'Enter 4-digit Nagad PIN',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: const TextField(
                obscureText: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 4),
                decoration: InputDecoration(
                  hintText: '1234',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFEA580C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _onPaymentSuccess('Nagad');
                },
                child: Text(
                  isBn ? 'পেমেন্ট সম্পন্ন করুন' : 'Complete Payment',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCardModal(bool isBn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Credit / Debit Card Payment',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: '4242 •••• •••• 4242',
                prefixIcon: const Icon(Icons.credit_card_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Expiry (MM/YY)',
                      hintText: '12/28',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: '•••',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _onPaymentSuccess('Visa/MasterCard');
                },
                child: Text(
                  isBn ? 'পে করুন ৳ ${widget.fee + 50}' : 'Pay ৳ ${widget.fee + 50}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReceiptDialog(TransactionReceipt receipt) {
    final isBn = AppLocaleController.instance.isBangla;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.emeraldGreen, size: 42),
            ),
            const SizedBox(height: 12),
            Text(
              isBn ? 'পেমেন্ট সফল হয়েছে!' : 'Payment Successful!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReceiptRow('Trx ID:', receipt.transactionId, isHighlight: true),
            const SizedBox(height: 6),
            _buildReceiptRow(isBn ? 'চিকিৎসক:' : 'Doctor:', isBn ? widget.doctorNameBn : widget.doctorNameEn),
            const SizedBox(height: 6),
            _buildReceiptRow(isBn ? 'পদ্ধতি:' : 'Method:', receipt.paymentMethod),
            const SizedBox(height: 6),
            _buildReceiptRow(isBn ? 'মোট পরিশোধিত:' : 'Total Paid:', '৳ ${receipt.totalAmount}'),
            const Divider(height: 18),
            Text(
              isBn
                  ? 'আপনার টেলি-কনসালটেশন বুকিং সক্রিয় হয়েছে। নির্ধারিত সময়ে ভিডিও কল রুমে প্রবেশ করতে পারবেন।'
                  : 'Your teleconsultation session is activated. You can enter the HD video room now.',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          if (widget.isVideo)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandCyan,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.of(ctx).pop(); // Close dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => VideoConsultationRoomScreen(
                      doctorNameBn: widget.doctorNameBn,
                      doctorNameEn: widget.doctorNameEn,
                      specialityBn: widget.specialityBn,
                      specialityEn: widget.specialityEn,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.videocam_rounded, size: 18),
              label: Text(isBn ? 'ভিডিও রুমে প্রবেশ' : 'Join Video Room'),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text(isBn ? 'সম্পন্ন' : 'Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: isHighlight ? AppColors.brandCyan : AppColors.primaryNavy,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;
    final total = widget.fee + 50;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          isBn ? 'পেমেন্ট চেকআউট' : 'Payment Checkout',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Bill Breakdown Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBn ? 'পেমেন্ট সারসংক্ষেপ (Bill Summary)' : 'Bill Summary',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isBn ? 'ডাক্তারের কনসালটেন্সি ফি' : 'Doctor Consultation Fee',
                        style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
                      ),
                      Text('৳ ${widget.fee}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isBn ? 'প্ল্যাটফর্ম সার্ভিস চার্জ' : 'Platform Service Fee',
                        style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
                      ),
                      const Text('৳ ৫০', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isBn ? 'সরকারি ভ্যাট / কর' : 'Govt. VAT & Tax',
                        style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
                      ),
                      const Text('৳ ০ (Exempted)', style: TextStyle(fontSize: 13, color: AppColors.emeraldGreen)),
                    ],
                  ),
                  const Divider(height: 20, color: AppColors.borderLight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isBn ? 'সর্বমোট প্রদেয়:' : 'Total Amount:',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                      ),
                      Text(
                        '৳ $total',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. Payment Method Selector
            Text(
              isBn ? 'পেমেন্ট মাধ্যম নির্বাচন করুন' : 'Select Payment Method',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
            ),
            const SizedBox(height: 12),

            _buildPaymentOption(
              id: 'bkash',
              title: isBn ? 'বিকাশ (bKash)' : 'bKash Wallet',
              subtitle: isBn ? 'তাৎক্ষণিক পিন ভেরিফিকেশন' : 'Instant PIN payment',
              color: const Color(0xFFD12053),
              logoText: 'bKash',
            ),
            const SizedBox(height: 10),

            _buildPaymentOption(
              id: 'nagad',
              title: isBn ? 'নগদ (Nagad)' : 'Nagad Wallet',
              subtitle: isBn ? 'বাংলাদেশ ডাক বিভাগের ডিজিটাল লেনদেন' : 'Postal digital wallet',
              color: const Color(0xFFEA580C),
              logoText: 'নগদ',
            ),
            const SizedBox(height: 10),

            _buildPaymentOption(
              id: 'card',
              title: isBn ? 'ভিসা / মাস্টারকার্ড' : 'Credit / Debit Card',
              subtitle: 'Visa, MasterCard, Amex',
              color: const Color(0xFF1E3A8A),
              logoText: 'CARD',
            ),

            const SizedBox(height: 36),

            // Pay Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => _processPayment(isBn),
                child: Text(
                  isBn ? 'পেমেন্ট করুন (Pay ৳ $total)' : 'Pay Now ৳ $total',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required Color color,
    required String logoText,
  }) {
    final isSelected = _selectedMethod == id;

    return InkWell(
      onTap: () => setState(() => _selectedMethod = id),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : AppColors.borderLight,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                logoText,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                  ),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : Colors.transparent,
                border: Border.all(color: isSelected ? color : AppColors.borderLight, width: 2),
              ),
              child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
