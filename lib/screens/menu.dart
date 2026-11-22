import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/achievement_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/experience_card.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';

/// Halaman utama aplikasi MyPortfolio.
///
/// Berupa [StatelessWidget] karena tidak menyimpan state yang berubah.
/// Isinya: header sambutan, tiga [InfoCard] identitas (NPM, Name, Class),
/// dan [ItemCard] aksi yang datanya diambil dari daftar [items].
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // Identitas pemilik portofolio.
  final String npm = "2506618433";
  final String nama = "Alisa Selvia Saharani";
  final String kelas = "PBP D";

  // Daftar tombol aksi. Warna dan halaman tujuan tiap tombol didefinisikan
  // di sini (satu sumber).
  final List<ItemHomepage> items = [
    ItemHomepage("Lihat Experience", Icons.work, OceanColors.deep),
    ItemHomepage(
      "Tambah Experience",
      Icons.add_circle,
      OceanColors.seaGreen,
      pageBuilder: (context) => const ExperienceFormPage(),
    ),
    ItemHomepage(
      "Tambah Achievement",
      Icons.emoji_events,
      OceanColors.lavender,
      pageBuilder: (context) => const AchievementFormPage(),
    ),
    ItemHomepage("Logout", Icons.logout, OceanColors.coral),
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur visual dasar halaman (AppBar, Body, SnackBar).
    return Scaffold(
      appBar: oceanAppBar(title: 'MyPortfolio'),
      // Drawer menu untuk navigasi antarhalaman.
      drawer: const LeftDrawer(selected: DrawerDestination.home),
      body: OceanBackground(
        child: SingleChildScrollView(
          // Batasi lebar agar tampilan tetap proporsional di layar lebar.
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  const _HeroHeader(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        const SizedBox(height: 24.0),
                        const Text(
                          'Menu',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: OceanColors.deep,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        // GridView menampilkan kartu tombol dalam kisi 3 kolom.
                        GridView.count(
                          // Kisi tidak scroll sendiri; scroll ditangani halaman.
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          crossAxisCount: 3,
                          // shrinkWrap agar ukuran kisi menyesuaikan tinggi anak.
                          shrinkWrap: true,
                          children: items.map((ItemHomepage item) {
                            return ItemCard(item);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Header sambutan bergradasi laut dengan avatar emoji.
class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [OceanColors.deep, OceanColors.teal],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white,
            child: Text('🐙', style: TextStyle(fontSize: 36)),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang di MyPortfolio Mobile!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 6.0),
                Text(
                  'Kelola pengalaman dan portofoliomu dalam satu aplikasi.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
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
      color: Colors.white,
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
