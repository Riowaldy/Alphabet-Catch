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

class GameOverScreen extends StatelessWidget {
  final int score;
  final int highScore;
  final VoidCallback onRetry;
  final VoidCallback onFinish;

  const GameOverScreen({
    super.key,
    required this.score,
    this.highScore = 0,
    required this.onRetry,
    required this.onFinish,
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
            StatusChip(label: 'KEHABISAN NYAWA', color: AppColors.coral, scale: scale),
            SizedBox(height: 14 * scale),
            TrophyBadge(
              scale: scale,
              emoji: '😅',
              gradientColors: const [AppColors.coral, AppColors.coralDark],
              glowColor: AppColors.coral,
            ),
            SizedBox(height: 10 * scale),
            Text(
              'Coba Lagi Yuk!',
              style: GoogleFonts.baloo2(
                fontSize: 26 * scale,
                fontWeight: FontWeight.w800,
                color: AppColors.plum,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Jangan menyerah, kamu pasti bisa lebih baik!',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(fontSize: 15 * scale, color: const Color(0xFF665E7A)),
            ),
            SizedBox(height: 16 * scale),
            ScoreStatTile(emoji: '⭐', label: 'SKOR KAMU', value: '$score', scale: scale),
            SizedBox(height: 10 * scale),
            HighScorePill(highScore: highScore, scale: scale),
            BigButton(label: 'Main Lagi', onTap: onRetry),
            BigButton(label: 'Selesai', onTap: onFinish, secondary: true),
          ],
        ),
      ),
    );
  }
}
