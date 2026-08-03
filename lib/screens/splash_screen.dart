import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Splash screen interaktif: memantul-mantul untuk menarik perhatian anak,
/// bisa diketuk kapan saja untuk lanjut, atau otomatis lanjut setelah animasi selesai.
class SplashScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const SplashScreen({super.key, required this.onFinished});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bounce;
  late final Animation<double> _fade;
  Timer? _autoAdvanceTimer;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _bounce = Tween<double>(begin: 0.92, end: 1.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.4, curve: Curves.easeOut),
      ),
    );
    _autoAdvanceTimer = Timer(const Duration(milliseconds: 2600), _finish);
  }

  void _finish() {
    if (_done) return;
    _done = true;
    _autoAdvanceTimer?.cancel();
    widget.onFinished();
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _finish,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Opacity(
            opacity: _fade.value,
            child: Transform.scale(scale: _bounce.value, child: child),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 132 * scale,
                height: 132 * scale,
                decoration: const BoxDecoration(
                  color: AppColors.coral,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.coralDark, offset: Offset(0, 10)),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'Aa',
                  style: GoogleFonts.baloo2(
                    fontSize: 56 * scale,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 18 * scale),
              Text('🧺', style: TextStyle(fontSize: 40 * scale)),
              SizedBox(height: 10 * scale),
              Text(
                'Alphabet Catch!',
                style: GoogleFonts.baloo2(
                  fontSize: 28 * scale,
                  fontWeight: FontWeight.w800,
                  color: AppColors.plum,
                ),
              ),
              SizedBox(height: 8 * scale),
              Text(
                'Ketuk untuk mulai ✨',
                style: GoogleFonts.fredoka(
                  fontSize: 15 * scale,
                  fontWeight: FontWeight.w600,
                  color: AppColors.coralDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
