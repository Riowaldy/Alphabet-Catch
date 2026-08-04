import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/categories.dart';
import '../models/game_item.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/game_panel.dart';

/// Palet aksen yang dirotasi antar kartu kategori (warna & bayangan).
const List<List<Color>> _kCategoryAccents = [
  [AppColors.coral, AppColors.coralDark],
  [AppColors.plum, AppColors.plumDark],
  [AppColors.sun, Color(0xFFC98A00)],
  [AppColors.grass, Color(0xFF2E7D32)],
];

class CategoryScreen extends StatelessWidget {
  final void Function(int index) onSelect;

  const CategoryScreen({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return GamePanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LogoBadge(scale: scale),
          const SizedBox(height: 10),
          Text(
            'Pilih Permainan',
            style: GoogleFonts.baloo2(
              fontSize: 26 * scale,
              fontWeight: FontWeight.w800,
              color: AppColors.plum,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Mau tangkap apa hari ini?',
            style: GoogleFonts.fredoka(fontSize: 15 * scale, color: const Color(0xFF665E7A)),
          ),
          SizedBox(height: 18 * scale),
          for (int i = 0; i < kCategories.length; i++) ...[
            _CategoryCard(
              category: kCategories[i],
              accent: _kCategoryAccents[i % _kCategoryAccents.length],
              onTap: () => onSelect(i),
              scale: scale,
            ),
            if (i != kCategories.length - 1) SizedBox(height: 12 * scale),
          ],
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
    final size = 64 * scale;
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
      child: Text('🎮', style: TextStyle(fontSize: 30 * scale)),
    );
  }
}

/// Kartu kategori dengan lencana ikon berwarna & animasi tertekan sederhana.
class _CategoryCard extends StatefulWidget {
  final GameCategory category;
  final List<Color> accent;
  final VoidCallback onTap;
  final double scale;

  const _CategoryCard({
    required this.category,
    required this.accent,
    required this.onTap,
    required this.scale,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;
    final baseColor = widget.accent[0];
    final darkColor = widget.accent[1];

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(0, _pressed ? 3 : 0, 0),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 14 * scale),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F4FB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: baseColor.withOpacity(0.25), width: 1.5),
          boxShadow: [
            BoxShadow(color: darkColor.withOpacity(0.25), offset: Offset(0, _pressed ? 1 : 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52 * scale,
              height: 52 * scale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [baseColor, darkColor],
                ),
              ),
              alignment: Alignment.center,
              child: Text(widget.category.icon, style: TextStyle(fontSize: 26 * scale)),
            ),
            SizedBox(width: 14 * scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.category.name,
                    style: GoogleFonts.baloo2(
                      fontSize: 18 * scale,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  SizedBox(height: 3 * scale),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 3 * scale),
                    decoration: BoxDecoration(
                      color: baseColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${widget.category.items.length} item untuk ditangkap',
                      style: GoogleFonts.fredoka(
                        fontSize: 11.5 * scale,
                        fontWeight: FontWeight.w600,
                        color: darkColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 26 * scale, color: baseColor),
          ],
        ),
      ),
    );
  }
}
