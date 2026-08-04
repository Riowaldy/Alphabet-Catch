import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Kartu untuk menonjolkan satu angka statistik (skor, dsb), dengan opsi
/// highlight emas saat jadi pencapaian utama (mis. rekor baru).
class ScoreStatTile extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final double scale;
  final bool highlight;

  const ScoreStatTile({
    super.key,
    required this.emoji,
    required this.label,
    required this.value,
    this.scale = 1,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = highlight ? AppColors.sun : AppColors.subtitle;
    final borderColor = highlight ? AppColors.sun : AppColors.plum;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12 * scale, horizontal: 16 * scale),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: highlight
              ? const [Colors.white, Color(0xFFFFF6E5)]
              : const [Colors.white, Color(0xFFF6F3FC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor.withOpacity(0.4), width: 2),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), offset: Offset(0, 6))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: TextStyle(fontSize: 24 * scale)),
          SizedBox(width: 10 * scale),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.baloo2(
                  fontSize: 11 * scale,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                  letterSpacing: 1,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.baloo2(
                  fontSize: 26 * scale,
                  fontWeight: FontWeight.w800,
                  color: AppColors.plum,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
