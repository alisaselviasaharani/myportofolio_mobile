import 'package:material_ui/material_ui.dart';

/// Latar bawah laut di belakang [child].
///
/// Memakai gambar `assets/images/ocean_bg.jpg` (dasar laut dengan penyu dan
/// bintang laut di bagian bawah). Lapisan putih kebiruan menutupi bagian atas
/// dan tengah agar kartu mudah dibaca, sementara dasar laut di bawah tetap
/// terlihat. Jika aset gagal dimuat, ditampilkan gradasi biru sebagai cadangan.
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
            alignment: Alignment.bottomCenter,
            errorBuilder: (context, error, stackTrace) =>
                const _GradientFallback(),
          ),
        ),
        // Kabut pucat: pekat di atas, memudar menuju dasar laut.
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.6, 0.85, 1.0],
                colors: [
                  Color(0xEBC3EEFA),
                  Color(0xEBD5F2FC),
                  Color(0xB3D5F2FC),
                  Color(0x00D5F2FC),
                ],
              ),
            ),
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
