import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Tombol besar dengan efek "tebal" (shadow bawah) khas UI anak-anak.
/// [secondary] memakai warna ungu untuk aksi kedua (mis. "Selesai").
class BigButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool secondary;

  const BigButton({
    super.key,
    required this.label,
    required this.onTap,
    this.secondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = secondary ? AppColors.plum : AppColors.coral;
    final shadowColor = secondary ? AppColors.plumDark : AppColors.coralDark;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: double.infinity,
        child: _PressableShadowButton(
          color: baseColor,
          shadowColor: shadowColor,
          onTap: onTap,
          child: Text(
            label,
            style: GoogleFonts.baloo2(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tombol dengan animasi "tertekan" sederhana (bergeser turun saat ditekan).
class _PressableShadowButton extends StatefulWidget {
  final Color color;
  final Color shadowColor;
  final VoidCallback onTap;
  final Widget child;

  const _PressableShadowButton({
    required this.color,
    required this.shadowColor,
    required this.onTap,
    required this.child,
  });

  @override
  State<_PressableShadowButton> createState() =>
      _PressableShadowButtonState();
}

class _PressableShadowButtonState extends State<_PressableShadowButton> {
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
        transform: Matrix4.translationValues(0, _pressed ? 4 : 0, 0),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: widget.shadowColor,
              offset: Offset(0, _pressed ? 2 : 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}
