import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_item.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/big_button.dart';
import '../widgets/game_panel.dart';

class RoundIntroScreen extends StatelessWidget {
  final GameCategory category;
  final String targetLetter;
  final int targetCount;
  final VoidCallback onStart;

  const RoundIntroScreen({
    super.key,
    required this.category,
    required this.targetLetter,
    required this.targetCount,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return GamePanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(category.icon, style: TextStyle(fontSize: 40 * scale)),
          const SizedBox(height: 6),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.baloo2(
                fontSize: 24 * scale,
                fontWeight: FontWeight.w800,
                color: AppColors.plum,
              ),
              children: [
                const TextSpan(text: 'Ronde: '),
                TextSpan(text: category.name, style: const TextStyle(color: AppColors.coral)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.fredoka(fontSize: 15 * scale, color: const Color(0xFF665E7A)),
              children: [
                const TextSpan(text: 'Tangkap semua benda yang diawali huruf '),
                TextSpan(
                  text: targetLetter,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink),
                ),
                TextSpan(text: ' sebanyak $targetCount kali. Hati-hati salah tangkap, nyawa berkurang!'),
              ],
            ),
          ),
          BigButton(label: 'Ayo!', onTap: onStart),
        ],
      ),
    );
  }
}
