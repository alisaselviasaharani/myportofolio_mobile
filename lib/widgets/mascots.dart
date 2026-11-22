import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';

/// Maskot bawah laut yang digambar dengan kode (tanpa file gambar), sehingga
/// tajam di ukuran berapa pun. Setiap maskot dibuat dalam kotak desain tetap
/// lalu diskalakan mengikuti ukuran widget.

/// Ubur-ubur ungu lucu (kotak desain 110 x 140).
class JellyfishMascot extends StatelessWidget {
  const JellyfishMascot({super.key, this.width = 96});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * 140 / 110,
      child: const CustomPaint(painter: _JellyfishPainter()),
    );
  }
}

class _JellyfishPainter extends CustomPainter {
  const _JellyfishPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 110, size.height / 140);

    // Tentakel: lengkung bergelombang, makin ke tengah makin panjang.
    final tentacle = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.linear(
        const Offset(0, 60),
        const Offset(0, 138),
        const [Color(0xFFB59CF2), Color(0xFFD9CCFA)],
      );
    const xs = [24.0, 36.0, 47.0, 58.0, 69.0, 82.0];
    const lens = [62.0, 74.0, 52.0, 78.0, 66.0, 56.0];
    for (var i = 0; i < xs.length; i++) {
      final x = xs[i];
      final dir = i.isEven ? 1.0 : -1.0;
      tentacle.strokeWidth = i == 2 || i == 3 ? 6.5 : 5.0;
      final path = Path()
        ..moveTo(x, 62)
        ..cubicTo(
          x + 12 * dir,
          62 + lens[i] * 0.3,
          x - 12 * dir,
          62 + lens[i] * 0.65,
          x + 5 * dir,
          62 + lens[i],
        );
      canvas.drawPath(path, tentacle);
    }

    // Kubah.
    final dome = Path()
      ..moveTo(8, 64)
      ..cubicTo(6, 26, 30, 4, 55, 4)
      ..cubicTo(80, 4, 104, 26, 102, 64)
      ..quadraticBezierTo(92, 70, 82, 64)
      ..quadraticBezierTo(69, 71, 55, 64)
      ..quadraticBezierTo(41, 71, 28, 64)
      ..quadraticBezierTo(18, 70, 8, 64)
      ..close();
    canvas.drawPath(
      dome,
      Paint()
        ..shader = ui.Gradient.linear(
          const Offset(30, 4),
          const Offset(80, 72),
          const [Color(0xFFD3C2FF), Color(0xFFA98CEC)],
        ),
    );
    // Kilau di kiri atas.
    canvas.drawOval(
      const Rect.fromLTWH(22, 14, 34, 18),
      Paint()..color = Colors.white.withValues(alpha: 0.45),
    );

    // Wajah: pipi, mata, senyum.
    final cheek = Paint()..color = const Color(0xFFFF8FB5).withValues(alpha: 0.6);
    canvas.drawOval(const Rect.fromLTWH(24, 46, 14, 9), cheek);
    canvas.drawOval(const Rect.fromLTWH(72, 46, 14, 9), cheek);
    final eye = Paint()..color = const Color(0xFF1B1B3A);
    canvas.drawCircle(const Offset(42, 42), 4.2, eye);
    canvas.drawCircle(const Offset(68, 42), 4.2, eye);
    final glint = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(43.4, 40.6), 1.4, glint);
    canvas.drawCircle(const Offset(69.4, 40.6), 1.4, glint);
    canvas.drawArc(
      const Rect.fromLTWH(49, 44, 12, 9),
      0.2,
      math.pi - 0.4,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2
        ..color = const Color(0xFF1B1B3A),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Ikan badut oranye menghadap ke kiri (kotak desain 90 x 56).
class ClownfishMascot extends StatelessWidget {
  const ClownfishMascot({super.key, this.width = 64});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * 56 / 90,
      child: const CustomPaint(painter: _ClownfishPainter()),
    );
  }
}

class _ClownfishPainter extends CustomPainter {
  const _ClownfishPainter();

  static const Color _orange = Color(0xFFFF7A1A);
  static const Color _orangeDark = Color(0xFFE85D0C);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 90, size.height / 56);

    // Ekor di kanan.
    final tail = Path()
      ..moveTo(66, 28)
      ..quadraticBezierTo(76, 14, 88, 10)
      ..quadraticBezierTo(84, 28, 88, 46)
      ..quadraticBezierTo(76, 42, 66, 28)
      ..close();
    canvas.drawPath(tail, Paint()..color = _orangeDark);

    // Sirip atas dan bawah.
    final fin = Paint()..color = _orangeDark;
    canvas.drawPath(
      Path()
        ..moveTo(26, 10)
        ..quadraticBezierTo(40, -2, 56, 10)
        ..quadraticBezierTo(42, 14, 26, 10)
        ..close(),
      fin,
    );
    canvas.drawPath(
      Path()
        ..moveTo(32, 46)
        ..quadraticBezierTo(44, 56, 54, 46)
        ..quadraticBezierTo(44, 44, 32, 46)
        ..close(),
      fin,
    );

    // Badan + garis putih (dipotong mengikuti bentuk badan).
    const body = Rect.fromLTWH(6, 8, 64, 40);
    canvas.save();
    canvas.clipPath(Path()..addOval(body));
    canvas.drawRect(
      body,
      Paint()
        ..shader = ui.Gradient.linear(
          const Offset(0, 8),
          const Offset(0, 48),
          const [Color(0xFFFF9A3C), _orange],
        ),
    );
    final stripe = Paint()..color = Colors.white;
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = const Color(0xFF2B2B2B).withValues(alpha: 0.55);
    for (final x in const [24.0, 46.0]) {
      final p = Path()
        ..moveTo(x - 4, 6)
        ..quadraticBezierTo(x + 3, 28, x - 4, 50)
        ..lineTo(x + 6, 50)
        ..quadraticBezierTo(x + 13, 28, x + 6, 6)
        ..close();
      canvas.drawPath(p, stripe);
      canvas.drawPath(p, outline);
    }
    canvas.restore();

    // Mata dan senyum.
    canvas.drawCircle(const Offset(17, 25), 4.2, Paint()..color = Colors.white);
    canvas.drawCircle(
      const Offset(16.6, 25),
      2.6,
      Paint()..color = const Color(0xFF1B1B1B),
    );
    canvas.drawArc(
      const Rect.fromLTWH(10, 28, 9, 7),
      0.3,
      math.pi - 0.8,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 1.3
        ..color = const Color(0xFF7A2E00),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Rumput laut hijau untuk menghiasi sisi kartu (kotak desain 70 x 70).
class Seaweed extends StatelessWidget {
  const Seaweed({super.key, this.size = 56, this.flip = false});

  final double size;

  /// Cerminkan secara horizontal (untuk sisi kanan).
  final bool flip;

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
      width: size,
      height: size,
      child: const CustomPaint(painter: _SeaweedPainter()),
    );
    return flip
        ? Transform(
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(-1, 1, 1),
            child: child,
          )
        : child;
  }
}

class _SeaweedPainter extends CustomPainter {
  const _SeaweedPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 70, size.height / 70);
    final stem = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const stems = [
      (x: 14.0, h: 44.0, c: Color(0xFF7BC043), w: 6.0),
      (x: 28.0, h: 58.0, c: Color(0xFF4FAF4A), w: 7.0),
      (x: 42.0, h: 38.0, c: Color(0xFF8AD14B), w: 6.0),
    ];
    for (final s in stems) {
      stem
        ..color = s.c
        ..strokeWidth = s.w;
      final path = Path()
        ..moveTo(s.x, 70)
        ..cubicTo(s.x - 9, 70 - s.h * 0.35, s.x + 9, 70 - s.h * 0.7,
            s.x, 70 - s.h);
      canvas.drawPath(path, stem);
    }
    // Karang oranye kecil di sebelah kanan.
    stem
      ..color = const Color(0xFFFF9F43)
      ..strokeWidth = 3.5;
    canvas.drawPath(
      Path()
        ..moveTo(56, 70)
        ..quadraticBezierTo(54, 56, 58, 46)
        ..moveTo(56, 62)
        ..quadraticBezierTo(62, 58, 64, 50),
      stem,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
