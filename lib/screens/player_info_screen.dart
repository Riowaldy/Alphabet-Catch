import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
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
  static const _fieldFill = Color(0xFFF1EEFB);
  static const _tipFill = Color(0xFFFFF6D8);

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
      scrim: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('👋😊', style: TextStyle(fontSize: 44 * scale)),
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
            'Isi nama dan usiamu dulu\nsebelum mulai bermain! 🚀',
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(fontSize: 15 * scale, color: const Color(0xFF665E7A)),
          ),
          const SizedBox(height: 20),
          _LabeledField(
            icon: Icons.person_rounded,
            label: 'Nama',
            hint: 'Ketik nama kamu...',
            fill: _fieldFill,
            scale: scale,
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          _LabeledField(
            icon: Icons.cake_rounded,
            label: 'Usia',
            hint: 'Ketik usia kamu...',
            fill: _fieldFill,
            scale: scale,
            controller: _ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 10),
            Text(
              _errorText!,
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(fontSize: 13 * scale, color: AppColors.coralDark),
            ),
          ],
          const SizedBox(height: 18),
          _GradientNextButton(label: 'Lanjut', onTap: _handleSubmit, scale: scale),
          const SizedBox(height: 14),
          _DotsIndicator(scale: scale),
          const SizedBox(height: 16),
          _TipBox(
            fill: _tipFill,
            scale: scale,
            text: 'Kamu bisa menggunakan nama panggilan\natau nama asli, lho! 😊',
          ),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final Color fill;
  final double scale;
  final TextEditingController controller;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _LabeledField({
    required this.icon,
    required this.label,
    required this.hint,
    required this.fill,
    required this.scale,
    required this.controller,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.plum, size: 22 * scale),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.baloo2(
                    fontSize: 13 * scale,
                    fontWeight: FontWeight.w700,
                    color: AppColors.plum,
                  ),
                ),
                TextField(
                  controller: controller,
                  textCapitalization: textCapitalization,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  style: GoogleFonts.fredoka(fontSize: 15 * scale, color: AppColors.ink),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: hint,
                    hintStyle: GoogleFonts.fredoka(fontSize: 14 * scale, color: AppColors.subtitle),
                    filled: false,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientNextButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final double scale;

  const _GradientNextButton({required this.label, required this.onTap, required this.scale});

  @override
  State<_GradientNextButton> createState() => _GradientNextButtonState();
}

class _GradientNextButtonState extends State<_GradientNextButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(0, _pressed ? 3 : 0, 0),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.plum, AppColors.plumDark],
          ),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: AppColors.plumDark,
              offset: Offset(0, _pressed ? 2 : 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sports_esports_rounded, color: Colors.white, size: 20 * widget.scale),
            const SizedBox(width: 10),
            Text(
              widget.label,
              style: GoogleFonts.baloo2(
                fontSize: 18 * widget.scale,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20 * widget.scale),
          ],
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final double scale;

  const _DotsIndicator({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = i == 0;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: (active ? 20 : 6) * scale,
          height: 6 * scale,
          decoration: BoxDecoration(
            color: active ? AppColors.plum : AppColors.plum.withOpacity(0.25),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _TipBox extends StatelessWidget {
  final Color fill;
  final double scale;
  final String text;

  const _TipBox({required this.fill, required this.scale, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('💡', style: TextStyle(fontSize: 18 * scale)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.fredoka(fontSize: 12.5 * scale, color: const Color(0xFF6B5E33)),
            ),
          ),
        ],
      ),
    );
  }
}
