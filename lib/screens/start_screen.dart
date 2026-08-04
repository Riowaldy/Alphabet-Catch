import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/big_button.dart';
import '../widgets/game_panel.dart';

class StartScreen extends StatelessWidget {
  final String playerName;
  final int playerAge;
  final String playerCountry;
  final int highScore;
  final VoidCallback onStart;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenAbout;

  const StartScreen({
    super.key,
    required this.playerName,
    required this.playerAge,
    required this.playerCountry,
    required this.highScore,
    required this.onStart,
    required this.onOpenProfile,
    required this.onOpenAbout,
  });

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return GamePanel(
      scrim: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconButton(icon: Icons.info_outline_rounded, onTap: onOpenAbout, scale: scale),
              _iconButton(icon: Icons.person_rounded, onTap: onOpenProfile, scale: scale),
            ],
          ),
          _MascotBadge(scale: scale),
          const SizedBox(height: 10),
          Text(
            'Alphabet Catch!',
            style: GoogleFonts.baloo2(
              fontSize: 30 * scale,
              fontWeight: FontWeight.w800,
              color: AppColors.plum,
            ),
          ),
          if (playerName.isNotEmpty) ...[
            const SizedBox(height: 8),
            _GreetingChip(text: 'Halo, $playerName ($playerAge tahun)! 👋', scale: scale),
            const SizedBox(height: 8),
            _StatsRow(country: playerCountry, highScore: highScore, scale: scale),
          ],
          const SizedBox(height: 10),
          Text(
            'Tangkap gambar yang namanya diawali huruf yang aktif. '
            'Geser jari atau mouse untuk menggerakkan keranjang!',
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(fontSize: 15 * scale, color: const Color(0xFF665E7A)),
          ),
          const SizedBox(height: 10),
          BigButton(label: 'Mulai Main', onTap: onStart),
        ],
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onTap,
    required double scale,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38 * scale,
          height: 38 * scale,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFEFE9FB), width: 2.5),
            boxShadow: const [BoxShadow(color: Color(0x26000000), offset: Offset(0, 4))],
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 20 * scale, color: AppColors.plum),
        ),
      );
}

/// Lencana maskot berisi ikon buah & huruf, pengganti baris emoji polos.
class _MascotBadge extends StatelessWidget {
  final double scale;

  const _MascotBadge({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 10 * scale),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFE3CE), Color(0xFFFFF3CE)]),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _chip('🍎'),
          SizedBox(width: 8 * scale),
          _chip('🔤'),
          SizedBox(width: 8 * scale),
          _chip('🍇'),
        ],
      ),
    );
  }

  Widget _chip(String emoji) => Container(
        width: 44 * scale,
        height: 44 * scale,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Color(0x1F000000), offset: Offset(0, 3))],
        ),
        alignment: Alignment.center,
        child: Text(emoji, style: TextStyle(fontSize: 22 * scale)),
      );
}

/// Sapaan nama pemain, ditampilkan sebagai chip warna alih-alih teks polos.
class _GreetingChip extends StatelessWidget {
  final String text;
  final double scale;

  const _GreetingChip({required this.text, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 6 * scale),
      decoration: BoxDecoration(
        color: AppColors.coral.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: GoogleFonts.fredoka(
          fontSize: 15 * scale,
          fontWeight: FontWeight.w700,
          color: AppColors.coralDark,
        ),
      ),
    );
  }
}

/// Negara & skor tertinggi pemain, dulunya halaman "Dashboard" terpisah,
/// sekarang cukup sepasang chip langsung di layar utama.
class _StatsRow extends StatelessWidget {
  final String country;
  final int highScore;
  final double scale;

  const _StatsRow({required this.country, required this.highScore, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _statChip('🌏', country),
        SizedBox(width: 8 * scale),
        _statChip('🏆', '$highScore'),
      ],
    );
  }

  Widget _statChip(String emoji, String value) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 6 * scale),
        decoration: BoxDecoration(
          color: AppColors.plum.withOpacity(0.08),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          '$emoji $value',
          style: GoogleFonts.fredoka(
            fontSize: 13 * scale,
            fontWeight: FontWeight.w700,
            color: AppColors.plum,
          ),
        ),
      );
}
