import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/illustrations.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/mascots.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/page_parts.dart';

/// Halaman "My Skills": maskot, lalu tiga kartu kemampuan
/// (Technical Skills, Soft Skills, Tools & Others).
class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  static const List<_Skill> _technical = [
    _Skill('Flutter', Icons.flutter_dash, Color(0xFF1E88E5)),
    _Skill('Python', null, Color(0xFF3776AB), badge: 'Py'),
    _Skill('Java', Icons.coffee, Color(0xFFE53935)),
    _Skill('Django', null, Color(0xFF0C4B33), badge: 'dj'),
    _Skill('HTML', null, Color(0xFFE44D26), badge: '5'),
    _Skill('CSS', null, Color(0xFF1572B6), badge: '3'),
    _Skill('JavaScript', null, Color(0xFFF0B800), badge: 'JS'),
    _Skill('Git', Icons.call_split, Color(0xFFF05033)),
  ];

  static const List<_Skill> _soft = [
    _Skill('Teamwork', Icons.groups, Color(0xFF6A4FC4)),
    _Skill('Communication', Icons.chat_bubble, Color(0xFFFFA726)),
    _Skill('Problem Solving', Icons.lightbulb, Color(0xFFFFC107)),
    _Skill('Time Management', Icons.schedule, Color(0xFF3F3DA8)),
    _Skill('Adaptability', Icons.eco, Color(0xFF43A047)),
    _Skill('Creativity', Icons.favorite, Color(0xFFEC407A)),
    _Skill('Leadership', Icons.military_tech, Color(0xFFF9A825)),
    _Skill('Collaboration', Icons.handshake, Color(0xFF7E57C2)),
  ];

  static const List<_Skill> _tools = [
    _Skill('GitHub', Icons.pets, Color(0xFF24292F)),
    _Skill('VS Code', Icons.code, Color(0xFF1E88E5)),
    _Skill('Figma', Icons.design_services, Color(0xFFF24E1E)),
    _Skill('Trello', Icons.view_kanban, Color(0xFF0079BF)),
  ];

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: oceanAppBar(
        title: 'My Portfolio',
        centerTitle: true,
        actions: const [OceanAvatarAction()],
      ),
      drawer: const LeftDrawer(selected: DrawerDestination.skills),
      body: OceanBackground(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, top + 10, 16, 28),
                child: Column(
                  children: [
                    const HeroBanner(
                      mascotAsset: 'assets/images/nailong_popcorn.gif',
                      mascotWidth: 118,
                      sparkles: true,
                      title: 'My Skills',
                      subtitle: 'Kumpulan kemampuan yang saya miliki '
                          'dan terus saya kembangkan.',
                      decoration: ClownfishMascot(width: 48),
                    ),
                    const SizedBox(height: 14),
                    const _SkillSection(
                      icon: Icons.code,
                      title: 'Technical Skills',
                      colors: [Color(0xFF6C4FD8), Color(0xFF8E6CF0)],
                      skills: _technical,
                    ),
                    const SizedBox(height: 14),
                    const _SkillSection(
                      icon: Icons.groups,
                      title: 'Soft Skills',
                      colors: [Color(0xFFE0409A), Color(0xFFF26BB8)],
                      skills: _soft,
                    ),
                    const SizedBox(height: 14),
                    const _SkillSection(
                      icon: Icons.settings,
                      title: 'Tools & Others',
                      colors: [OceanColors.buttonStart, OceanColors.buttonEnd],
                      skills: _tools,
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StarfishMascot(size: 52),
                        StarfishMascot(size: 44),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Data satu skill: nama, ikon (atau [badge] teks untuk logo bahasa), warna.
class _Skill {
  const _Skill(this.name, this.icon, this.color, {this.badge});

  final String name;
  final IconData? icon;
  final Color color;
  final String? badge;
}

/// Satu kartu bagian: pil judul berwarna + grid 4 kolom skill.
class _SkillSection extends StatelessWidget {
  const _SkillSection({
    required this.icon,
    required this.title,
    required this.colors,
    required this.skills,
  });

  final IconData icon;
  final String title;
  final List<Color> colors;
  final List<_Skill> skills;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
      child: Column(
        children: [
          SectionPill(icon: icon, title: title, colors: colors, expand: true),
          const SizedBox(height: 10),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.82,
            children: [for (final s in skills) _SkillTile(skill: s)],
          ),
        ],
      ),
    );
  }
}

class _SkillTile extends StatelessWidget {
  const _SkillTile({required this.skill});

  final _Skill skill;

  @override
  Widget build(BuildContext context) {
    final badge = skill.badge;
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 6, 2, 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCFEAF5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 34,
            child: Center(
              child: badge != null
                  ? Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: skill.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          fontSize: badge.length > 1 ? 14 : 18,
                          fontWeight: FontWeight.w800,
                          color: skill.color == const Color(0xFFF0B800)
                              ? Colors.black87
                              : Colors.white,
                        ),
                      ),
                    )
                  : Icon(skill.icon, color: skill.color, size: 32),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            skill.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10.5,
              height: 1.1,
              fontWeight: FontWeight.w700,
              color: OceanColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}
