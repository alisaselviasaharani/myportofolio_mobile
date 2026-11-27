import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// Bendera bulat Indonesia (merah-putih).
class IndonesiaFlag extends StatelessWidget {
  const IndonesiaFlag({super.key, this.size = 46});

  final double size;

  @override
  Widget build(BuildContext context) {
    return _FlagCircle(
      size: size,
      child: const Column(
        children: [
          Expanded(child: ColoredBox(color: Color(0xFFE53935), child: SizedBox.expand())),
          Expanded(child: ColoredBox(color: Colors.white, child: SizedBox.expand())),
        ],
      ),
    );
  }
}

/// Bendera bulat Inggris (Union Jack), disusun dari bidang dan batang berputar.
class UkFlag extends StatelessWidget {
  const UkFlag({super.key, this.size = 46});

  final double size;

  @override
  Widget build(BuildContext context) {
    final long = size * 1.6;
    Widget bar(double angle, double thickness, Color color) => Center(
      child: Transform.rotate(
        angle: angle,
        child: Container(width: long, height: thickness, color: color),
      ),
    );
    return _FlagCircle(
      size: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Color(0xFF1F3A93)),
          bar(math.pi / 4, size * 0.2, Colors.white),
          bar(-math.pi / 4, size * 0.2, Colors.white),
          bar(math.pi / 4, size * 0.07, const Color(0xFFD32F2F)),
          bar(-math.pi / 4, size * 0.07, const Color(0xFFD32F2F)),
          bar(0, size * 0.32, Colors.white),
          bar(math.pi / 2, size * 0.32, Colors.white),
          bar(0, size * 0.18, const Color(0xFFD32F2F)),
          bar(math.pi / 2, size * 0.18, const Color(0xFFD32F2F)),
        ],
      ),
    );
  }
}

class _FlagCircle extends StatelessWidget {
  const _FlagCircle({required this.size, required this.child});

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(child: child),
    );
  }
}
