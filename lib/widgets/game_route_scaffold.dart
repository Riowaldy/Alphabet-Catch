import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'game_panel.dart';
import 'sky_decorations.dart';

/// Bungkus Scaffold + latar gradient + GamePanel untuk layar yang didorong
/// lewat Navigator.push (di luar alur state machine GameScreen), mis. menu,
/// dashboard, ubah profil, & tentang kami.
class GameRouteScaffold extends StatelessWidget {
  final Widget child;

  const GameRouteScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Stack(
          children: [
            const Positioned.fill(child: SkyDecorations()),
            GamePanel(scrim: false, child: child),
          ],
        ),
      ),
    );
  }
}
