import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/big_button.dart';
import '../widgets/fireworks_overlay.dart';
import '../widgets/game_panel.dart';
import '../widgets/score_stat_tile.dart';
import '../widgets/status_chip.dart';
import '../widgets/trophy_badge.dart';

class WinScreen extends StatelessWidget {
  final int score;
  final int targetCount;
  final VoidCallback onNextRound;
  final VoidCallback onFinish;

  const WinScreen({
    super.key,
    required this.score,
    this.targetCount = 5,
    required this.onNextRound,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return Stack(
      children: [
        const Positioned.fill(child: FireworksOverlay()),
        GamePanel(
          scrim: false,
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
                StatusChip(label: 'RONDE SELESAI', color: AppColors.success, scale: scale),
                SizedBox(height: 14 * scale),
                TrophyBadge(scale: scale),
                SizedBox(height: 10 * scale),
                Text(
                  'Hebat!',
                  style: GoogleFonts.baloo2(
                    fontSize: 28 * scale,
                    fontWeight: FontWeight.w800,
                    color: AppColors.plum,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kamu menangkap semua $targetCount huruf yang tepat!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(fontSize: 15 * scale, color: const Color(0xFF665E7A)),
                ),
                SizedBox(height: 14 * scale),
                _StarsRow(count: targetCount, scale: scale),
                SizedBox(height: 16 * scale),
                ScoreStatTile(emoji: '⭐', label: 'SKOR KAMU', value: '$score', scale: scale),
                BigButton(label: 'Lanjut, Lebih Sulit! 🔥', onTap: onNextRound),
                BigButton(label: 'Selesai, Ganti Tema', onTap: onFinish, secondary: true),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Baris bintang emas — satu bintang per item yang berhasil ditangkap.
class _StarsRow extends StatelessWidget {
  final int count;
  final double scale;
  const _StarsRow({required this.count, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2 * scale),
            child: Icon(
              Icons.star_rounded,
              size: 26 * scale,
              color: AppColors.sun,
              shadows: [Shadow(color: AppColors.coralDark.withOpacity(0.35), blurRadius: 4)],
            ),
          ),
      ],
    );
  }
}
