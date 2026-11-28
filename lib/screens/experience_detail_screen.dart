import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/widgets/experience_parts.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';
import 'package:myportofolio_mobile/widgets/portfolio_list_parts.dart';

/// Halaman "Detail Pengalaman" bergaya sama dengan Detail Pendidikan: panel
/// gradasi dengan tombol bagikan, lencana ikon, tabel info (Perusahaan, Tipe,
/// Periode, Tautan), dan Deskripsi. Baris yang kosong tidak ditampilkan.
class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({super.key, required this.experience});

  final Experience experience;

  void _share(BuildContext context) {
    final e = experience;
    final text = [
      e.position,
      e.company,
      if (e.type.isNotEmpty) e.type,
      if (e.period.isNotEmpty) e.period,
    ].join('\n');
    showInfoSnackBar(context, 'Ringkasan pengalaman disalin ke clipboard.');
    unawaited(Clipboard.setData(ClipboardData(text: text)).catchError((_) {}));
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;
    final e = experience;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: oceanAppBar(title: 'Detail Pengalaman', centerTitle: true),
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
                        icon: Icons.work,
                        colors: const [
                          OceanColors.lavender,
                          OceanColors.indigo,
                        ],
                        badge: const ExperienceBadge(size: 68),
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
                              e.position,
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
                                  icon: Icons.business_outlined,
                                  label: 'Perusahaan',
                                  value: e.company,
                                ),
                                if (e.type.isNotEmpty)
                                  PortfolioInfoRow(
                                    icon: Icons.category_outlined,
                                    label: 'Tipe',
                                    value: e.type,
                                  ),
                                if (e.period.isNotEmpty)
                                  PortfolioInfoRow(
                                    icon: Icons.calendar_month_outlined,
                                    label: 'Periode',
                                    value: e.period,
                                  ),
                                if (e.link.isNotEmpty)
                                  PortfolioInfoRow(
                                    icon: Icons.link,
                                    label: 'Tautan',
                                    value: e.link,
                                  ),
                              ],
                            ),
                            if (e.description.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              const PortfolioSectionTitle('Deskripsi'),
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
