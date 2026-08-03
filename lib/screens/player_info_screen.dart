import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/big_button.dart';
import '../widgets/game_panel.dart';

/// Layar pertama: anak memasukkan nama & usia sebagai identitas diri,
/// dipakai untuk sapaan personal di layar-layar berikutnya.
class PlayerInfoScreen extends StatefulWidget {
  final void Function(String name, int age) onSubmit;

  const PlayerInfoScreen({super.key, required this.onSubmit});

  @override
  State<PlayerInfoScreen> createState() => _PlayerInfoScreenState();
}

class _PlayerInfoScreenState extends State<PlayerInfoScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim());

    if (name.isEmpty) {
      setState(() => _errorText = 'Nama tidak boleh kosong ya!');
      return;
    }
    if (age == null || age < 1 || age > 99) {
      setState(() => _errorText = 'Usia harus berupa angka yang benar (1-99).');
      return;
    }

    setState(() => _errorText = null);
    widget.onSubmit(name, age);
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return GamePanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('👋😊', style: TextStyle(fontSize: 40 * scale)),
          const SizedBox(height: 6),
          Text(
            'Siapa Namamu?',
            style: GoogleFonts.baloo2(
              fontSize: 26 * scale,
              fontWeight: FontWeight.w800,
              color: AppColors.plum,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Isi nama dan usiamu dulu sebelum mulai bermain.',
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(fontSize: 15 * scale, color: const Color(0xFF665E7A)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            style: GoogleFonts.fredoka(fontSize: 16 * scale, color: AppColors.ink),
            decoration: InputDecoration(
              labelText: 'Nama',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: GoogleFonts.fredoka(fontSize: 16 * scale, color: AppColors.ink),
            decoration: InputDecoration(
              labelText: 'Usia',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 10),
            Text(
              _errorText!,
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(fontSize: 13 * scale, color: AppColors.coralDark),
            ),
          ],
          BigButton(label: 'Lanjut', onTap: _handleSubmit),
        ],
      ),
    );
  }
}
