import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/achievement.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/achievement_form.dart';
import 'package:myportofolio_mobile/screens/contact_page.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/screens/skills_page.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/experience_card.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/mascots.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:provider/provider.dart';

/// Halaman utama aplikasi MyPortfolio.
///
/// Isinya: kartu sapaan bermaskot ubur-ubur, grid 2 kolom [ItemCard] aksi
/// (data dari [items]) di dalam panel kaca, dan bagian "My Portfolio" yang
/// jumlah itemnya mengikuti [PortfolioStore].
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // Daftar tombol aksi. Warna dan halaman tujuan tiap tombol didefinisikan
  // di sini (satu sumber).
  final List<ItemHomepage> items = [
    ItemHomepage(
      'Add Education',
      Icons.school,
      OceanColors.cardYellow,
      iconColor: const Color(0xFF3F3DA8),
      pageBuilder: (context) => const EducationFormPage(),
    ),
    ItemHomepage(
      'My Education',
      Icons.history_edu,
      OceanColors.cardLavender,
      iconColor: const Color(0xFF6C4FD8),
      pageBuilder: (context) => const EducationListScreen(),
    ),
    ItemHomepage(
      'Add Experience',
      Icons.work,
      OceanColors.cardPurple,
      iconColor: const Color(0xFF4A56C4),
      pageBuilder: (context) => const ExperienceFormPage(),
      // Hanya bisa dibuka setelah login (route guard).
      requiresAuth: true,
    ),
    ItemHomepage(
      'Add Certification',
      Icons.workspace_premium,
      OceanColors.cardPink,
      iconColor: const Color(0xFF9A3FC4),
      pageBuilder: (context) => const AchievementFormPage(),
    ),
    ItemHomepage(
      'My Experience',
      Icons.work_history,
      OceanColors.cardYellow,
      iconColor: const Color(0xFF3F3DA8),
      pageBuilder: (context) => const ExperienceListScreen(),
    ),
    ItemHomepage(
      'My Skills',
      Icons.psychology,
      OceanColors.cardLavender,
      iconColor: const Color(0xFF6C4FD8),
      pageBuilder: (context) => const SkillsPage(),
    ),
    ItemHomepage(
      'Contact Me',
      Icons.contact_mail,
      OceanColors.cardYellow,
      iconColor: const Color(0xFF3F3DA8),
      pageBuilder: (context) => const ContactPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Latar laut tampil juga di balik gelombang header.
      extendBodyBehindAppBar: true,
      appBar: oceanAppBar(
        title: 'My Portfolio',
        centerTitle: true,
        actions: const [_AvatarAction()],
      ),
      // Drawer menu untuk navigasi antarhalaman.
      drawer: const LeftDrawer(selected: DrawerDestination.home),
      body: OceanBackground(
        child: SingleChildScrollView(
          // Batasi lebar agar tampilan tetap proporsional di layar lebar.
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.paddingOf(context).top + oceanAppBarHeight + 26,
                  16,
                  28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HeroCard(),
                    const SizedBox(height: 14.0),
                    // Panel kaca berisi grid kartu aksi 2 kolom.
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.38),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                      child: GridView.count(
                        // Kisi tidak scroll sendiri; scroll ditangani halaman.
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        crossAxisCount: 2,
                        childAspectRatio: 1.8,
                        // shrinkWrap agar ukuran kisi menyesuaikan tinggi anak.
                        shrinkWrap: true,
                        children: [
                          for (final item in items) ItemCard(item),
                          // Kartu Login/Logout mengikuti state login.
                          const _AuthCard(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    const _PortfolioSection(),
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

/// Kartu Login (jika belum login) atau Logout (jika sudah login).
///
/// Memakai `context.watch` sehingga berganti otomatis saat state berubah.
class _AuthCard extends StatelessWidget {
  const _AuthCard();

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    if (isLoggedIn) {
      return ItemCard(
        ItemHomepage(
          'Logout',
          Icons.logout,
          OceanColors.cardPink,
          iconColor: const Color(0xFF9A3FC4),
          onTap: (context) async {
            final messenger = ScaffoldMessenger.of(context);
            await context.read<AuthState>().logout();
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Berhasil logout.')));
          },
        ),
      );
    }
    return ItemCard(
      ItemHomepage(
        'Login',
        Icons.login,
        OceanColors.cardLavender,
        iconColor: const Color(0xFF6C4FD8),
        onTap: (context) async {
          final loggedIn = await ensureLoggedIn(context);
          if (loggedIn && context.mounted) {
            showInfoSnackBar(context, 'Berhasil login.');
          }
        },
      ),
    );
  }
}

/// Foto profil kecil di kanan AppBar.
class _AvatarAction extends StatelessWidget {
  const _AvatarAction();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 14.0),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Color(0xCCFFFFFF),
        child: CircleAvatar(
          radius: 19,
          backgroundImage: AssetImage('assets/images/alisa.png'),
        ),
      ),
    );
  }
}

/// Kartu sapaan di bagian atas beranda, dengan ubur-ubur di kanan.
class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 22, 112, 22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.62),
                const Color(0xFFBFEFFC).withValues(alpha: 0.7),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight: Radius.circular(40),
              bottomLeft: Radius.circular(44),
              bottomRight: Radius.circular(36),
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
            boxShadow: [
              BoxShadow(
                color: OceanColors.deep.withValues(alpha: 0.12),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, I'm Alisa! 👋",
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.w800,
                  color: OceanColors.navy,
                ),
              ),
              SizedBox(height: 6.0),
              Text(
                'Computer Science student at Universitas Indonesia.\n'
                'Welcome to my little corner of the sea! 🌊\n',
                style: TextStyle(fontSize: 12.0, color: Colors.black54),
              ),
            ],
          ),
        ),
        // Rumput laut di dua sudut bawah kartu.
        const Positioned(left: 2, bottom: -14, child: Seaweed(size: 54)),
        const Positioned(
          right: 2,
          bottom: -14,
          child: Seaweed(size: 54, flip: true),
        ),
        // Ubur-ubur menonjol sedikit di atas kartu.
        const Positioned(
          right: 10,
          top: -22,
          child: JellyfishMascot(width: 96),
        ),
      ],
    );
  }
}

/// Bagian "My Portfolio": daftar bagian beserta jumlah itemnya.
///
/// Jumlah diambil dari [PortfolioStore] lewat [ValueListenableBuilder],
/// sehingga ikut berubah setelah form disimpan.
class _PortfolioSection extends StatelessWidget {
  const _PortfolioSection();

  @override
  Widget build(BuildContext context) {
    final store = PortfolioStore.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [OceanColors.buttonStart, OceanColors.buttonEnd],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: OceanColors.deep.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'My Portfolio',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 6),
              child: ClownfishMascot(width: 58),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        ValueListenableBuilder<List<Education>>(
          valueListenable: store.educations,
          builder: (context, list, child) => _PortfolioTile(
            icon: Icons.school,
            color: const Color(0xFFCFEFFA),
            iconColor: const Color(0xFF4A3FA8),
            title: 'Education',
            count: list.length,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EducationListScreen(),
              ),
            ),
          ),
        ),
        ValueListenableBuilder<int>(
          valueListenable: store.experienceCount,
          builder: (context, count, child) => _PortfolioTile(
            icon: Icons.work,
            color: const Color(0xFFCFEFFA),
            iconColor: const Color(0xFF4A56C4),
            title: 'Experience',
            count: count,
          ),
        ),
        ValueListenableBuilder<List<Achievement>>(
          valueListenable: store.achievements,
          builder: (context, list, child) => _PortfolioTile(
            icon: Icons.workspace_premium,
            color: const Color(0xFFE9D8FA),
            iconColor: const Color(0xFF9A3FC4),
            title: 'Certifications',
            count: list.length,
          ),
        ),
      ],
    );
  }
}

class _PortfolioTile extends StatelessWidget {
  const _PortfolioTile({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.title,
    required this.count,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color iconColor;
  final String title;
  final int count;

  /// Aksi saat ditekan; `null` menampilkan SnackBar "akan hadir".
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
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
          onTap:
              onTap ??
              () => showInfoSnackBar(
                context,
                'Daftar $title akan hadir di tahap berikutnya.',
              ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: OceanColors.navy,
                        ),
                      ),
                      Text(
                        '$count ${count == 1 ? 'item' : 'items'}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: OceanColors.navy,
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

/// Model data untuk satu tombol aksi pada halaman utama.
///
/// Warna disimpan langsung di model sehingga [ItemCard] cukup membaca
/// `item.color` tanpa percabangan if-else per tombol. Halaman tujuan juga
/// disimpan di model lewat [pageBuilder], sehingga menambah kartu baru cukup
/// dengan mendaftarkannya di daftar `items` tanpa mengubah [ItemCard].
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  /// Warna ikon pada kartu.
  final Color iconColor;

  /// Pembuat halaman tujuan. `null` berarti kartu hanya menampilkan SnackBar.
  final WidgetBuilder? pageBuilder;

  /// `true` jika halaman tujuan hanya boleh dibuka setelah login.
  final bool requiresAuth;

  /// Aksi khusus (menggantikan SnackBar + navigasi bawaan), mis. Login/Logout.
  final Future<void> Function(BuildContext context)? onTap;

  ItemHomepage(
    this.name,
    this.icon,
    this.color, {
    this.iconColor = OceanColors.navy,
    this.pageBuilder,
    this.requiresAuth = false,
    this.onTap,
  });
}
