import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/achievement.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/education_parts.dart';

/// Ikon yang mewakili tiap kategori achievement.
IconData achievementCategoryIcon(AchievementCategory category) {
  return switch (category) {
    AchievementCategory.academic => Icons.school,
    AchievementCategory.competition => Icons.emoji_events,
    AchievementCategory.certification => Icons.workspace_premium,
    AchievementCategory.award => Icons.military_tech,
    AchievementCategory.other => Icons.star,
  };
}

/// Lencana bulat achievement: gambar dari Django (`achievements_image_url`)
/// jika ada dan bisa dimuat, selain itu ikon kategori di atas gradasi ungu.
class AchievementBadge extends StatelessWidget {
  const AchievementBadge({
    super.key,
    required this.achievement,
    this.size = 62,
  });

  final Achievement achievement;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fallback = DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [OceanColors.purpleStart, OceanColors.purpleEnd],
        ),
      ),
      child: Center(
        child: Icon(
          achievementCategoryIcon(achievement.category),
          color: Colors.white,
          size: size * 0.5,
        ),
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
        child: achievement.imageUrl.isEmpty
            ? fallback
            : Image.network(
                achievement.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => fallback,
              ),
      ),
    );
  }
}

/// Kartu satu achievement (lencana, judul, periode, kategori), gayanya sama
/// dengan [EducationCard].
class AchievementCard extends StatelessWidget {
  const AchievementCard({
    super.key,
    required this.achievement,
    required this.onTap,
  });

  final Achievement achievement;
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
                AchievementBadge(achievement: achievement),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: OceanColors.navy,
                        ),
                      ),
                      if (achievement.period.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          achievement.period,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: OceanColors.navy,
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      EducationStatusChip(label: achievement.category.label),
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
