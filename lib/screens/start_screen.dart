import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/big_button.dart';
import '../widgets/game_panel.dart';

class StartScreen extends StatelessWidget {
  final String playerName;
  final int playerAge;
  final VoidCallback onStart;
  final VoidCallback onOpenMenu;

  const StartScreen({
    super.key,
    required this.playerName,
    required this.playerAge,
    required this.onStart,
    required this.onOpenMenu,
  });

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return GamePanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(alignment: Alignment.topRight, child: _menuButton(scale)),
          Text('🍎🔤🍇', style: TextStyle(fontSize: 40 * scale)),
          const SizedBox(height: 6),
          Text(
            'Alphabet Catch!',
            style: GoogleFonts.baloo2(
              fontSize: 30 * scale,
              fontWeight: FontWeight.w800,
              color: AppColors.plum,
            ),
          ),
          if (playerName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Halo, $playerName ($playerAge tahun)! 👋',
              style: GoogleFonts.fredoka(
                fontSize: 16 * scale,
                fontWeight: FontWeight.w700,
                color: AppColors.coralDark,
              ),
            ),
          ],
          const SizedBox(height: 8),
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

  Widget _menuButton(double scale) => GestureDetector(
        onTap: onOpenMenu,
        child: Container(
          width: 36 * scale,
          height: 36 * scale,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Color(0x26000000), offset: Offset(0, 4))],
          ),
          alignment: Alignment.center,
          child: Icon(Icons.menu_rounded, size: 20 * scale, color: AppColors.plum),
        ),
      );
}
