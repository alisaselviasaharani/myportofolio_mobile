import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';
import 'package:myportofolio_mobile/widgets/ocean_button.dart';
import 'package:provider/provider.dart';

/// Halaman "Profil": foto dan identitas pemilik portofolio, ringkasan jumlah
/// data (dari [PortfolioStore]), dan tombol Login/Logout sesuai [AuthState].
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _toggleAuth(BuildContext context, bool isLoggedIn) async {
    if (isLoggedIn) {
      await context.read<AuthState>().logout();
      if (!context.mounted) {
        return;
      }
      showInfoSnackBar(context, 'Berhasil logout.');
      return;
    }
    final loggedIn = await ensureLoggedIn(context);
    if (loggedIn && context.mounted) {
      showInfoSnackBar(context, 'Berhasil login.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    final store = PortfolioStore.instance;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: oceanAppBar(title: 'Profil', centerTitle: true),
      bottomNavigationBar: const OceanBottomBar(profileSelected: true),
      body: OceanBackground(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, top + 14, 16, 130),
                child: Column(
                  children: [
                    const _IdentityCard(),
                    const SizedBox(height: 14),
                    ListenableBuilder(
                      listenable: Listenable.merge([
                        store.educations,
                        store.achievements,
                        store.experienceCount,
                        store.favorites,
                      ]),
                      builder: (context, child) => Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _StatTile(
                                  icon: Icons.school,
                                  label: 'Education',
                                  count: store.educations.value.length,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StatTile(
                                  icon: Icons.work,
                                  label: 'Experience',
                                  count: store.experienceCount.value,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _StatTile(
                                  icon: Icons.workspace_premium,
                                  label: 'Certifications',
                                  count: store.achievements.value.length,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StatTile(
                                  icon: Icons.star,
                                  label: 'Favorit',
                                  count: store.favorites.value.length,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: OceanButton(
                        label: isLoggedIn ? 'Logout' : 'Login',
                        icon: isLoggedIn ? Icons.logout : Icons.login,
                        onPressed: () => _toggleAuth(context, isLoggedIn),
                      ),
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

class _IdentityCard extends StatelessWidget {
  const _IdentityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.9),
            const Color(0xFFD9F1FA).withValues(alpha: 0.85),
          ],
        ),
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
      child: const Column(
        children: [
          CircleAvatar(
            radius: 52,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage('assets/images/alisa.png'),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Alisa Selvia Saharani',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: OceanColors.navy,
            ),
          ),
          Text(
            'Computer Science Student',
            style: TextStyle(fontSize: 15, color: OceanColors.navy),
          ),
          SizedBox(height: 14),
          _InfoLine(label: 'NPM', value: '2506618433'),
          _InfoLine(label: 'Kelas', value: 'PBP D'),
          _InfoLine(label: 'Kampus', value: 'Universitas Indonesia'),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
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
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: OceanColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.count,
  });

  final IconData icon;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: OceanColors.courseChip,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: OceanColors.purpleSelected, size: 26),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: OceanColors.navy,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: OceanColors.navy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
