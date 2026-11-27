import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';

/// Satu baris menu Pengaturan berbentuk pil: ikon, judul, subjudul opsional,
/// dan panah di kanan. Dengan [destructive] teks/ikon merah dan tanpa panah
/// (dipakai untuk "Keluar").
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool destructive;

  static const Color _red = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final color = destructive ? _red : OceanColors.navy;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xF2FFFFFF), Color(0xD9E3F6FD)],
        ),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: OceanColors.deep.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 18,
              vertical: subtitle == null ? 12 : 8,
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 30),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: OceanColors.navy,
                          ),
                        ),
                    ],
                  ),
                ),
                if (!destructive)
                  const Icon(
                    Icons.chevron_right,
                    color: OceanColors.navy,
                    size: 30,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
