import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_detail_screen.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/experience_parts.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';
import 'package:myportofolio_mobile/widgets/portfolio_list_parts.dart';
import 'package:provider/provider.dart';

/// Halaman "Pengalaman" dengan tampilan yang sama seperti Pendidikan: kolom
/// pencarian, tombol filter tipe, kartu experience, dan tombol "Tambah".
///
/// Datanya diambil dari backend Django lewat [ApiClient.getExperiences].
/// Future dibuat di `initState()` (bukan di `build()`) agar permintaan HTTP
/// tidak dikirim ulang setiap widget dibangun ulang. Tarik ke bawah atau
/// tekan "Coba lagi" untuk memuat ulang; daftar juga dimuat ulang otomatis
/// setelah kembali dari form Tambah.
class ExperienceListScreen extends StatefulWidget {
  const ExperienceListScreen({super.key});

  @override
  State<ExperienceListScreen> createState() => _ExperienceListScreenState();
}

class _ExperienceListScreenState extends State<ExperienceListScreen> {
  /// Nilai filter untuk "semua tipe".
  static const String _allTypes = '';

  final _searchController = TextEditingController();
  late Future<List<Experience>> _experiencesFuture;
  String _query = '';
  String _typeFilter = _allTypes;

  @override
  void initState() {
    super.initState();
    _experiencesFuture = _fetch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Mengambil experience dari Django dan menyamakan jumlah di beranda.
  Future<List<Experience>> _fetch() async {
    final experiences = await context.read<ApiClient>().getExperiences();
    PortfolioStore.instance.experienceCount.value = experiences.length;
    return experiences;
  }

  Future<void> _reload() async {
    final future = _fetch();
    // Pakai blok `{}` (bukan `=>`): `=>` mengembalikan Future hasil assignment,
    // dan setState melempar error jika callback-nya mengembalikan Future.
    setState(() {
      _experiencesFuture = future;
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
        builder: (context) => const ExperienceFormPage(popOnSuccess: true),
      ),
    );
    if (mounted) {
      await _reload();
    }
  }

  /// Membuka detail; setelah kembali, daftar dimuat ulang agar hasil edit
  /// atau hapus langsung terlihat.
  Future<void> _openDetail(Experience experience) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExperienceDetailScreen(experience: experience),
      ),
    );
    if (mounted) {
      await _reload();
    }
  }

  List<Experience> _apply(List<Experience> all) {
    final query = _query.trim().toLowerCase();
    return all.where((e) {
      final matchesType = _typeFilter == _allTypes || e.type == _typeFilter;
      final matchesQuery =
          query.isEmpty ||
          e.position.toLowerCase().contains(query) ||
          e.company.toLowerCase().contains(query) ||
          e.type.toLowerCase().contains(query);
      return matchesType && matchesQuery;
    }).toList();
  }

  /// Tipe yang ada pada data, diurutkan, untuk menu filter.
  List<String> _typesIn(List<Experience> all) {
    final types = {
      for (final e in all)
        if (e.type.isNotEmpty) e.type,
    }.toList()..sort();
    return [_allTypes, ...types];
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: oceanAppBar(
        title: 'Pengalaman',
        centerTitle: true,
        actions: const [PortfolioHeaderBadge()],
      ),
      drawer: const LeftDrawer(selected: DrawerDestination.experienceList),
      bottomNavigationBar: const OceanBottomBar(portfolioSelected: true),
      floatingActionButton: PortfolioAddPill(
        buttonKey: const Key('addExperienceButton'),
        onPressed: _openForm,
      ),
      body: OceanBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: FutureBuilder<List<Experience>>(
              future: _experiencesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return PortfolioErrorState(
                    message: 'Gagal memuat pengalaman.',
                    onRetry: _reload,
                  );
                }
                final all = snapshot.data ?? const <Experience>[];
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
                                hint: 'Cari pengalaman...',
                                prefixIcon: const Icon(Icons.search),
                                radius: 28,
                              ),
                              onChanged: (value) =>
                                  setState(() => _query = value),
                            ),
                          ),
                          const SizedBox(width: 10),
                          PortfolioFilterButton<String>(
                            value: _typeFilter,
                            options: _typesIn(all),
                            tooltip: 'Filter tipe',
                            labelOf: (type) =>
                                type == _allTypes ? 'Semua' : type,
                            onSelected: (value) =>
                                setState(() => _typeFilter = value),
                          ),
                        ],
                      ),
                    ),
                    if (_typeFilter != _allTypes)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 0, 16, 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Filter: $_typeFilter',
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
                              icon: Icons.work_outline,
                              message: all.isEmpty
                                  ? 'Belum ada pengalaman.'
                                  : 'Pengalaman tidak ditemukan.',
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
                                  final experience = items[index];
                                  return ExperienceCard(
                                    experience: experience,
                                    onTap: () => _openDetail(experience),
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
