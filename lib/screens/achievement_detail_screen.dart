import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/achievement.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/widgets/achievement_parts.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';
import 'package:myportofolio_mobile/widgets/portfolio_list_parts.dart';

/// Halaman "Detail Sertifikasi" bergaya sama dengan Detail Pendidikan:
/// gambar achievement dari Django (atau panel gradasi jika kosong), tombol
/// bagikan, lencana, tabel info (Kategori, Periode), dan Deskripsi.
class AchievementDetailScreen extends StatelessWidget {
  const AchievementDetailScreen({super.key, required this.achievement});

  final Achievement achievement;

  void _share(BuildContext context) {
    final a = achievement;
    final text = [
      a.title,
      a.category.label,
      if (a.period.isNotEmpty) a.period,
    ].join('\n');
    showInfoSnackBar(context, 'Ringkasan sertifikasi disalin ke clipboard.');
    unawaited(Clipboard.setData(ClipboardData(text: text)).catchError((_) {}));
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;
    final a = achievement;
    const gradient = [OceanColors.purpleStart, OceanColors.purpleEnd];
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: oceanAppBar(title: 'Detail Sertifikasi', centerTitle: true),
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
                      PortfolioDetailHero(
                        icon: achievementCategoryIcon(a.category),
                        colors: gradient,
                        backdrop: a.imageUrl.isEmpty
                            ? null
                            : Image.network(
                                a.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    DecoratedBox(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: gradient,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          achievementCategoryIcon(a.category),
                                          size: 64,
                                          color: Colors.white.withValues(
                                            alpha: 0.85,
                                          ),
                                        ),
                                      ),
                                    ),
                              ),
                        badge: AchievementBadge(achievement: a, size: 68),
                        actions: [
                          PortfolioRoundAction(
                            icon: Icons.ios_share,
                            tooltip: 'Bagikan',
                            onTap: () => _share(context),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.title,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: OceanColors.navy,
                              ),
                            ),
                            const SizedBox(height: 10),
                            PortfolioInfoTable(
                              rows: [
                                PortfolioInfoRow(
                                  icon: Icons.category_outlined,
                                  label: 'Kategori',
                                  value: a.category.label,
                                ),
                                if (a.period.isNotEmpty)
                                  PortfolioInfoRow(
                                    icon: Icons.calendar_month_outlined,
                                    label: 'Periode',
                                    value: a.period,
                                  ),
                              ],
                            ),
                            if (a.description.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              const PortfolioSectionTitle('Deskripsi'),
                              const SizedBox(height: 4),
                              SelectableText(
                                a.description,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.35,
                                  color: OceanColors.navy,
                                ),
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
