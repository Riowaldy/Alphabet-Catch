import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/categories.dart';
import '../models/game_item.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/game_panel.dart';

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
          Text('🎮', style: TextStyle(fontSize: 40 * scale)),
          const SizedBox(height: 6),
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
          const SizedBox(height: 16),
          for (int i = 0; i < kCategories.length; i++) ...[
            _CategoryCard(
              category: kCategories[i],
              onTap: () => onSelect(i),
              scale: scale,
            ),
            if (i != kCategories.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final GameCategory category;
  final VoidCallback onTap;
  final double scale;

  const _CategoryCard({required this.category, required this.onTap, required this.scale});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F4FB),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(category.icon, style: TextStyle(fontSize: 38 * scale)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: GoogleFonts.baloo2(
                      fontSize: 18 * scale,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    '${category.items.length} item untuk ditangkap',
                    style: GoogleFonts.fredoka(fontSize: 12 * scale, color: AppColors.subtitle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
