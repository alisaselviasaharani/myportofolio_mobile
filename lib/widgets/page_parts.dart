import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';

/// Foto profil kecil di kanan AppBar (dipakai halaman Skills dan Contact).
class OceanAvatarAction extends StatelessWidget {
  const OceanAvatarAction({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 14.0),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Color(0xCCFFFFFF),
        child: CircleAvatar(
          radius: 19,
          backgroundImage: AssetImage('assets/images/alisa.png'),
        ),
      ),
    );
  }
}

/// Banner di atas halaman: maskot GIF di kiri, judul dan subjudul di kanan,
class HeroBanner extends StatelessWidget {
  const HeroBanner({
    super.key,
    required this.mascotAsset,
    required this.mascotWidth,
    required this.title,
    required this.subtitle,
    this.sparkles = false,
    this.decoration,
  });

  /// Lokasi GIF/gambar maskot (harus terdaftar di `pubspec.yaml`).
  final String mascotAsset;
  final double mascotWidth;
  final String title;
  final String subtitle;
  final bool sparkles;
  final Widget? decoration;

  @override
  Widget build(BuildContext context) {
    const sparkle = Icon(
      Icons.auto_awesome,
      color: Color(0xFFFFC928),
      size: 22,
    );
    final align = sparkles
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 150),
          padding: const EdgeInsets.fromLTRB(150, 18, 14, 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.55),
                const Color(0xFFBFEFFC).withValues(alpha: 0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
            boxShadow: [
              BoxShadow(
                color: OceanColors.deep.withValues(alpha: 0.12),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: align,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: sparkles ? Alignment.center : Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (sparkles) ...[sparkle, const SizedBox(width: 6)],
                    Text(
                      title,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: OceanColors.navy,
                      ),
                    ),
                    if (sparkles) ...[const SizedBox(width: 6), sparkle],
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: sparkles ? TextAlign.center : TextAlign.left,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                  color: OceanColors.navy,
                ),
              ),
            ],
          ),
        ),
        // Maskot di kiri, sedikit menonjol keluar banner.
        Positioned(
          left: 6,
          top: 0,
          bottom: 0,
          child: Center(
            child: Image.asset(
              mascotAsset,
              width: mascotWidth,
              fit: BoxFit.contain,
              gaplessPlayback: true,
            ),
          ),
        ),
        if (decoration != null)
          Positioned(right: 10, top: -14, child: decoration!),
      ],
    );
  }
}

/// Panel kaca yang membungkus satu bagian halaman.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(10),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: OceanColors.deep.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Pil judul bagian berwarna (ikon + teks), dengan lebar mengikuti isi atau
/// selebar penuh jika [expand] `true`.
class SectionPill extends StatelessWidget {
  const SectionPill({
    super.key,
    required this.icon,
    required this.title,
    required this.colors,
    this.expand = false,
  });

  final IconData icon;
  final String title;
  final List<Color> colors;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: expand ? double.infinity : null,
        padding: const EdgeInsets.fromLTRB(8, 6, 16, 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.25),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
