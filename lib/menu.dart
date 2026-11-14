import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/experience_list.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = "2506618433";
  final String nama = "Alisa Selvia Saharani";
  final String kelas = "PBP D";

  final List<ItemHomepage> items = [
    ItemHomepage(
      "Lihat Experience",
      Icons.work,
      Colors.blue,
      destination: (_) => const ExperienceListPage(),
    ),
    ItemHomepage(
      "Tambah Experience",
      Icons.add_circle,
      Colors.green,
      destination: (_) => const ExperienceFormPage(),
    ),
    ItemHomepage("Logout", Icons.logout, Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    // Scaffold menyediakan struktur visual dasar halaman (AppBar, Body, SnackBar).
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // AppBar menampilkan bar bagian atas halaman aplikasi.
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primary,
      ),
      body: SingleChildScrollView(
        // Batasi lebar agar tampilan tetap proporsional di layar lebar.
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
          children: [
            // Header bergradasi berisi pesan sambutan.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primary, Color.alphaBlend(Colors.black26, primary)],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
              ),
              child: const Column(
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
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  // GridView menampilkan kartu tombol dalam tata letak kisi 3 kolom.
                  GridView.count(
                    // Kisi tidak scroll sendiri; scroll ditangani halaman.
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    crossAxisCount: 3,
                    // shrinkWrap agar ukuran kisi menyesuaikan tinggi konten anak.
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
    );
  }
}

class InfoCard extends StatelessWidget {
  // Kartu informasi yang menampilkan ikon, judul (title), dan isi (content).
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
/// `item.color` tanpa percabangan if-else per tombol.
/// [destination] bersifat opsional: bila diisi, halaman tersebut dibuka
/// setelah SnackBar ditampilkan.
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;
  final WidgetBuilder? destination;

  ItemHomepage(this.name, this.icon, this.color, {this.destination});
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shadowColor: item.color.withValues(alpha: 0.5),
      // Warna latar diambil dari model, jadi tiap tombol punya warna sendiri.
      color: item.color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        // Aksi ketika kartu ditekan oleh pengguna.
        onTap: () {
          // Menampilkan SnackBar dengan pesan interaktif.
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!"),
              ),
            );

          // Buka halaman tujuan (jika ada) setelah SnackBar ditampilkan.
          final destination = item.destination;
          if (destination != null) {
            Navigator.of(context).push(MaterialPageRoute(builder: destination));
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 34.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
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
