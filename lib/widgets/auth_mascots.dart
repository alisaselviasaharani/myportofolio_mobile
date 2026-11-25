import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// Maskot untuk halaman Lupa Kata Sandi dan Atur Ulang Kata Sandi.
///
/// Ubur-ubur dan kuda laut untuk Login dan Daftar sudah ada di
/// `mascots.dart` dan `illustrations.dart`. Dua maskot di sini digambar
/// dengan kode juga, jadi tidak butuh file gambar baru.

/// Amplop dengan bintang kuning (kotak desain 120 x 94).
class EnvelopeMascot extends StatelessWidget {
  const EnvelopeMascot({super.key, this.width = 112});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * 94 / 120,
      child: const CustomPaint(painter: _EnvelopePainter()),
    );
  }
}

class _EnvelopePainter extends CustomPainter {
  const _EnvelopePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 120, size.height / 94);

    const line = Color(0xFF6FB1E6);
    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(6, 22, 100, 64),
      const Radius.circular(10),
    );
    canvas.drawRRect(body, Paint()..color = Colors.white);

    // Tutup amplop (segitiga di bagian atas).
    final flap = Path()
      ..moveTo(8, 26)
      ..lineTo(56, 62)
      ..lineTo(104, 26)
      ..close();
    canvas.drawPath(flap, Paint()..color = const Color(0xFFE3F3FF));

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = line;
    canvas.drawRRect(body, stroke);
    canvas.drawPath(
      Path()
        ..moveTo(8, 26)
        ..lineTo(56, 62)
        ..lineTo(104, 26),
      stroke,
    );

    // Bintang di pojok kanan bawah.
    final star = _starPath(const Offset(98, 68), 19, 8.5);
    canvas.drawPath(star, Paint()..color = const Color(0xFFFFD84D));
    canvas.drawPath(
      star,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round
        ..color = const Color(0xFFF2A81D),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Gembok emas (kotak desain 90 x 110).
class PadlockMascot extends StatelessWidget {
  const PadlockMascot({super.key, this.width = 84});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * 110 / 90,
      child: const CustomPaint(painter: _PadlockPainter()),
    );
  }
}

class _PadlockPainter extends CustomPainter {
  const _PadlockPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 90, size.height / 110);

    // Gagang gembok.
    final shackle = Path()
      ..moveTo(25, 54)
      ..lineTo(25, 38)
      ..arcToPoint(
        const Offset(65, 38),
        radius: const Radius.circular(20),
        clockwise: true,
      )
      ..lineTo(65, 54);
    canvas.drawPath(
      shackle,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 11
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFFB8C4D6),
    );

    // Badan gembok.
    const bodyRect = Rect.fromLTWH(8, 50, 74, 54);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, const Radius.circular(14)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFD34E), Color(0xFFF4A91C)],
        ).createShader(bodyRect),
    );
    // Kilau di sisi kiri atas.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(15, 57, 7, 22),
        const Radius.circular(4),
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.45),
    );

    // Lubang kunci.
    final hole = Paint()..color = const Color(0xFF8A4B14);
    canvas.drawCircle(const Offset(45, 73), 7.5, hole);
    canvas.drawPath(
      Path()
        ..moveTo(41, 76)
        ..lineTo(49, 76)
        ..lineTo(51, 92)
        ..lineTo(39, 92)
        ..close(),
      hole,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Bintang lima titik dengan pusat [center], jari-jari luar [outer] dan
/// jari-jari dalam [inner].
Path _starPath(Offset center, double outer, double inner) {
  final path = Path();
  for (var i = 0; i < 10; i++) {
    final radius = i.isEven ? outer : inner;
    final angle = -math.pi / 2 + i * math.pi / 5;
    final point = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
    if (i == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  return path..close();
}
