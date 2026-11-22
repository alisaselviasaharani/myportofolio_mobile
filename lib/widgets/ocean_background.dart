import 'package:material_ui/material_ui.dart';

/// Latar bergradasi laut dengan gelembung dekoratif di belakang [child].
class OceanBackground extends StatelessWidget {
  const OceanBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE3F7FF), Color(0xFFBCEBF8), Color(0xFF93DAEE)],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gelembung tidak boleh menangkap sentuhan.
          const IgnorePointer(
            child: Stack(
              children: [
                Positioned(top: 40, right: 28, child: _Bubble(size: 22)),
                Positioned(top: 170, left: 16, child: _Bubble(size: 14)),
                Positioned(bottom: 140, right: 36, child: _Bubble(size: 18)),
                Positioned(bottom: 50, left: 28, child: _Bubble(size: 26)),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.25),
        border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
      ),
    );
  }
}
