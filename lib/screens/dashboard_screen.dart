import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/player_prefs.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/big_button.dart';
import '../widgets/game_route_scaffold.dart';

/// Menampilkan ringkasan data pemain: nama, usia, negara, & skor tertinggi.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  SavedPlayer? _player;
  int _highScore = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final player = await PlayerPrefs.loadPlayer();
    final highScore = await PlayerPrefs.loadHighScore();
    if (!mounted) return;
    setState(() {
      _player = player;
      _highScore = highScore;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return GameRouteScaffold(
      child: _loading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(color: AppColors.plum),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('📋', style: TextStyle(fontSize: 40 * scale)),
                const SizedBox(height: 6),
                Text(
                  'Dashboard Pemain',
                  style: GoogleFonts.baloo2(
                    fontSize: 24 * scale,
                    fontWeight: FontWeight.w800,
                    color: AppColors.plum,
                  ),
                ),
                const SizedBox(height: 16),
                _infoRow(scale, '🧒 Nama', _player?.name ?? '-'),
                _infoRow(
                  scale,
                  '🎂 Usia',
                  _player != null ? '${_player!.age} tahun' : '-',
                ),
                _infoRow(scale, '🌏 Negara', _player?.country ?? '-'),
                _infoRow(scale, '🏆 Skor Tertinggi', '$_highScore'),
                BigButton(
                  label: 'Kembali',
                  onTap: () => Navigator.pop(context),
                  secondary: true,
                ),
              ],
            ),
    );
  }

  Widget _infoRow(double scale, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.fredoka(fontSize: 15 * scale, color: AppColors.subtitle),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.fredoka(
                fontSize: 15 * scale,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
