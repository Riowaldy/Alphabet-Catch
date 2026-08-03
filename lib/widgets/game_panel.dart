import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Bungkus overlay gelap + panel putih membulat, dipakai di semua layar
/// non-gameplay (start, pilih kategori, kosakata, ronde, menang, kalah, selesai).
class GamePanel extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const GamePanel({super.key, required this.child, this.maxWidth = 340});

  @override
  Widget build(BuildContext context) {
    // Panel melebar sedikit di tablet supaya tidak terlihat kekecilan,
    // dan tetap otomatis menyempit di HP lewat batas lebar layar itu sendiri.
    final effectiveMaxWidth = maxWidth * context.uiScale;

    return Container(
      color: Colors.black.withOpacity(0.55),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: SingleChildScrollView(
          // Mencegah overflow saat layar pendek (mis. HP dalam orientasi landscape).
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(color: Color(0x33000000), offset: Offset(0, 12)),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
