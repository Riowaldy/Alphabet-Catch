import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/big_button.dart';
import '../widgets/game_panel.dart';

class FinishedScreen extends StatelessWidget {
  final String playerName;
  final int score;
  final int highScore;
  final bool isNewHighScore;
  final VoidCallback onChooseAgain;

  const FinishedScreen({
    super.key,
    required this.playerName,
    required this.score,
    this.highScore = 0,
    this.isNewHighScore = false,
    required this.onChooseAgain,
  });

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return GamePanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🏆', style: TextStyle(fontSize: 40 * scale)),
          const SizedBox(height: 6),
          Text(
            'Permainan Selesai!',
            style: GoogleFonts.baloo2(
              fontSize: 24 * scale,
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
                TextSpan(
                  text: playerName.isNotEmpty
                      ? 'Skor akhir $playerName: '
                      : 'Skor akhir kamu: ',
                ),
                TextSpan(text: '$score', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                const TextSpan(text: '. Mau coba tema lain?'),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '🏆 Skor tertinggi: $highScore',
            style: GoogleFonts.fredoka(fontSize: 14 * scale, fontWeight: FontWeight.w600, color: AppColors.coralDark),
          ),
          if (isNewHighScore) ...[
            const SizedBox(height: 4),
            Text(
              'Rekor baru! 🎉',
              style: GoogleFonts.baloo2(fontSize: 16 * scale, fontWeight: FontWeight.w800, color: AppColors.success),
            ),
          ],
          BigButton(label: 'Pilih Tema Lain', onTap: onChooseAgain),
        ],
      ),
    );
  }
}
