import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/big_button.dart';
import '../widgets/game_panel.dart';
import '../widgets/high_score_pill.dart';
import '../widgets/score_stat_tile.dart';
import '../widgets/status_chip.dart';
import '../widgets/trophy_badge.dart';

class FinishedScreen extends StatelessWidget {
  final String playerName;
  final int score;
  final int highScore;
  final bool isNewHighScore;
  final VoidCallback onChooseAgain;
  final VoidCallback onBackToStart;

  const FinishedScreen({
    super.key,
    required this.playerName,
    required this.score,
    this.highScore = 0,
    this.isNewHighScore = false,
    required this.onChooseAgain,
    required this.onBackToStart,
  });

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return GamePanel(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.7, end: 1),
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeOutBack,
        builder: (context, value, child) => Transform.scale(
          scale: value,
          child: Opacity(opacity: value.clamp(0, 1), child: child),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusChip(
              label: isNewHighScore ? 'REKOR BARU!' : 'PERMAINAN SELESAI',
              color: isNewHighScore ? AppColors.sun : AppColors.plum,
              scale: scale,
            ),
            SizedBox(height: 14 * scale),
            TrophyBadge(
              scale: scale,
              emoji: isNewHighScore ? '🏆' : '🏁',
              gradientColors: isNewHighScore
                  ? const [AppColors.sun, AppColors.coral]
                  : const [AppColors.plum, AppColors.plumDark],
              glowColor: isNewHighScore ? AppColors.sun : AppColors.plum,
            ),
            SizedBox(height: 10 * scale),
            Text(
              isNewHighScore ? 'Rekor Baru!' : 'Permainan Selesai!',
              style: GoogleFonts.baloo2(
                fontSize: 26 * scale,
                fontWeight: FontWeight.w800,
                color: AppColors.plum,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              playerName.isNotEmpty
                  ? 'Sampai jumpa lagi, $playerName!'
                  : 'Sampai jumpa lagi!',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(fontSize: 15 * scale, color: const Color(0xFF665E7A)),
            ),
            SizedBox(height: 16 * scale),
            ScoreStatTile(
              emoji: '⭐',
              label: 'SKOR AKHIR',
              value: '$score',
              scale: scale,
              highlight: isNewHighScore,
            ),
            SizedBox(height: 10 * scale),
            HighScorePill(highScore: highScore, scale: scale),
            BigButton(label: 'Selesai', onTap: onBackToStart),
            BigButton(label: 'Main Tema Lain', onTap: onChooseAgain, secondary: true),
          ],
        ),
      ),
    );
  }
}
