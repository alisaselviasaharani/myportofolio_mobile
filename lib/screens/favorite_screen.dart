import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_detail_screen.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/education_parts.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';

/// Halaman "Favorit": pendidikan yang ditandai bintang di halaman detail.
///
/// Data dibaca dari [PortfolioStore.favorites]; menekan kartu membuka detail.
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: oceanAppBar(title: 'Favorit', centerTitle: true),
      bottomNavigationBar: const OceanBottomBar(favoriteSelected: true),
      body: OceanBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ValueListenableBuilder<List<Education>>(
              valueListenable: PortfolioStore.instance.favorites,
              builder: (context, favorites, child) {
                if (favorites.isEmpty) {
                  return const _EmptyFavorites();
                }
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(16, top + 14, 16, 130),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final education = favorites[index];
                    return EducationCard(
                      education: education,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EducationDetailScreen(education: education),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

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
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_border, color: OceanColors.deep, size: 40),
            SizedBox(height: 8),
            Text(
              'Belum ada pendidikan favorit.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: OceanColors.navy,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Tekan ikon bintang di halaman detail untuk menandai.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: OceanColors.navy),
            ),
          ],
        ),
      ),
    );
  }
}
