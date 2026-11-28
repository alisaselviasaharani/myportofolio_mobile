import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/achievement.dart';
import 'package:myportofolio_mobile/screens/achievement_detail_screen.dart';
import 'package:myportofolio_mobile/screens/achievement_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/achievement_parts.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';
import 'package:myportofolio_mobile/widgets/portfolio_list_parts.dart';
import 'package:provider/provider.dart';

/// Halaman "Sertifikasi" (achievement) dengan tampilan yang sama seperti
/// Pendidikan: kolom pencarian, tombol filter kategori, kartu achievement,
/// dan tombol "Tambah".
///
/// Datanya diambil dari backend Django lewat [ApiClient.getAchievements].
/// Future dibuat di `initState()`; tarik ke bawah atau tekan "Coba lagi"
/// untuk memuat ulang, dan daftar dimuat ulang setelah kembali dari form.
class AchievementListScreen extends StatefulWidget {
  const AchievementListScreen({super.key});

  @override
  State<AchievementListScreen> createState() => _AchievementListScreenState();
}

class _AchievementListScreenState extends State<AchievementListScreen> {
  final _searchController = TextEditingController();
  late Future<List<Achievement>> _achievementsFuture;
  String _query = '';

  /// `null` berarti semua kategori.
  AchievementCategory? _categoryFilter;

  @override
  void initState() {
    super.initState();
    _achievementsFuture = _fetch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Mengambil achievement dari Django dan menyamakan jumlah di beranda.
  Future<List<Achievement>> _fetch() async {
    final achievements = await context.read<ApiClient>().getAchievements();
    PortfolioStore.instance.achievements.value = achievements;
    return achievements;
  }

  Future<void> _reload() async {
    final future = _fetch();
    // Pakai blok `{}` (bukan `=>`): `=>` mengembalikan Future hasil assignment,
    // dan setState melempar error jika callback-nya mengembalikan Future.
    setState(() {
      _achievementsFuture = future;
    });
    try {
      await future;
    } catch (_) {
      // Error ditampilkan oleh FutureBuilder.
    }
  }

  Future<void> _openForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AchievementFormPage(popOnSuccess: true),
      ),
    );
    if (mounted) {
      await _reload();
    }
  }

  void _openDetail(Achievement achievement) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AchievementDetailScreen(achievement: achievement),
      ),
    );
  }

  List<Achievement> _apply(List<Achievement> all) {
    final query = _query.trim().toLowerCase();
    return all.where((a) {
      final matchesCategory =
          _categoryFilter == null || a.category == _categoryFilter;
      final matchesQuery =
          query.isEmpty ||
          a.title.toLowerCase().contains(query) ||
          a.description.toLowerCase().contains(query) ||
          a.category.label.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: oceanAppBar(
        title: 'Sertifikasi',
        centerTitle: true,
        actions: const [PortfolioHeaderBadge()],
      ),
      drawer: const LeftDrawer(selected: DrawerDestination.certificationList),
      bottomNavigationBar: const OceanBottomBar(portfolioSelected: true),
      floatingActionButton: PortfolioAddPill(
        buttonKey: const Key('addAchievementButton'),
        onPressed: _openForm,
      ),
      body: OceanBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: FutureBuilder<List<Achievement>>(
              future: _achievementsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return PortfolioErrorState(
                    message: 'Gagal memuat sertifikasi.',
                    onRetry: _reload,
                  );
                }
                final all = snapshot.data ?? const <Achievement>[];
                final items = _apply(all);
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, top + 6, 16, 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              key: const Key('searchField'),
                              controller: _searchController,
                              textInputAction: TextInputAction.search,
                              decoration: oceanInputDecoration(
                                hint: 'Cari sertifikasi...',
                                prefixIcon: const Icon(Icons.search),
                                radius: 28,
                              ),
                              onChanged: (value) =>
                                  setState(() => _query = value),
                            ),
                          ),
                          const SizedBox(width: 10),
                          PortfolioFilterButton<AchievementCategory?>(
                            value: _categoryFilter,
                            options: [null, ...AchievementCategory.values],
                            tooltip: 'Filter kategori',
                            labelOf: (category) =>
                                category == null ? 'Semua' : category.label,
                            onSelected: (value) =>
                                setState(() => _categoryFilter = value),
                          ),
                        ],
                      ),
                    ),
                    if (_categoryFilter != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 0, 16, 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Filter: ${_categoryFilter!.label}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: OceanColors.navy,
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: items.isEmpty
                          ? PortfolioEmptyState(
                              icon: Icons.workspace_premium_outlined,
                              message: all.isEmpty
                                  ? 'Belum ada sertifikasi.'
                                  : 'Sertifikasi tidak ditemukan.',
                              hint: all.isEmpty
                                  ? 'Tekan Tambah untuk menambahkannya.'
                                  : 'Coba kata kunci atau filter lain.',
                            )
                          : RefreshIndicator(
                              onRefresh: _reload,
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  8,
                                  16,
                                  200,
                                ),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final achievement = items[index];
                                  return AchievementCard(
                                    achievement: achievement,
                                    onTap: () => _openDetail(achievement),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
