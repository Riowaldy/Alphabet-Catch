import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
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
      borderColor: Colors.white,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFF1DE), Color(0xFFFCE3F0), Color(0xFFE8E1FC)],
      ),
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
          const SizedBox(height: 4),
          _MascotBadge(scale: scale),
          const SizedBox(height: 12),
          Text(
            'Alphabet Catch!',
            style: GoogleFonts.baloo2(
              fontSize: 30 * scale,
              fontWeight: FontWeight.w800,
              color: AppColors.plum,
            ),
          ),
          const SizedBox(height: 10),
          if (playerName.isNotEmpty) ...[
            _PlayerCard(
              name: playerName,
              age: playerAge,
              country: playerCountry,
              highScore: highScore,
              scale: scale,
            ),
            const SizedBox(height: 14),
          ],
          _HowToPlayTip(scale: scale),
          const SizedBox(height: 16),
          _GradientStartButton(label: 'Mulai Main', onTap: onStart, scale: scale),
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
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Color(0x26000000), offset: Offset(0, 4))],
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 20 * scale, color: AppColors.plum),
        ),
      );
}

/// Lencana maskot bulat bergradasi, pengganti baris chip buah & huruf.
class _MascotBadge extends StatelessWidget {
  final double scale;

  const _MascotBadge({required this.scale});

  @override
  Widget build(BuildContext context) {
    final size = 74 * scale;
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
      child: Text('🔤', style: TextStyle(fontSize: 34 * scale)),
    );
  }
}

/// Kartu sapaan pemain: avatar inisial nama, sapaan, dan ringkasan
/// negara & skor tertinggi dalam satu kartu (dulu 2 baris terpisah).
class _PlayerCard extends StatelessWidget {
  final String name;
  final int age;
  final String country;
  final int highScore;
  final double scale;

  const _PlayerCard({
    required this.name,
    required this.age,
    required this.country,
    required this.highScore,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 10 * scale),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.coral.withOpacity(0.35), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40 * scale,
            height: 40 * scale,
            decoration: const BoxDecoration(color: AppColors.coral, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              name.substring(0, 1).toUpperCase(),
              style: GoogleFonts.baloo2(fontSize: 18 * scale, fontWeight: FontWeight.w800, color: Colors.white),
            ),
          ),
          SizedBox(width: 10 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Halo, $name! 👋',
                  style: GoogleFonts.baloo2(fontSize: 15 * scale, fontWeight: FontWeight.w700, color: AppColors.coralDark),
                ),
                Text(
                  '$age tahun • 🌏 $country',
                  style: GoogleFonts.fredoka(fontSize: 12.5 * scale, color: AppColors.subtitle),
                ),
              ],
            ),
          ),
          SizedBox(width: 8 * scale),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10 * scale, vertical: 6 * scale),
            decoration: BoxDecoration(
              color: AppColors.plum.withOpacity(0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '🏆 $highScore',
              style: GoogleFonts.fredoka(fontSize: 13 * scale, fontWeight: FontWeight.w700, color: AppColors.plum),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ringkasan cara bermain, ditampilkan sebagai tip box kuning lembut.
class _HowToPlayTip extends StatelessWidget {
  final double scale;

  const _HowToPlayTip({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 10 * scale),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6D8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🎮', style: TextStyle(fontSize: 18 * scale)),
          SizedBox(width: 8 * scale),
          Flexible(
            child: Text(
              'Tangkap gambar yang namanya diawali huruf yang aktif. '
              'Geser jari atau mouse untuk menggerakkan keranjang!',
              style: GoogleFonts.fredoka(fontSize: 12.5 * scale, color: const Color(0xFF6B5E33)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tombol mulai bergradasi coral→ungu dengan animasi tertekan sederhana.
class _GradientStartButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final double scale;

  const _GradientStartButton({required this.label, required this.onTap, required this.scale});

  @override
  State<_GradientStartButton> createState() => _GradientStartButtonState();
}

class _GradientStartButtonState extends State<_GradientStartButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(0, _pressed ? 3 : 0, 0),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.coral, AppColors.plum]),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(color: AppColors.plumDark, offset: Offset(0, _pressed ? 2 : 5)),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22 * widget.scale),
            SizedBox(width: 8 * widget.scale),
            Text(
              widget.label,
              style: GoogleFonts.baloo2(fontSize: 18 * widget.scale, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
