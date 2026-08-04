import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Label pil kecil huruf kapital, dipakai sebagai penanda status di atas
/// badge (mis. "RONDE SELESAI", "REKOR BARU!").
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final double scale;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 6 * scale),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
      ),
      child: Text(
        label,
        style: GoogleFonts.baloo2(
          fontSize: 11 * scale,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
