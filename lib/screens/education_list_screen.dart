import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_detail_screen.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/education_parts.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';

/// Filter status pada daftar pendidikan.
enum _StatusFilter {
  all('Semua'),
  active('Aktif'),
  graduated('Lulus');

  const _StatusFilter(this.label);

  final String label;
}

/// Halaman "Pendidikan" sesuai mockup: kolom pencarian, tombol filter status,
/// kartu riwayat pendidikan (logo, jenjang, periode, status), dan tombol
/// "Tambah" ungu di atas latar penyu.
///
/// Data dibaca dari [PortfolioStore.educations] sehingga daftar ikut berubah
/// setelah form disimpan.
class EducationListScreen extends StatefulWidget {
  const EducationListScreen({super.key});

  @override
  State<EducationListScreen> createState() => _EducationListScreenState();
}

class _EducationListScreenState extends State<EducationListScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  _StatusFilter _filter = _StatusFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Education> _apply(List<Education> all) {
    final query = _query.trim().toLowerCase();
    return all.where((e) {
      final matchesStatus = switch (_filter) {
        _StatusFilter.all => true,
        _StatusFilter.active => e.isCurrent,
        _StatusFilter.graduated => !e.isCurrent,
      };
      final matchesQuery =
          query.isEmpty ||
          e.institution.toLowerCase().contains(query) ||
          e.major.toLowerCase().contains(query) ||
          e.degree.toLowerCase().contains(query);
      return matchesStatus && matchesQuery;
    }).toList();
  }

  void _openForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EducationFormPage()),
    );
  }

  void _openDetail(Education education) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EducationDetailScreen(education: education),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: oceanAppBar(
        title: 'Pendidikan',
        centerTitle: true,
        actions: const [_HeaderBadge()],
      ),
      drawer: const LeftDrawer(selected: DrawerDestination.educationList),
      bottomNavigationBar: const OceanBottomBar(portfolioSelected: true),
      floatingActionButton: _AddPill(onPressed: _openForm),
      body: OceanBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
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
                            hint: 'Cari pendidikan...',
                            prefixIcon: const Icon(Icons.search),
                            radius: 28,
                          ),
                          onChanged: (value) => setState(() => _query = value),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _FilterButton(
                        value: _filter,
                        onSelected: (value) => setState(() => _filter = value),
                      ),
                    ],
                  ),
                ),
                if (_filter != _StatusFilter.all)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 0, 16, 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Filter: ${_filter.label}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: OceanColors.navy,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: ValueListenableBuilder<List<Education>>(
                    valueListenable: PortfolioStore.instance.educations,
                    builder: (context, all, child) {
                      final items = _apply(all);
                      if (items.isEmpty) {
                        return _EmptyState(
                          message: all.isEmpty
                              ? 'Belum ada riwayat pendidikan.'
                              : 'Pendidikan tidak ditemukan.',
                          hint: all.isEmpty
                              ? 'Tekan Tambah untuk menambahkannya.'
                              : 'Coba kata kunci atau filter lain.',
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 200),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final education = items[index];
                          return EducationCard(
                            education: education,
                            onTap: () => _openDetail(education),
                          );
                        },
                      );
                    },
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

/// Ikon bulat di kanan AppBar (sesuai mockup).
class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
        ),
        child: const Icon(Icons.face_outlined, color: Colors.white, size: 24),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.value, required this.onSelected});

  final _StatusFilter value;
  final ValueChanged<_StatusFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_StatusFilter>(
      key: const Key('filterButton'),
      tooltip: 'Filter status',
      initialValue: value,
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final filter in _StatusFilter.values)
          PopupMenuItem(value: filter, child: Text(filter.label)),
      ],
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: const Color(0xFFCFEAF5)),
        ),
        child: const Icon(Icons.filter_list, color: OceanColors.navy, size: 28),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message, required this.hint});

  final String message;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.school_outlined, color: OceanColors.deep, size: 40),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: OceanColors.navy,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: OceanColors.navy),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tombol "+ Tambah" berbentuk kapsul ungu (pengganti FAB bawaan).
class _AddPill extends StatelessWidget {
  const _AddPill({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('addEducationButton'),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [OceanColors.purpleStart, OceanColors.purpleEnd],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.85), width: 2),
        boxShadow: [
          BoxShadow(
            color: OceanColors.purpleEnd.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 13),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white, size: 26),
                SizedBox(width: 8),
                Text(
                  'Tambah',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
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
