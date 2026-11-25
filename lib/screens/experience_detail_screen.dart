import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';

/// Detail satu experience terpilih.
///
/// Periode dan tautan hanya ditampilkan jika tidak kosong.
class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({super.key, required this.experience});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: oceanAppBar(title: 'Experience Detail'),
      body: OceanBackground(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, top + 16, 16, 28),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.78),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        experience.position,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: OceanColors.navy,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _DetailRow(
                        icon: Icons.business_outlined,
                        label: 'Company',
                        value: experience.company,
                      ),
                      if (experience.type.isNotEmpty)
                        _DetailRow(
                          icon: Icons.category_outlined,
                          label: 'Type',
                          value: experience.type,
                        ),
                      if (experience.period.isNotEmpty)
                        _DetailRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Period',
                          value: experience.period,
                        ),
                      _DetailRow(
                        icon: Icons.notes_outlined,
                        label: 'Description',
                        value: experience.description,
                      ),
                      if (experience.link.isNotEmpty)
                        _DetailRow(
                          icon: Icons.link,
                          label: 'Link',
                          value: experience.link,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: OceanColors.deep, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: OceanColors.deep,
                  ),
                ),
                SelectableText(
                  value,
                  style: const TextStyle(fontSize: 15, color: OceanColors.navy),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
