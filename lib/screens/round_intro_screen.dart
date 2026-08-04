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
          _LogoBadge(icon: category.icon, scale: scale),
          const SizedBox(height: 8),
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
          SizedBox(height: 18 * scale),
          Text(
            'Tangkap huruf ini',
            style: GoogleFonts.fredoka(
              fontSize: 13 * scale,
              fontWeight: FontWeight.w600,
              color: AppColors.subtitle,
            ),
          ),
          SizedBox(height: 8 * scale),
          _TargetLetterBadge(letter: targetLetter, scale: scale),
          SizedBox(height: 10 * scale),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 6 * scale),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E1FC),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '🎯 Tangkap $targetCount kali',
              style: GoogleFonts.fredoka(
                fontSize: 13 * scale,
                fontWeight: FontWeight.w700,
                color: AppColors.plumDark,
              ),
            ),
          ),
          SizedBox(height: 16 * scale),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 10 * scale),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F0),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('❤️', style: TextStyle(fontSize: 18 * scale)),
                SizedBox(width: 8 * scale),
                Flexible(
                  child: Text(
                    'Hati-hati salah tangkap, nyawa berkurang!',
                    style: GoogleFonts.fredoka(fontSize: 12.5 * scale, color: AppColors.coralDark),
                  ),
                ),
              ],
            ),
          ),
          BigButton(label: 'Ayo!', onTap: onStart),
        ],
      ),
    );
  }
}

/// Lencana bulat bergradasi khas maskot, dipakai sebagai ikon layar ini.
class _LogoBadge extends StatelessWidget {
  final String icon;
  final double scale;

  const _LogoBadge({required this.icon, required this.scale});

  @override
  Widget build(BuildContext context) {
    final size = 58 * scale;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.sun, AppColors.coral],
        ),
        boxShadow: [
          BoxShadow(color: AppColors.coral.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 5)),
        ],
      ),
      alignment: Alignment.center,
      child: Text(icon, style: TextStyle(fontSize: 26 * scale)),
    );
  }
}

/// Lencana besar bergradasi coral→ungu yang menampilkan huruf target ronde.
class _TargetLetterBadge extends StatelessWidget {
  final String letter;
  final double scale;

  const _TargetLetterBadge({required this.letter, required this.scale});

  @override
  Widget build(BuildContext context) {
    final size = 84 * scale;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(colors: [AppColors.coral, AppColors.plum]),
        boxShadow: [
          BoxShadow(color: AppColors.plumDark.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6)),
        ],
        border: Border.all(color: Colors.white, width: 4),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: GoogleFonts.baloo2(
          fontSize: 36 * scale,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}
