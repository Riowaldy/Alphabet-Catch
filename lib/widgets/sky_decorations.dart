import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Matahari + awan yang melayang di atas gradient langit, dipakai di semua
/// layar yang duduk di atas [AppColors.backgroundGradient] (HUD gameplay
/// maupun layar hasil Navigator.push) supaya latar tidak terlihat datar.
class SkyDecorations extends StatelessWidget {
  const SkyDecorations({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        return Stack(
          children: [
            Positioned(
              top: 24,
              right: 24,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.sun,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.sun.withOpacity(0.35), blurRadius: 0, spreadRadius: 8),
                  ],
                ),
              ),
            ),
            Positioned(top: 60, left: w * 0.08, child: _cloud(70, 26)),
            Positioned(top: 140, left: w * 0.65, child: _cloud(90, 30)),
          ],
        );
      },
    );
  }

  Widget _cloud(double w, double h) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(50),
        ),
      );
}
