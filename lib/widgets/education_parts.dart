import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/institution_assets.dart';

/// Lencana bulat logo institusi (logo UI jika dikenali, selain itu ikon
/// sekolah di atas gradasi biru).
class InstitutionBadge extends StatelessWidget {
  const InstitutionBadge({
    super.key,
    required this.institution,
    this.size = 62,
  });

  final String institution;
  final double size;

  @override
  Widget build(BuildContext context) {
    final logo = institutionLogoAsset(institution);
    final fallback = DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [OceanColors.teal, OceanColors.deep],
        ),
      ),
      child: Center(
        child: Icon(Icons.school, color: Colors.white, size: size * 0.5),
      ),
    );
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: OceanColors.deep.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: logo == null
            ? fallback
            : Image.asset(
                logo,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => fallback,
              ),
      ),
    );
  }
}

/// Label status hijau kecil: `Aktif` atau `Lulus`.
class EducationStatusChip extends StatelessWidget {
  const EducationStatusChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      decoration: BoxDecoration(
        color: OceanColors.chipGreenBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: OceanColors.chipGreenText,
        ),
      ),
    );
  }
}

/// Kartu satu riwayat pendidikan (logo, institusi, jenjang, periode, status),
/// dipakai di halaman Daftar dan Favorit.
class EducationCard extends StatelessWidget {
  const EducationCard({
    super.key,
    required this.education,
    required this.onTap,
  });

  final Education education;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.9),
            const Color(0xFFD9F1FA).withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: OceanColors.deep.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(26),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
            child: Row(
              children: [
                InstitutionBadge(institution: education.institution),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        education.institution,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: OceanColors.navy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        education.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: OceanColors.navy,
                        ),
                      ),
                      Text(
                        education.period,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: OceanColors.navy,
                        ),
                      ),
                      const SizedBox(height: 6),
                      EducationStatusChip(label: education.statusLabel),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: OceanColors.navy,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
