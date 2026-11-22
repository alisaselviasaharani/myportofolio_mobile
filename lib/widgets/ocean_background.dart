import 'package:material_ui/material_ui.dart';

/// Latar bawah laut di belakang [child].
///
/// Memakai gambar `assets/images/ocean_bg.jpg`. Jika aset gagal dimuat,
/// ditampilkan gradasi biru sebagai cadangan.
class OceanBackground extends StatelessWidget {
  const OceanBackground({super.key, required this.child});

  final Widget child;

  /// Lokasi gambar latar (harus terdaftar di `pubspec.yaml`).
  static const String assetPath = 'assets/images/ocean_bg.jpg';

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const _GradientFallback(),
          ),
        ),
        child,
      ],
    );
  }
}

class _GradientFallback extends StatelessWidget {
  const _GradientFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE3F7FF), Color(0xFFBCEBF8), Color(0xFF93DAEE)],
        ),
      ),
    );
  }
}
