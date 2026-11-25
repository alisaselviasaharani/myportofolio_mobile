import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_detail_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:provider/provider.dart';

/// Daftar experience yang diambil dari backend Django lewat [ApiClient].
///
/// Future dibuat di `initState()` (bukan di `build()`) agar permintaan HTTP
/// tidak dikirim ulang setiap widget dibangun ulang. Tarik ke bawah
/// ([RefreshIndicator]) atau tombol Retry untuk memuat ulang.
class ExperienceListScreen extends StatefulWidget {
  const ExperienceListScreen({super.key});

  @override
  State<ExperienceListScreen> createState() => _ExperienceListScreenState();
}

class _ExperienceListScreenState extends State<ExperienceListScreen> {
  late Future<List<Experience>> _experiencesFuture;

  @override
  void initState() {
    super.initState();
    _experiencesFuture = context.read<ApiClient>().getExperiences();
  }

  Future<void> _reload() async {
    final future = context.read<ApiClient>().getExperiences();
    setState(() {
      _experiencesFuture = future;
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: oceanAppBar(title: 'My Experience'),
      drawer: const LeftDrawer(selected: DrawerDestination.experienceList),
      body: OceanBackground(
        child: FutureBuilder<List<Experience>>(
          future: _experiencesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, top, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Failed to load experiences: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: OceanColors.navy),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _reload,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final experiences = snapshot.data ?? const <Experience>[];

            if (experiences.isEmpty) {
              // Tetap bisa pull-to-refresh walau daftar kosong.
              return RefreshIndicator(
                onRefresh: _reload,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.8,
                    child: const Center(
                      child: Text(
                        'No experiences found.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: OceanColors.navy,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _reload,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16, top + 12, 16, 24),
                    itemCount: experiences.length,
                    itemBuilder: (context, index) {
                      final experience = experiences[index];
                      return _ExperienceCard(
                        experience: experience,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExperienceDetailScreen(experience: experience),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Kartu satu experience: posisi, perusahaan + tipe, dan deskripsi singkat.
class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.experience, required this.onTap});

  final Experience experience;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      experience.company,
      if (experience.type.isNotEmpty) experience.type,
    ].join(' • ');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
        boxShadow: [
          BoxShadow(
            color: OceanColors.deep.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: OceanColors.cardPurple,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.work,
                    color: Color(0xFF4A56C4),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        experience.position,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: OceanColors.navy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: OceanColors.deep,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        experience.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
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
