import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Medali melingkar dengan gradasi dan cahaya lembut di belakangnya,
/// jadi fokus visual utama di layar ronde menang / permainan selesai.
class TrophyBadge extends StatelessWidget {
  final double scale;
  final String emoji;
  final List<Color> gradientColors;
  final Color glowColor;

  const TrophyBadge({
    super.key,
    required this.scale,
    this.emoji = '🏆',
    this.gradientColors = const [AppColors.sun, AppColors.coral],
    this.glowColor = AppColors.sun,
  });

  @override
  Widget build(BuildContext context) {
    final size = 84 * scale;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(color: glowColor.withOpacity(0.55), blurRadius: 24, spreadRadius: 2),
          const BoxShadow(color: AppColors.coralDark, offset: Offset(0, 8)),
        ],
        border: Border.all(color: Colors.white, width: 4),
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: TextStyle(fontSize: 40 * scale)),
    );
  }
}
