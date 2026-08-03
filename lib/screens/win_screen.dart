import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/big_button.dart';
import '../widgets/game_panel.dart';

class WinScreen extends StatelessWidget {
  final int score;
  final VoidCallback onNextRound;
  final VoidCallback onFinish;

  const WinScreen({
    super.key,
    required this.score,
    required this.onNextRound,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return GamePanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🎉', style: TextStyle(fontSize: 40 * scale)),
          const SizedBox(height: 6),
          Text(
            'Hebat!',
            style: GoogleFonts.baloo2(
              fontSize: 26 * scale,
              fontWeight: FontWeight.w800,
              color: AppColors.plum,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.fredoka(fontSize: 15 * scale, color: const Color(0xFF665E7A)),
              children: [
                const TextSpan(text: 'Kamu menyelesaikan ronde ini dengan skor '),
                TextSpan(text: '$score', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                const TextSpan(text: '!'),
              ],
            ),
          ),
          BigButton(label: 'Lanjut, Lebih Sulit! 🔥', onTap: onNextRound),
          BigButton(label: 'Selesai, Ganti Tema', onTap: onFinish, secondary: true),
        ],
      ),
    );
  }
}
