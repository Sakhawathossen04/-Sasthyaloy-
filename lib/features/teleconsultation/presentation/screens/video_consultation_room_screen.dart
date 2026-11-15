import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_locale_controller.dart';
import 'post_consultation_summary_screen.dart';

class VideoConsultationRoomScreen extends StatefulWidget {
  final String doctorNameBn;
  final String doctorNameEn;
  final String specialityBn;
  final String specialityEn;

  const VideoConsultationRoomScreen({
    super.key,
    required this.doctorNameBn,
    required this.doctorNameEn,
    required this.specialityBn,
    required this.specialityEn,
  });

  @override
  State<VideoConsultationRoomScreen> createState() => _VideoConsultationRoomScreenState();
}

class _VideoConsultationRoomScreenState extends State<VideoConsultationRoomScreen> {
  bool _isMicMuted = false;
  bool _isVideoOff = false;
  bool _isFrontCamera = true;
  int _callSeconds = 0;
  Timer? _callTimer;

  final List<String> _inCallMessages = [
    'ডা. তানভীর আহমেদ কলে যুক্ত হয়েছেন।',
    'রোগীর মেডিকেল হিস্ট্রি লোড হয়েছে।',
  ];

  @override
  void initState() {
    super.initState();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _callSeconds++);
    });
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    super.dispose();
  }

  String _formatCallDuration(int totalSeconds) {
    final mins = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void _endCall() {
    final durationStr = _formatCallDuration(_callSeconds);
    _callTimer?.cancel();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PostConsultationSummaryScreen(
          doctorNameBn: widget.doctorNameBn,
          doctorNameEn: widget.doctorNameEn,
          specialityBn: widget.specialityBn,
          specialityEn: widget.specialityEn,
          callDuration: durationStr,
        ),
      ),
    );
  }

  void _openInCallChat(bool isBn) {
    final textController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isBn ? 'ইন-কল চ্যাট ও নোটস' : 'In-Call Notes & Chat',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                    ),
                    IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.of(ctx).pop()),
                  ],
                ),
                const Divider(),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 180),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _inCallMessages.length,
                    itemBuilder: (context, idx) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text('• ${_inCallMessages[idx]}', style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: isBn ? 'বার্তা বা রিপোর্ট নোট লিখুন...' : 'Type note or message...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: AppColors.brandCyan),
                      onPressed: () {
                        if (textController.text.trim().isNotEmpty) {
                          setState(() {
                            _inCallMessages.add('রোগী: ${textController.text.trim()}');
                          });
                          setSheetState(() {});
                          textController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmEndCall(bool isBn) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isBn ? 'কল শেষ করবেন?' : 'End Consultation?'),
        content: Text(
          isBn
              ? 'আপনি কি নিশ্চিত যে ভিডিও কনসালটেশনটি শেষ করতে চান?'
              : 'Are you sure you want to end this teleconsultation?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(isBn ? 'না' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sosRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _endCall();
            },
            child: Text(isBn ? 'হ্যাঁ, কল কাটুন' : 'End Call'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBn = AppLocaleController.instance.isBangla;
    final duration = _formatCallDuration(_callSeconds);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          _confirmEndCall(isBn);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Doctor Main Video Feed (Simulated WebRTC)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0F172A),
                    const Color(0xFF1E293B),
                    Colors.blueGrey.shade900,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Doctor Camera Avatar
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.brandCyan, width: 3),
                            color: AppColors.primaryNavy,
                          ),
                          child: const Icon(Icons.person, size: 80, color: Colors.white),
                        ),
                        Positioned(
                          bottom: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.emeraldGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.videocam_rounded, size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      isBn ? widget.doctorNameBn : widget.doctorNameEn,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isBn ? widget.specialityBn : widget.specialityEn,
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.lock, size: 12, color: AppColors.emeraldGreen),
                          SizedBox(width: 4),
                          Text(
                            'WebRTC End-to-End Encrypted HD',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Picture-in-Picture (PiP) Self Preview Window
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                width: 110,
                height: 150,
                decoration: BoxDecoration(
                  color: _isVideoOff ? Colors.grey.shade900 : const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white38, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!_isVideoOff)
                      const Icon(Icons.person, color: Colors.white70, size: 48)
                    else
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.videocam_off_rounded, color: Colors.white54, size: 28),
                          SizedBox(height: 4),
                          Text('Video Off', style: TextStyle(color: Colors.white54, fontSize: 10)),
                        ],
                      ),
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isBn ? 'আপনি (You)' : 'You',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    if (_isMicMuted)
                      const Positioned(
                        top: 6,
                        right: 6,
                        child: Icon(Icons.mic_off, color: Colors.red, size: 14),
                      ),
                  ],
                ),
              ),
            ),

            // 3. Top Call Duration Pill
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      duration,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 4. Floating Call Controls HUD
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Mute/Unmute
                    _buildControlButton(
                      icon: _isMicMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                      isActive: _isMicMuted,
                      activeColor: Colors.red,
                      onTap: () => setState(() => _isMicMuted = !_isMicMuted),
                    ),
                    // Video On/Off
                    _buildControlButton(
                      icon: _isVideoOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                      isActive: _isVideoOff,
                      activeColor: Colors.red,
                      onTap: () => setState(() => _isVideoOff = !_isVideoOff),
                    ),
                    // Camera Switch
                    _buildControlButton(
                      icon: Icons.switch_camera_rounded,
                      isActive: false,
                      onTap: () {
                        setState(() => _isFrontCamera = !_isFrontCamera);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.primaryNavy,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(milliseconds: 800),
                            content: Text(
                              _isFrontCamera ? 'Front Camera Active' : 'Back Camera Active',
                            ),
                          ),
                        );
                      },
                    ),
                    // In-Call Chat
                    _buildControlButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      isActive: false,
                      onTap: () => _openInCallChat(isBn),
                    ),
                    // End Call
                    _buildControlButton(
                      icon: Icons.call_end_rounded,
                      isActive: true,
                      activeColor: AppColors.sosRed,
                      size: 54,
                      onTap: _endCall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    Color activeColor = Colors.white,
    double size = 44,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.white.withOpacity(0.18),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : Colors.white,
          size: size * 0.5,
        ),
      ),
    );
  }
}
