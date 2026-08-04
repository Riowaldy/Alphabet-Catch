import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme/app_colors.dart';

/// Overlay perayaan: partikel kembang api yang meledak berulang + efek
/// kilatan cahaya di seluruh layar tiap ledakan. Dipakai saat pemain
/// berhasil menangkap semua item dengan benar (layar "Hebat!").
class FireworksOverlay extends StatefulWidget {
  const FireworksOverlay({super.key});

  @override
  State<FireworksOverlay> createState() => _FireworksOverlayState();
}

class _Particle {
  final double angle;
  final double speed;
  final double gravity;
  final double life;
  final double size;
  final Color color;

  _Particle({
    required this.angle,
    required this.speed,
    required this.gravity,
    required this.life,
    required this.size,
    required this.color,
  });
}

class _Burst {
  final Offset center;
  final Color color;
  final double startTime;
  final List<_Particle> particles;

  _Burst({
    required this.center,
    required this.color,
    required this.startTime,
    required this.particles,
  });
}

const _fireworkColors = [
  AppColors.coral,
  AppColors.sun,
  AppColors.plum,
  AppColors.success,
  AppColors.skyTop,
  Colors.pinkAccent,
  Colors.white,
];

class _FireworksOverlayState extends State<FireworksOverlay>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final Random _rand = Random();
  final List<_Burst> _bursts = [];
  double _elapsed = 0;
  Timer? _spawnTimer;
  Size _size = Size.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    _scheduleSpawn(const Duration(milliseconds: 120));
  }

  void _scheduleSpawn(Duration delay) {
    _spawnTimer = Timer(delay, () {
      if (!mounted) return;
      _spawnBurst();
      _scheduleSpawn(Duration(milliseconds: 450 + _rand.nextInt(400)));
    });
  }

  void _spawnBurst() {
    if (_size.isEmpty) return;
    final center = Offset(
      _size.width * (0.15 + _rand.nextDouble() * 0.7),
      _size.height * (0.15 + _rand.nextDouble() * 0.45),
    );
    final color = _fireworkColors[_rand.nextInt(_fireworkColors.length)];
    final count = 26 + _rand.nextInt(10);
    final particles = List.generate(count, (i) {
      final angle = (2 * pi / count) * i + _rand.nextDouble() * 0.3;
      return _Particle(
        angle: angle,
        speed: 90 + _rand.nextDouble() * 110,
        gravity: 140,
        life: 0.9 + _rand.nextDouble() * 0.4,
        size: 2.5 + _rand.nextDouble() * 2.5,
        color: color,
      );
    });
    _bursts.add(_Burst(center: center, color: color, startTime: _elapsed, particles: particles));
    if (_bursts.length > 8) _bursts.removeAt(0);
  }

  void _onTick(Duration elapsed) {
    _elapsed = elapsed.inMicroseconds / 1e6;
    _bursts.removeWhere((b) => _elapsed - b.startTime > 1.6);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _size = Size(constraints.maxWidth, constraints.maxHeight);
      return IgnorePointer(
        child: CustomPaint(
          size: _size,
          painter: _FireworksPainter(bursts: _bursts, elapsed: _elapsed),
        ),
      );
    });
  }
}

class _FireworksPainter extends CustomPainter {
  final List<_Burst> bursts;
  final double elapsed;

  _FireworksPainter({required this.bursts, required this.elapsed});

  @override
  void paint(Canvas canvas, Size size) {
    // Dasar gelap ala langit malam: kembang api jadi kontras, sekaligus
    // menggantikan scrim gelap biasa supaya panel tetap terbaca.
    final bg = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF2E1F52), Color(0xCC120A24)],
        radius: 1.1,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    double screenFlash = 0;

    for (final burst in bursts) {
      final age = elapsed - burst.startTime;
      if (age < 0) continue;

      // Efek kilatan cahaya di titik ledakan, bukan cuma partikel diam.
      if (age < 0.22) {
        final flashT = 1 - (age / 0.22);
        final flashOpacity = flashT * 0.4;
        if (flashOpacity > screenFlash) screenFlash = flashOpacity;
        final flashPaint = Paint()
          ..shader = RadialGradient(
            colors: [burst.color.withOpacity(flashOpacity), burst.color.withOpacity(0)],
          ).createShader(Rect.fromCircle(center: burst.center, radius: size.longestSide * 0.5));
        canvas.drawRect(Offset.zero & size, flashPaint);
      }

      for (final p in burst.particles) {
        final t = age;
        if (t < 0 || t > p.life) continue;
        final dx = cos(p.angle) * p.speed * t;
        final dy = sin(p.angle) * p.speed * t + 0.5 * p.gravity * t * t;
        final pos = burst.center + Offset(dx, dy);
        final lifeT = (t / p.life).clamp(0.0, 1.0);
        final alpha = 1 - lifeT;
        if (alpha <= 0) continue;

        final glowPaint = Paint()
          ..color = p.color.withOpacity(alpha * 0.9)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(pos, p.size * (1 - lifeT * 0.4), glowPaint);

        final corePaint = Paint()..color = Colors.white.withOpacity(alpha * 0.7);
        canvas.drawCircle(pos, p.size * 0.35, corePaint);
      }
    }

    // Kilatan cahaya menyeluruh layar tiap ada ledakan baru (efek layar,
    // bukan sekadar gambar kembang api).
    if (screenFlash > 0) {
      final overlayPaint = Paint()..color = Colors.white.withOpacity(screenFlash * 0.25);
      canvas.drawRect(Offset.zero & size, overlayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FireworksPainter oldDelegate) => true;
}
