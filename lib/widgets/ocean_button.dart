import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';

/// Tombol utama selebar penuh berbentuk kapsul bergradasi tosca, dengan ikon
/// opsional di kiri label.
class OceanButton extends StatelessWidget {
  const OceanButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.colors = const [OceanColors.buttonStart, OceanColors.buttonEnd],
    this.shadowColor = OceanColors.deep,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  /// Warna gradasi tombol (kiri ke kanan); bawaan tosca.
  final List<Color> colors;

  /// Warna bayangan tombol.
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 26, color: Colors.white),
                  const SizedBox(width: 10),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
