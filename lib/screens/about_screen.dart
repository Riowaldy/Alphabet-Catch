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
          _LogoBadge(scale: scale),
          const SizedBox(height: 12),
          Text(
            'Tentang Kami',
            style: GoogleFonts.baloo2(
              fontSize: 24 * scale,
              fontWeight: FontWeight.w800,
              color: AppColors.plum,
            ),
          ),
          const SizedBox(height: 10),
          _StudioBadge(scale: scale),
          const SizedBox(height: 16),
          _InfoRow(
            emoji: '🎮',
            title: 'Game Seru & Ringan',
            description:
                'Kami berkomitmen menghadirkan game yang seru, ringan, dan '
                'menyenangkan untuk dinikmati semua kalangan.',
            background: const Color(0xFFFFF6D8),
            titleColor: const Color(0xFF6B5E33),
            scale: scale,
          ),
          SizedBox(height: 10 * scale),
          _InfoRow(
            emoji: '🚀',
            title: 'Pembaruan Berkualitas',
            description:
                'Setiap pembaruan yang kami rilis bertujuan memberikan '
                'pengalaman bermain yang lebih baik.',
            background: const Color(0xFFE8E1FC),
            titleColor: AppColors.plumDark,
            scale: scale,
          ),
          SizedBox(height: 10 * scale),
          _InfoRow(
            emoji: '💖',
            title: 'Terima Kasih',
            description:
                'Terima kasih telah memainkan game dari Zegen. Dukungan '
                'Anda menjadi semangat kami untuk terus berkarya.',
            background: const Color(0xFFFFF0F0),
            titleColor: AppColors.coralDark,
            scale: scale,
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

/// Lencana bulat bergradasi khas maskot, dipakai sebagai ikon layar ini.
class _LogoBadge extends StatelessWidget {
  final double scale;

  const _LogoBadge({required this.scale});

  @override
  Widget build(BuildContext context) {
    final size = 66 * scale;
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
          BoxShadow(color: AppColors.coral.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      alignment: Alignment.center,
      child: Text('🧑‍💻', style: TextStyle(fontSize: 30 * scale)),
    );
  }
}

/// Chip nama studio + lokasi, senada dengan kartu sapaan di StartScreen.
class _StudioBadge extends StatelessWidget {
  final double scale;

  const _StudioBadge({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 8 * scale),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.coral.withOpacity(0.35), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Zegen',
            style: GoogleFonts.baloo2(
              fontSize: 15 * scale,
              fontWeight: FontWeight.w700,
              color: AppColors.coralDark,
            ),
          ),
          SizedBox(width: 6 * scale),
          Text(
            '• 📍 Sidoarjo, Indonesia',
            style: GoogleFonts.fredoka(
              fontSize: 13 * scale,
              fontWeight: FontWeight.w600,
              color: AppColors.subtitle,
            ),
          ),
        ],
      ),
    );
  }
}

/// Baris info dengan ikon emoji, judul, dan deskripsi di atas latar lembut.
class _InfoRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final Color background;
  final Color titleColor;
  final double scale;

  const _InfoRow({
    required this.emoji,
    required this.title,
    required this.description,
    required this.background,
    required this.titleColor,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 12 * scale),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: 22 * scale)),
          SizedBox(width: 10 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.baloo2(
                    fontSize: 14.5 * scale,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                SizedBox(height: 2 * scale),
                Text(
                  description,
                  style: GoogleFonts.fredoka(fontSize: 13 * scale, color: AppColors.ink),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
