import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_item.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/big_button.dart';
import '../widgets/game_panel.dart';

/// Palet aksen yang dirotasi antar kartu kosakata (border & lencana huruf).
const List<Color> _kVocabAccents = [
  AppColors.coral,
  AppColors.plum,
  Color(0xFFC98A00),
  AppColors.grass,
];

class VocabScreen extends StatelessWidget {
  final GameCategory category;
  final VoidCallback onNext;

  const VocabScreen({super.key, required this.category, required this.onNext});

  @override
  Widget build(BuildContext context) {
    // Urutkan alfabetis supaya mudah dipelajari anak.
    final sorted = [...category.items]
      ..sort((a, b) => a.name.compareTo(b.name));

    final scale = context.uiScale;
    // Lebih banyak kolom di tablet supaya ruang panel yang lebih lebar dipakai
    // dengan baik alih-alih menyisakan kartu yang terlalu besar/kosong.
    final crossAxisCount = context.isTablet ? 4 : 3;

    return GamePanel(
      maxWidth: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LogoBadge(icon: category.icon, scale: scale),
          const SizedBox(height: 8),
          Text(
            'Kenalan Dulu Yuk!',
            style: GoogleFonts.baloo2(
              fontSize: 24 * scale,
              fontWeight: FontWeight.w800,
              color: AppColors.plum,
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.fredoka(fontSize: 14 * scale, color: const Color(0xFF665E7A)),
              children: [
                const TextSpan(text: 'Ini kosakata di ronde '),
                TextSpan(
                  text: category.name,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.coral),
                ),
                const TextSpan(text: '. Ingat-ingat namanya ya!'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.42),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: sorted.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, i) => _VocabCard(
                item: sorted[i],
                accent: _kVocabAccents[i % _kVocabAccents.length],
                scale: scale,
              ),
            ),
          ),
          BigButton(label: 'Lanjut', onTap: onNext),
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

class _VocabCard extends StatelessWidget {
  final GameItem item;
  final Color accent;
  final double scale;

  const _VocabCard({required this.item, required this.accent, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8 * scale, horizontal: 4 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: accent.withOpacity(0.15), offset: const Offset(0, 3), blurRadius: 4),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.emoji, style: TextStyle(fontSize: 32 * scale)),
                SizedBox(height: 6 * scale),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.fredoka(
                    fontSize: 11 * scale,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -6 * scale,
            right: -6 * scale,
            child: Container(
              width: 18 * scale,
              height: 18 * scale,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                item.letter,
                style: GoogleFonts.baloo2(
                  fontSize: 10 * scale,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
