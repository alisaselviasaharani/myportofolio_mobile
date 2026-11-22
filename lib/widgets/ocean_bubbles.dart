import 'package:material_ui/material_ui.dart';

/// Lapisan gelembung hiasan untuk latar bawah laut.
///
/// Posisi dan ukuran gelembung tetap (tidak acak), dinyatakan sebagai
/// pecahan lebar/tinggi layar sehingga tata letaknya sama di HP maupun Chrome.
/// Lapisan ini tidak menerima sentuhan dan tidak memakai animasi, jadi aman
/// untuk `pumpAndSettle()` pada widget test.
class OceanBubbles extends StatelessWidget {
  const OceanBubbles({super.key});

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(painter: _BubblePainter(), size: Size.infinite),
      ),
    );
  }
}

/// Satu gelembung: titik pusat (pecahan lebar, tinggi) dan jari-jari (px).
class _Bubble {
  const _Bubble(this.dx, this.dy, this.radius);

  final double dx;
  final double dy;
  final double radius;
}

class _BubblePainter extends CustomPainter {
  const _BubblePainter();

  static const List<_Bubble> _bubbles = [
    _Bubble(0.08, 0.06, 14),
    _Bubble(0.16, 0.14, 7),
    _Bubble(0.88, 0.09, 18),
    _Bubble(0.78, 0.19, 8),
    _Bubble(0.93, 0.28, 11),
    _Bubble(0.05, 0.31, 10),
    _Bubble(0.12, 0.44, 16),
    _Bubble(0.90, 0.47, 7),
    _Bubble(0.82, 0.58, 13),
    _Bubble(0.06, 0.62, 8),
    _Bubble(0.18, 0.74, 12),
    _Bubble(0.94, 0.71, 17),
    _Bubble(0.72, 0.82, 9),
    _Bubble(0.30, 0.88, 6),
    _Bubble(0.55, 0.92, 10),
    _Bubble(0.46, 0.04, 6),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in _bubbles) {
      final center = Offset(size.width * b.dx, size.height * b.dy);
      final rect = Rect.fromCircle(center: center, radius: b.radius);

      // Isi: hampir bening di tengah, sedikit lebih putih di tepi.
      final fill = Paint()
        ..shader = const RadialGradient(
          colors: [Color(0x1FFFFFFF), Color(0x66FFFFFF)],
        ).createShader(rect);
      canvas.drawCircle(center, b.radius, fill);

      // Garis tepi tipis.
      final stroke = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = const Color(0xB3FFFFFF);
      canvas.drawCircle(center, b.radius, stroke);

      // Kilau kecil di kiri atas.
      final shine = Paint()..color = const Color(0xCCFFFFFF);
      canvas.drawCircle(
        center.translate(-b.radius * 0.35, -b.radius * 0.35),
        b.radius * 0.18,
        shine,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) => false;
}