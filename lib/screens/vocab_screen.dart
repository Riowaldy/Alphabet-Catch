import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_item.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/big_button.dart';
import '../widgets/game_panel.dart';

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
          Text(category.icon, style: TextStyle(fontSize: 40 * scale)),
          const SizedBox(height: 4),
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
              itemBuilder: (context, i) => _VocabCard(item: sorted[i], scale: scale),
            ),
          ),
          BigButton(label: 'Lanjut', onTap: onNext),
        ],
      ),
    );
  }
}

class _VocabCard extends StatelessWidget {
  final GameItem item;
  final double scale;

  const _VocabCard({required this.item, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F4FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item.emoji, style: TextStyle(fontSize: 32 * scale)),
          const SizedBox(height: 4),
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
          const SizedBox(height: 4),
          Container(
            width: 18 * scale,
            height: 18 * scale,
            decoration: const BoxDecoration(color: AppColors.plum, shape: BoxShape.circle),
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
        ],
      ),
    );
  }
}
