import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Pil ringkas untuk menampilkan skor tertinggi di bawah kartu skor utama.
class HighScorePill extends StatelessWidget {
  final int highScore;
  final double scale;

  const HighScorePill({super.key, required this.highScore, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 8 * scale),
      decoration: BoxDecoration(
        color: AppColors.plum.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '🏆 Skor tertinggi: $highScore',
        style: GoogleFonts.fredoka(
          fontSize: 14 * scale,
          fontWeight: FontWeight.w600,
          color: AppColors.plumDark,
        ),
      ),
    );
  }
}
