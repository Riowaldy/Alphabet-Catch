import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/big_button.dart';
import '../widgets/game_panel.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final VoidCallback onRetry;

  const GameOverScreen({super.key, required this.score, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return GamePanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('😅', style: TextStyle(fontSize: 40 * scale)),
          const SizedBox(height: 6),
          Text(
            'Coba Lagi Yuk!',
            style: GoogleFonts.baloo2(
              fontSize: 26 * scale,
              fontWeight: FontWeight.w800,
              color: AppColors.plum,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: GoogleFonts.fredoka(fontSize: 15 * scale, color: const Color(0xFF665E7A)),
              children: [
                const TextSpan(text: 'Skor kamu: '),
                TextSpan(text: '$score', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
              ],
            ),
          ),
          BigButton(label: 'Main Lagi', onTap: onRetry),
        ],
      ),
    );
  }
}
