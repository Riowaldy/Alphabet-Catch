import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/big_button.dart';
import '../widgets/game_route_scaffold.dart';
import 'about_screen.dart';
import 'dashboard_screen.dart';
import 'update_profile_screen.dart';

/// Menu navigasi ke fitur tambahan di luar alur permainan utama.
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return GameRouteScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('⚙️', style: TextStyle(fontSize: 40 * scale)),
          const SizedBox(height: 6),
          Text(
            'Menu',
            style: GoogleFonts.baloo2(
              fontSize: 26 * scale,
              fontWeight: FontWeight.w800,
              color: AppColors.plum,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lihat data pemain atau ubah profilmu di sini.',
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(fontSize: 14 * scale, color: const Color(0xFF665E7A)),
          ),
          const SizedBox(height: 10),
          BigButton(
            label: '📋 Dashboard',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            ),
          ),
          BigButton(
            label: '✏️ Update Profil',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UpdateProfileScreen()),
            ),
            secondary: true,
          ),
          BigButton(
            label: 'ℹ️ Tentang Kami',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
          BigButton(
            label: 'Kembali',
            onTap: () => Navigator.pop(context),
            secondary: true,
          ),
        ],
      ),
    );
  }
}
