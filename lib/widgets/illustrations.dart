import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';

/// Jenis ilustrasi besar di kepala form.
enum FormKind { education, experience, certification }

/// Ilustrasi besar di kepala form (kotak desain 150 x 110), digambar dengan
/// kode: topi wisuda + buku, koper, kurung kode, atau medali.
class FormIllustration extends StatelessWidget {
  const FormIllustration({super.key, required this.kind, this.width = 150});

  final FormKind kind;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * 110 / 150,
      child: CustomPaint(painter: _FormPainter(kind)),
    );
  }
}

class _FormPainter extends CustomPainter {
  const _FormPainter(this.kind);

  final FormKind kind;

  static const Color _navy = Color(0xFF1F2A6B);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 150, size.height / 110);
    _sparkles(canvas);
    switch (kind) {
      case FormKind.education:
        _education(canvas);
      case FormKind.experience:
        _briefcase(canvas);
      case FormKind.certification:
        _medal(canvas);
    }
    canvas.restore();
  }

  void _sparkles(Canvas canvas) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4
      ..color = const Color(0xFFFFC83D);
    void line(double x1, double y1, double x2, double y2) =>
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), p);
    // Kiri.
    line(14, 12, 24, 20);
    line(6, 28, 18, 28);
    line(14, 44, 24, 38);
    // Kanan.
    line(136, 12, 126, 20);
    line(144, 28, 132, 28);
    line(136, 44, 126, 38);
  }

  void _education(Canvas canvas) {
    RRect book(double x, double y, double w, Color c) {
      final r = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, w, 15),
        const Radius.circular(4),
      );
      canvas.drawRRect(r, Paint()..color = c);
      // Tepi halaman.
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + w * 0.12, y + 4, w * 0.82, 7),
          const Radius.circular(2),
        ),
        Paint()..color = const Color(0xFFFFF4D6),
      );
      return r;
    }

    book(18, 92, 114, const Color(0xFF6DBE45));
    book(26, 77, 100, const Color(0xFFF5A33A));
    book(34, 62, 88, const Color(0xFF2BA6B8));

    // Badan topi.
    canvas.drawPath(
      Path()
        ..moveTo(50, 36)
        ..lineTo(100, 36)
        ..lineTo(98, 58)
        ..quadraticBezierTo(75, 70, 52, 58)
        ..close(),
      Paint()..color = const Color(0xFF3B2F96),
    );
    // Papan topi.
    canvas.drawPath(
      Path()
        ..moveTo(75, 8)
        ..lineTo(130, 28)
        ..lineTo(75, 48)
        ..lineTo(20, 28)
        ..close(),
      Paint()
        ..shader = ui.Gradient.linear(
          const Offset(20, 8),
          const Offset(130, 48),
          const [Color(0xFF6D5CD6), Color(0xFF3B2F96)],
        ),
    );
    // Tali dan jumbai kuning.
    final tassel = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3
      ..color = const Color(0xFFFFC83D);
    canvas.drawPath(
      Path()
        ..moveTo(75, 28)
        ..lineTo(118, 34)
        ..lineTo(118, 56),
      tassel,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(113, 54, 10, 12),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFFFC83D),
    );
  }

  void _briefcase(Canvas canvas) {
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 4
      ..color = _navy;
    // Pegangan.
    canvas.drawPath(
      Path()
        ..moveTo(54, 36)
        ..lineTo(54, 22)
        ..quadraticBezierTo(54, 16, 60, 16)
        ..lineTo(90, 16)
        ..quadraticBezierTo(96, 16, 96, 22)
        ..lineTo(96, 36),
      outline..strokeWidth = 6,
    );
    outline.strokeWidth = 4;
    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(26, 34, 98, 66),
      const Radius.circular(14),
    );
    canvas.drawRRect(
      body,
      Paint()
        ..shader = ui.Gradient.linear(
          const Offset(0, 34),
          const Offset(0, 100),
          const [Color(0xFF8A82F0), Color(0xFF4B45C2)],
        ),
    );
    canvas.drawRRect(body, outline);
    canvas.drawLine(const Offset(28, 62), const Offset(122, 62), outline);
    final clasp = RRect.fromRectAndRadius(
      const Rect.fromLTWH(66, 54, 18, 16),
      const Radius.circular(4),
    );
    canvas.drawRRect(clasp, Paint()..color = const Color(0xFFFFC83D));
    canvas.drawRRect(clasp, outline..strokeWidth = 3);
  }

  void _medal(Canvas canvas) {
    Path ribbon(bool left) {
      final s = left ? -1.0 : 1.0;
      return Path()
        ..moveTo(75 + s * 6, 66)
        ..lineTo(75 + s * 26, 104)
        ..lineTo(75 + s * 14, 98)
        ..lineTo(75 + s * 8, 108)
        ..lineTo(75 - s * 4, 72)
        ..close();
    }

    final ribbonPaint = Paint()..color = const Color(0xFF8E44C9);
    canvas.drawPath(ribbon(true), ribbonPaint);
    canvas.drawPath(ribbon(false), ribbonPaint);
    const c = Offset(75, 42);
    canvas.drawCircle(
      c,
      32,
      Paint()
        ..shader = ui.Gradient.linear(
          const Offset(50, 14),
          const Offset(100, 72),
          const [Color(0xFFF8A4DD), Color(0xFFC44DD6)],
        ),
    );
    canvas.drawCircle(
      c,
      32,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = const Color(0xFF7A2FB5),
    );
    canvas.drawCircle(
      c,
      20,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = Colors.white.withValues(alpha: 0.75),
    );
    // Kilau.
    canvas.drawOval(
      const Rect.fromLTWH(54, 20, 14, 8),
      Paint()..color = Colors.white.withValues(alpha: 0.55),
    );
  }

  @override
  bool shouldRepaint(covariant _FormPainter oldDelegate) =>
      oldDelegate.kind != kind;
}

/// Bintang laut oranye berwajah (kotak desain 60 x 60).
class StarfishMascot extends StatelessWidget {
  const StarfishMascot({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CustomPaint(painter: _StarfishPainter()),
    );
  }
}

class _StarfishPainter extends CustomPainter {
  const _StarfishPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 60, size.height / 60);
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final r = i.isEven ? 24.0 : 11.0;
      final a = -math.pi / 2 + i * math.pi / 5;
      final pt = Offset(30 + r * math.cos(a), 31 + r * math.sin(a));
      if (i == 0) {
        path.moveTo(pt.dx, pt.dy);
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    path.close();
    final fill = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(10, 6),
        const Offset(50, 56),
        const [Color(0xFFFFC857), Color(0xFFFF9A1F)],
      );
    final edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 7
      ..shader = fill.shader;
    canvas.drawPath(path, edge);
    canvas.drawPath(path, fill);
    final eye = Paint()..color = const Color(0xFF3A2A1A);
    canvas.drawCircle(const Offset(25, 30), 2.2, eye);
    canvas.drawCircle(const Offset(35, 30), 2.2, eye);
    canvas.drawArc(
      const Rect.fromLTWH(26, 31, 8, 6),
      0.2,
      math.pi - 0.4,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 1.6
        ..color = const Color(0xFF3A2A1A),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Kuda laut kuning (kotak desain 60 x 100).
class SeahorseMascot extends StatelessWidget {
  const SeahorseMascot({super.key, this.height = 80});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: height * 0.6,
      height: height,
      child: const CustomPaint(painter: _SeahorsePainter()),
    );
  }
}

class _SeahorsePainter extends CustomPainter {
  const _SeahorsePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 60, size.height / 100);
    const yellow = Color(0xFFFFC857);
    const orange = Color(0xFFF59E1B);
    // Badan melengkung dan ekor menggulung.
    final body = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 17
      ..color = yellow;
    final bodyPath = Path()
      ..moveTo(32, 34)
      ..cubicTo(50, 46, 46, 64, 32, 76)
      ..cubicTo(22, 86, 30, 96, 38, 90);
    canvas.drawPath(bodyPath, body);
    // Garis perut.
    final belly = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..color = orange;
    for (final y in const [48.0, 56.0, 64.0]) {
      canvas.drawArc(Rect.fromLTWH(30, y - 6, 16, 12), -0.4, 1.6, false, belly);
    }
    // Sirip punggung.
    canvas.drawPath(
      Path()
        ..moveTo(46, 50)
        ..quadraticBezierTo(58, 54, 50, 66)
        ..quadraticBezierTo(46, 60, 46, 50),
      Paint()..color = orange,
    );
    // Kepala dan moncong.
    canvas.drawCircle(const Offset(32, 24), 15, Paint()..color = yellow);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(8, 24, 22, 9),
        const Radius.circular(5),
      ),
      Paint()..color = yellow,
    );
    // Jambul.
    final crest = Paint()..color = orange;
    for (final x in const [24.0, 32.0, 40.0]) {
      canvas.drawCircle(Offset(x, 9), 3.2, crest);
    }
    // Wajah.
    canvas.drawCircle(const Offset(33, 22), 3.2, Paint()..color = Colors.white);
    canvas.drawCircle(
      const Offset(33.4, 22),
      2,
      Paint()..color = const Color(0xFF2B2B2B),
    );
    canvas.drawCircle(
      const Offset(40, 29),
      3.2,
      Paint()..color = const Color(0xFFFF8FB5).withValues(alpha: 0.7),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Kepiting merah (kotak desain 110 x 70).
///
/// Bergerak sekali saat muncul: berjalan menyamping kiri-kanan sambil
/// mengangkat capit bergantian, lalu diam. Ketuk kepiting untuk mengulang.
/// Animasinya berhenti sendiri (tidak berulang selamanya), jadi aman untuk
/// `pumpAndSettle()` pada widget test.
class CrabMascot extends StatefulWidget {
  const CrabMascot({super.key, this.width = 90});

  final double width;

  @override
  State<CrabMascot> createState() => _CrabMascotState();
}

class _CrabMascotState extends State<CrabMascot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _replay() => _controller.forward(from: 0);

  @override
  Widget build(BuildContext context) {
    final height = widget.width * 70 / 110;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _replay,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          // 0 saat diam, 1 saat paling aktif (awal dan akhir selalu diam).
          final energy = math.sin(math.pi * t);
          final dx = math.sin(t * math.pi * 4) * 0.12 * widget.width * energy;
          return Transform.translate(
            offset: Offset(dx, 0),
            child: SizedBox(
              width: widget.width,
              height: height,
              child: CustomPaint(
                painter: _CrabPainter(
                  legPhase: t * math.pi * 16,
                  clawPhase: t * math.pi * 10,
                  energy: energy,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CrabPainter extends CustomPainter {
  const _CrabPainter({
    this.legPhase = 0,
    this.clawPhase = 0,
    this.energy = 0,
  });

  final double legPhase;
  final double clawPhase;
  final double energy;

  static const Color _red = Color(0xFFE8483C);
  static const Color _light = Color(0xFFFF6A5C);
  static const Color _dark = Color(0xFFB92E26);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 110, size.height / 70);

    // Kaki: dua ruas, bergoyang bergantian saat berjalan.
    final legPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3.6
      ..color = _dark;
    for (final s in const [-1.0, 1.0]) {
      for (var i = 0; i < 3; i++) {
        final wiggle =
            math.sin(legPhase + i * 2.1 + (s > 0 ? math.pi : 0)) * 2.2 * energy;
        final y = 50.0 + i * 5;
        canvas.drawPath(
          Path()
            ..moveTo(55 + s * 26, y)
            ..lineTo(55 + s * (36 + i * 2.5), y + 3)
            ..lineTo(55 + s * (40 + i * 3), y + 11 + wiggle),
          legPaint,
        );
      }
    }

    // Lengan dan capit: capit kiri dan kanan terangkat bergantian.
    final armPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.5
      ..color = _red;
    for (final s in const [-1.0, 1.0]) {
      final lift =
          math.max(0.0, math.sin(clawPhase + (s > 0 ? math.pi : 0))) * energy;
      final claw = Offset(55 + s * 40, 26 - lift * 8);
      canvas.drawLine(Offset(55 + s * 26, 42), claw, armPaint);

      canvas.save();
      canvas.translate(claw.dx, claw.dy);
      canvas.rotate(-s * 0.4); // mulut capit menghadap ke dalam
      canvas.drawCircle(Offset.zero, 11.5, Paint()..color = _red);
      // Celah capit.
      canvas.drawPath(
        Path()
          ..moveTo(-3.4, -12)
          ..lineTo(3.4, -12)
          ..lineTo(0, -2.5)
          ..close(),
        Paint()..color = _dark,
      );
      canvas.drawCircle(
        const Offset(-4.5, 3),
        2.2,
        Paint()..color = const Color(0x55FFFFFF),
      );
      canvas.restore();
    }

    // Badan.
    canvas.drawOval(
      const Rect.fromLTWH(21, 28, 68, 38),
      Paint()
        ..shader = ui.Gradient.linear(
          const Offset(0, 28),
          const Offset(0, 66),
          const [_light, _red],
        ),
    );
    canvas.drawOval(
      const Rect.fromLTWH(36, 31, 22, 8),
      Paint()..color = const Color(0x40FFFFFF),
    );
    // Pipi merona.
    final blush = Paint()..color = const Color(0x99FF9AB0);
    canvas.drawCircle(const Offset(38, 50), 4.2, blush);
    canvas.drawCircle(const Offset(72, 50), 4.2, blush);

    // Mata di atas tangkai pendek.
    final stalk = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3
      ..color = _red;
    for (final x in const [46.0, 64.0]) {
      canvas.drawLine(Offset(x, 32), Offset(x, 24), stalk);
      canvas.drawCircle(Offset(x, 19), 7, Paint()..color = Colors.white);
      canvas.drawCircle(
        Offset(x + 0.5, 19.8),
        3.6,
        Paint()..color = const Color(0xFF222222),
      );
      canvas.drawCircle(
        Offset(x + 1.6, 18.4),
        1.2,
        Paint()..color = Colors.white,
      );
    }

    // Senyum.
    canvas.drawArc(
      const Rect.fromLTWH(48, 41, 14, 10),
      0.25,
      math.pi - 0.5,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2
        ..color = const Color(0xFF7A1D16),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CrabPainter oldDelegate) =>
      oldDelegate.legPhase != legPhase ||
      oldDelegate.clawPhase != clawPhase ||
      oldDelegate.energy != energy;
}