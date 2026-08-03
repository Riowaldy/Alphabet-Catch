import 'package:flutter/material.dart';

/// Sisi terpendek layar mulai dianggap tablet (bukan HP).
const double kTabletBreakpoint = 600;

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  /// True kalau perangkat cukup lebar untuk dianggap tablet.
  bool get isTablet => screenSize.shortestSide >= kTabletBreakpoint;

  /// Faktor skala untuk font/ikon/elemen UI supaya tidak terlihat kekecilan
  /// di tablet atau kebesaran di HP layar sempit.
  double get uiScale {
    final shortest = screenSize.shortestSide;
    if (shortest >= 900) return 1.35;
    if (shortest >= kTabletBreakpoint) return 1.18;
    if (shortest < 340) return 0.92;
    return 1.0;
  }
}
