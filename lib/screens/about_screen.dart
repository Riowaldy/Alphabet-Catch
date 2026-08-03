import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/big_button.dart';
import '../widgets/game_route_scaffold.dart';

/// Info singkat tentang pembuat game ini.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return GameRouteScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🧑‍💻', style: TextStyle(fontSize: 40 * scale)),
          const SizedBox(height: 6),
          Text(
            'Tentang Kami',
            style: GoogleFonts.baloo2(
              fontSize: 24 * scale,
              fontWeight: FontWeight.w800,
              color: AppColors.plum,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Zegen',
            style: GoogleFonts.baloo2(
              fontSize: 18 * scale,
              fontWeight: FontWeight.w700,
              color: AppColors.coralDark,
            ),
          ),
          Text(
            '📍 Situbondo, Indonesia',
            style: GoogleFonts.fredoka(
              fontSize: 14 * scale,
              fontWeight: FontWeight.w600,
              color: AppColors.subtitle,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Halo! Saya Zegen, seorang pengembang game indie yang tinggal di '
            'Situbondo, Indonesia. Alphabet Catch dibuat dengan penuh cinta untuk '
            'menemani anak-anak belajar huruf dan kosakata baru sambil bermain. '
            'Semoga game sederhana ini bisa membawa keceriaan dan manfaat bagi '
            'si kecil di rumah. Terima kasih sudah bermain! 🎉',
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(fontSize: 15 * scale, color: AppColors.ink),
          ),
          BigButton(
            label: 'Kembali',
            onTap: () => Navigator.pop(context),
            secondary: true,
          ),
        ],
      ),
    );
  }
}
