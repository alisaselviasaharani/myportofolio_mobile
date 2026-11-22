import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/achievement.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/achievement_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/widgets/experience_card.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';

/// Halaman utama aplikasi MyPortfolio.
///
/// Berupa [StatelessWidget] karena tidak menyimpan state yang berubah.
/// Isinya: kartu sapaan, tiga [InfoCard] identitas (NPM, Name, Class),
/// grid 2 kolom [ItemCard] aksi (data dari [items]), dan bagian "My Portfolio"
/// yang jumlah itemnya mengikuti [PortfolioStore].
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // Identitas pemilik portofolio.
  final String npm = "2506618433";
  final String nama = "Alisa Selvia Saharani";
  final String kelas = "PBP D";

  // Daftar tombol aksi. Warna dan halaman tujuan tiap tombol didefinisikan
  // di sini (satu sumber).
  final List<ItemHomepage> items = [
    ItemHomepage(
      "Tambah Experience",
      Icons.work,
      OceanColors.pastelBlue,
      pageBuilder: (context) => const ExperienceFormPage(),
    ),
    ItemHomepage(
      "Tambah Education",
      Icons.school,
      OceanColors.pastelYellow,
      pageBuilder: (context) => const EducationFormPage(),
    ),
    ItemHomepage(
      "Tambah Achievement",
      Icons.emoji_events,
      OceanColors.pastelPink,
      pageBuilder: (context) => const AchievementFormPage(),
    ),
    ItemHomepage("Lihat Experience", Icons.folder_open, OceanColors.pastelMint),
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur visual dasar halaman (AppBar, Body, SnackBar).
    return Scaffold(
      appBar: oceanAppBar(
        title: 'MyPortfolio',
        actions: [
          IconButton(
            tooltip: 'Notifikasi',
            icon: const Icon(Icons.notifications_none),
            onPressed: () => showInfoSnackBar(context, 'Belum ada notifikasi.'),
          ),
        ],
      ),
      // Drawer menu untuk navigasi antarhalaman.
      drawer: const LeftDrawer(selected: DrawerDestination.home),
      bottomNavigationBar: const OceanBottomBar(homeSelected: true),
      body: OceanBackground(
        child: SingleChildScrollView(
          // Batasi lebar agar tampilan tetap proporsional di layar lebar.
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HeroCard(),
                    const SizedBox(height: 12.0),
                    // 3 InfoCard dengan lebar dan tinggi yang sama.
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: InfoCard(
                              title: 'NPM',
                              content: npm,
                              icon: Icons.badge,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: InfoCard(
                              title: 'Name',
                              content: nama,
                              icon: Icons.person,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: InfoCard(
                              title: 'Class',
                              content: kelas,
                              icon: Icons.school,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // GridView menampilkan kartu tombol dalam kisi 2 kolom.
                    GridView.count(
                      // Kisi tidak scroll sendiri; scroll ditangani halaman.
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      crossAxisCount: 2,
                      childAspectRatio: 1.35,
                      // shrinkWrap agar ukuran kisi menyesuaikan tinggi anak.
                      shrinkWrap: true,
                      children: items.map((ItemHomepage item) {
                        return ItemCard(item);
                      }).toList(),
                    ),
                    const SizedBox(height: 20.0),
                    const _PortfolioSection(),
                    const SizedBox(height: 8.0),
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

/// Kartu sapaan di bagian atas beranda.
class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: OceanColors.aqua,
            child: Text('🐙', style: TextStyle(fontSize: 34)),
          ),
          SizedBox(width: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, I'm Alisa! 👋",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: OceanColors.deep,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  'Selamat datang di MyPortfolio Mobile!',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0),
                ),
                SizedBox(height: 2.0),
                Text(
                  'A Computer Science student who loves building useful apps.',
                  style: TextStyle(fontSize: 12.0, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: OceanColors.deep,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'My Portfolio',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8.0),
        ValueListenableBuilder<int>(
          valueListenable: store.experienceCount,
          builder: (context, count, child) => _PortfolioTile(
            icon: Icons.work_outline,
            color: OceanColors.deep,
            title: 'Experience',
            count: count,
          ),
        ),
        ValueListenableBuilder<List<Education>>(
          valueListenable: store.educations,
          builder: (context, list, child) => _PortfolioTile(
            icon: Icons.school_outlined,
            color: OceanColors.indigo,
            title: 'Education',
            count: list.length,
          ),
        ),
        ValueListenableBuilder<List<Achievement>>(
          valueListenable: store.achievements,
          builder: (context, list, child) => _PortfolioTile(
            icon: Icons.emoji_events_outlined,
            color: OceanColors.lavender,
            title: 'Achievements',
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
    required this.title,
    required this.count,
  });

  final IconData icon;
  final Color color;
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.92),
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$count ${count == 1 ? 'item' : 'items'}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => showInfoSnackBar(
          context,
          'Daftar $title akan hadir di tahap berikutnya.',
        ),
      ),
    );
  }
}

/// Kartu informasi yang menampilkan ikon, judul ([title]), dan isi ([content]).
///
/// Dipakai tiga kali di [MyHomePage] untuk NPM, Name, dan Class.
class InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      color: Colors.white.withValues(alpha: 0.92),
      elevation: 2.0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: primary.withValues(alpha: 0.12),
              child: Icon(icon, color: primary, size: 20),
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primary,
                fontSize: 12.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13.0),
            ),
          ],
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

  /// Pembuat halaman tujuan. `null` berarti kartu hanya menampilkan SnackBar.
  final WidgetBuilder? pageBuilder;

  ItemHomepage(this.name, this.icon, this.color, {this.pageBuilder});
}
