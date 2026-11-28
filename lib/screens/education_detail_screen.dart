import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/institution_assets.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/widgets/delete_flow.dart';
import 'package:myportofolio_mobile/widgets/education_parts.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';

/// Halaman "Detail Pendidikan" sesuai mockup: foto kampus dengan tombol
/// edit dan bagikan, lencana logo, tabel info (Jenjang, Program Studi,
/// Periode, Status), Deskripsi, dan chip Mata Kuliah Relevan.
///
/// Tombol edit membuka [EducationFormPage] berisi data ini; hasilnya
/// langsung tampil di halaman. Tombol bagikan menyalin ringkasan ke clipboard.
class EducationDetailScreen extends StatefulWidget {
  const EducationDetailScreen({super.key, required this.education});

  final Education education;

  @override
  State<EducationDetailScreen> createState() => _EducationDetailScreenState();
}

class _EducationDetailScreenState extends State<EducationDetailScreen> {
  late Education _education;

  @override
  void initState() {
    super.initState();
    _education = widget.education;
  }

  Future<void> _edit() async {
    final updated = await Navigator.push<Education>(
      context,
      MaterialPageRoute(
        builder: (context) => EducationFormPage(education: _education),
      ),
    );
    if (updated != null && mounted) {
      setState(() => _education = updated);
    }
  }

  Future<void> _delete() async {
    final deleted = await confirmAndDelete(
      context,
      title: 'Hapus pendidikan?',
      message:
          '${_education.institution} akan dihapus dari server dan tidak bisa '
          'dikembalikan.',
      successMessage: 'Pendidikan dihapus.',
      request: (api, token) => api.deleteEducation(_education, token: token),
    );
    if (deleted && mounted) {
      PortfolioStore.instance.removeEducation(_education);
      Navigator.pop(context, true);
    }
  }

  void _share() {
    final e = _education;
    final text = [
      e.institution,
      e.subtitle,
      '${e.period} (${e.statusLabel})',
    ].join('\n');
    showInfoSnackBar(context, 'Ringkasan pendidikan disalin ke clipboard.');
    unawaited(Clipboard.setData(ClipboardData(text: text)).catchError((_) {}));
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;
    final e = _education;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: oceanAppBar(title: 'Detail Pendidikan', centerTitle: true),
      bottomNavigationBar: const OceanBottomBar(portfolioSelected: true),
      body: OceanBackground(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, top + 6, 16, 130),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.86),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                        color: OceanColors.deep.withValues(alpha: 0.12),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder<List<Education>>(
                        valueListenable: PortfolioStore.instance.favorites,
                        builder: (context, favorites, child) => _Hero(
                          institution: e.institution,
                          isFavorite: favorites.contains(e),
                          onFavorite: () =>
                              PortfolioStore.instance.toggleFavorite(e),
                          onEdit: _edit,
                          onDelete: _delete,
                          onShare: _share,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.institution,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: OceanColors.navy,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _InfoTable(education: e),
                            if (e.description.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              const _SectionTitle('Deskripsi'),
                              const SizedBox(height: 4),
                              SelectableText(
                                e.description,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.35,
                                  color: OceanColors.navy,
                                ),
                              ),
                            ],
                            if (e.courses.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              const _SectionTitle('Mata Kuliah Relevan'),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                runSpacing: 8,
                                children: [
                                  for (final course in e.courses)
                                    _CourseChip(course),
                                ],
                              ),
                            ],
                          ],
                        ),
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

/// Foto kampus berujung membulat, tombol edit/bagikan di kanan atas, dan
/// lencana logo yang menumpuk di kiri bawah foto.
class _Hero extends StatelessWidget {
  const _Hero({
    required this.institution,
    required this.isFavorite,
    required this.onFavorite,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
  });

  final String institution;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  static const double _photoHeight = 160;
  static const double _badgeSize = 68;
  static const double _overlap = 34;

  @override
  Widget build(BuildContext context) {
    final photo = institutionPhotoAsset(institution);
    final placeholder = DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [OceanColors.aqua, OceanColors.teal],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.school,
          size: 64,
          color: Colors.white.withValues(alpha: 0.85),
        ),
      ),
    );
    return SizedBox(
      height: 8 + _photoHeight + _overlap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            height: _photoHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: photo == null
                  ? placeholder
                  : Image.asset(
                      photo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => placeholder,
                    ),
            ),
          ),
          Positioned(
            top: 18,
            right: 18,
            child: Row(
              children: [
                _RoundAction(
                  icon: isFavorite ? Icons.star : Icons.star_border,
                  tooltip: isFavorite
                      ? 'Hapus dari favorit'
                      : 'Tambah ke favorit',
                  onTap: onFavorite,
                ),
                const SizedBox(width: 8),
                _RoundAction(
                  icon: Icons.edit_outlined,
                  tooltip: 'Edit pendidikan',
                  onTap: onEdit,
                ),
                const SizedBox(width: 8),
                _RoundAction(
                  key: const Key('deleteButton'),
                  icon: Icons.delete_outline,
                  tooltip: 'Hapus pendidikan',
                  onTap: onDelete,
                ),
                const SizedBox(width: 8),
                _RoundAction(
                  icon: Icons.ios_share,
                  tooltip: 'Bagikan',
                  onTap: onShare,
                ),
              ],
            ),
          ),
          Positioned(
            left: 12,
            bottom: 0,
            child: InstitutionBadge(
              institution: institution,
              size: _badgeSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withValues(alpha: 0.95),
        elevation: 2,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: OceanColors.navy, size: 22),
          ),
        ),
      ),
    );
  }
}

class _InfoTable extends StatelessWidget {
  const _InfoTable({required this.education});

  final Education education;

  @override
  Widget build(BuildContext context) {
    final e = education;
    final rows = <Widget>[
      _InfoRow(
        icon: Icons.school_outlined,
        label: 'Jenjang',
        value: e.level.fullLabel,
      ),
      if (e.major.isNotEmpty)
        _InfoRow(
          icon: Icons.menu_book_outlined,
          label: 'Program Studi',
          value: e.major,
        ),
      _InfoRow(
        icon: Icons.calendar_month_outlined,
        label: 'Periode',
        value: e.period,
      ),
      _InfoRow(
        icon: Icons.verified_outlined,
        label: 'Status',
        value: e.statusLabel,
        valueColor: OceanColors.statusGreen,
        valueKey: const Key('detailStatus'),
      ),
      if (e.website.isNotEmpty)
        _InfoRow(icon: Icons.link, label: 'Website', value: e.website),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: Color(0xFFD5EAF4)),
            rows[i],
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = OceanColors.navy,
    this.valueKey,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: OceanColors.navy, size: 22),
          const SizedBox(width: 10),
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: OceanColors.navy,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              key: valueKey,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: OceanColors.navy,
      ),
    );
  }
}

class _CourseChip extends StatelessWidget {
  const _CourseChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: OceanColors.courseChip,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: OceanColors.navy,
        ),
      ),
    );
  }
}
