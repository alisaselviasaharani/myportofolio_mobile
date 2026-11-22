import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// Varian maskot kuning: membawa popcorn (halaman Skills) atau memakai
/// kacamata selam (halaman Contact).
enum YellowMascotKind { popcorn, snorkel }

/// Maskot kuning lucu yang digambar dengan kode (kotak desain 140 x 130),
/// sehingga tajam di ukuran berapa pun.
class YellowMascot extends StatelessWidget {
  const YellowMascot({
    super.key,
    this.kind = YellowMascotKind.popcorn,
    this.width = 140,
  });

  final YellowMascotKind kind;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * 130 / 140,
      child: CustomPaint(painter: _YellowMascotPainter(kind)),
    );
  }
}

class _YellowMascotPainter extends CustomPainter {
  const _YellowMascotPainter(this.kind);

  final YellowMascotKind kind;

  static const Color _yellow = Color(0xFFFFD43B);
  static const Color _yellowDark = Color(0xFFF2A91B);
  static const Color _outline = Color(0xFFE59A12);
  static const Color _ink = Color(0xFF3A2A14);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 140, size.height / 130);

    final fill = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    // Ekor kecil.
    fill.color = _yellowDark;
    canvas.drawOval(const Rect.fromLTWH(108, 78, 26, 18), fill);

    // Badan.
    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(32, 36, 78, 82),
      const Radius.circular(38),
    );
    fill.color = _yellow;
    canvas.drawRRect(body, fill);
    stroke.color = _outline;
    canvas.drawRRect(body, stroke);

    // Perut.
    fill.color = const Color(0xFFFFEB99);
    canvas.drawOval(const Rect.fromLTWH(48, 82, 46, 32), fill);

    // Kaki.
    fill.color = _yellowDark;
    canvas.drawOval(const Rect.fromLTWH(42, 110, 24, 14), fill);
    canvas.drawOval(const Rect.fromLTWH(76, 110, 24, 14), fill);

    // Telinga / jambul.
    final ear = Path()
      ..moveTo(40, 52)
      ..quadraticBezierTo(30, 30, 46, 24)
      ..quadraticBezierTo(54, 34, 56, 44)
      ..close();
    fill.color = _yellow;
    canvas.drawPath(ear, fill);
    stroke.color = _outline;
    canvas.drawPath(ear, stroke);
    final ear2 = Path()
      ..moveTo(102, 52)
      ..quadraticBezierTo(112, 30, 96, 24)
      ..quadraticBezierTo(88, 34, 86, 44)
      ..close();
    canvas.drawPath(ear2, fill);
    canvas.drawPath(ear2, stroke);

    // Pipi merona.
    fill.color = const Color(0xFFFF9E9E).withValues(alpha: 0.75);
    canvas.drawOval(const Rect.fromLTWH(38, 70, 14, 9), fill);
    canvas.drawOval(const Rect.fromLTWH(90, 70, 14, 9), fill);

    if (kind == YellowMascotKind.snorkel) {
      _paintSnorkel(canvas, fill, stroke);
    } else {
      _paintFace(canvas, fill, stroke, withEyes: true);
    }

    if (kind == YellowMascotKind.popcorn) {
      _paintPopcorn(canvas, fill, stroke);
    } else {
      // Tangan melambai.
      fill.color = _yellowDark;
      canvas.save();
      canvas.translate(30, 88);
      canvas.rotate(-0.6);
      canvas.drawOval(const Rect.fromLTWH(-8, -6, 18, 12), fill);
      canvas.restore();
      canvas.save();
      canvas.translate(112, 88);
      canvas.rotate(0.6);
      canvas.drawOval(const Rect.fromLTWH(-10, -6, 18, 12), fill);
      canvas.restore();
    }

    canvas.restore();
  }

  void _paintFace(
    Canvas canvas,
    Paint fill,
    Paint stroke, {
    required bool withEyes,
  }) {
    if (withEyes) {
      fill.color = _ink;
      canvas.drawOval(const Rect.fromLTWH(50, 56, 11, 14), fill);
      canvas.drawOval(const Rect.fromLTWH(81, 56, 11, 14), fill);
      fill.color = Colors.white;
      canvas.drawCircle(const Offset(54, 60), 2.6, fill);
      canvas.drawCircle(const Offset(85, 60), 2.6, fill);
    }
    // Mulut kecil tersenyum.
    stroke
      ..color = _ink
      ..strokeWidth = 2;
    final mouth = Path()
      ..moveTo(65, 74)
      ..quadraticBezierTo(71, 80, 77, 74);
    canvas.drawPath(mouth, stroke);
    stroke.strokeWidth = 2.2;
  }

  void _paintSnorkel(Canvas canvas, Paint fill, Paint stroke) {
    // Tali kacamata.
    stroke
      ..color = const Color(0xFF1B7FC4)
      ..strokeWidth = 6;
    canvas.drawLine(const Offset(34, 62), const Offset(108, 62), stroke);
    stroke
      ..color = _outline
      ..strokeWidth = 2.2;

    // Lensa kacamata.
    for (final cx in const [56.0, 87.0]) {
      fill.color = const Color(0xFFFFFFFF);
      canvas.drawCircle(Offset(cx, 63), 13, fill);
      stroke
        ..color = const Color(0xFF1B7FC4)
        ..strokeWidth = 4;
      canvas.drawCircle(Offset(cx, 63), 13, stroke);
      fill.color = _ink;
      canvas.drawOval(Rect.fromLTWH(cx - 5, 57, 10, 13), fill);
      fill.color = Colors.white;
      canvas.drawCircle(Offset(cx - 2, 61), 2.2, fill);
    }
    stroke
      ..color = _outline
      ..strokeWidth = 2.2;

    // Pipa snorkel.
    stroke
      ..color = const Color(0xFFEF6F6C)
      ..strokeWidth = 5;
    final tube = Path()
      ..moveTo(106, 62)
      ..quadraticBezierTo(122, 56, 120, 30);
    canvas.drawPath(tube, stroke);
    stroke
      ..color = _outline
      ..strokeWidth = 2.2;

    // Mulut terbuka senang.
    fill.color = const Color(0xFF8C3B2A);
    final mouth = Path()
      ..moveTo(63, 80)
      ..quadraticBezierTo(71, 92, 79, 80)
      ..close();
    canvas.drawPath(mouth, fill);
  }

  void _paintPopcorn(Canvas canvas, Paint fill, Paint stroke) {
    // Tangan memegang gelas popcorn.
    fill.color = _yellowDark;
    canvas.drawOval(const Rect.fromLTWH(44, 92, 16, 14), fill);
    canvas.drawOval(const Rect.fromLTWH(82, 92, 16, 14), fill);

    // Popcorn di atas gelas.
    fill.color = const Color(0xFFFFF7E0);
    stroke
      ..color = const Color(0xFFE8D3A0)
      ..strokeWidth = 1.6;
    for (final p in const [
      Offset(54, 92),
      Offset(66, 87),
      Offset(78, 87),
      Offset(89, 92),
      Offset(60, 95),
      Offset(83, 96),
    ]) {
      canvas.drawCircle(p, 7, fill);
      canvas.drawCircle(p, 7, stroke);
    }

    // Gelas bergaris pink-putih.
    final cup = Path()
      ..moveTo(50, 96)
      ..lineTo(92, 96)
      ..lineTo(86, 124)
      ..lineTo(56, 124)
      ..close();
    fill.color = Colors.white;
    canvas.drawPath(cup, fill);
    canvas.save();
    canvas.clipPath(cup);
    fill.color = const Color(0xFFFF6FA8);
    for (var i = 0; i < 4; i++) {
      canvas.drawRect(Rect.fromLTWH(50.0 + i * 11.0, 96, 5.5, 30), fill);
    }
    canvas.restore();
    stroke
      ..color = const Color(0xFFE0488A)
      ..strokeWidth = 1.8;
    canvas.drawPath(cup, stroke);

    // Kilau kecil.
    stroke
      ..color = Colors.white
      ..strokeWidth = 2;
    canvas.drawLine(
      const Offset(108, 40),
      Offset(108 + 6 * math.cos(0.8), 40 - 6 * math.sin(0.8)),
      stroke,
    );
    stroke.strokeWidth = 2.2;
  }

  @override
  bool shouldRepaint(covariant _YellowMascotPainter oldDelegate) =>
      oldDelegate.kind != kind;
}
