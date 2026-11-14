class TransactionReceipt {
  final String transactionId;
  final String appointmentId;
  final String doctorNameBn;
  final String doctorNameEn;
  final String paymentMethod; // 'bKash', 'Nagad', 'Card'
  final int doctorFee;
  final int platformFee;
  final int totalAmount;
  final String date;
  final String status; // 'Success', 'Pending', 'Failed'

  const TransactionReceipt({
    required this.transactionId,
    required this.appointmentId,
    required this.doctorNameBn,
    required this.doctorNameEn,
    required this.paymentMethod,
    required this.doctorFee,
    required this.platformFee,
    required this.totalAmount,
    required this.date,
    required this.status,
  });
}
