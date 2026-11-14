import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/data/experience_repository.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';

/// Halaman daftar experience.
///
/// Tetap [StatelessWidget]: pembaruan data ditangani oleh
/// [ValueListenableBuilder] yang mendengarkan repository.
class ExperienceListPage extends StatelessWidget {
  const ExperienceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Experience',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ValueListenableBuilder<List<Experience>>(
        valueListenable: experienceRepository.experiences,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada experience.'));
          }
          final list = ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12.0),
            itemBuilder: (context, index) => ExperienceCard(items[index]),
          );
          // Batasi lebar agar tidak melebar di layar desktop/tablet.
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: list,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ExperienceFormPage()),
          );
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

/// Kartu yang menampilkan satu [Experience], lengkap dengan foto.
class ExperienceCard extends StatelessWidget {
  final Experience experience;

  const ExperienceCard(this.experience, {super.key});

  @override
  Widget build(BuildContext context) {
    final category = experience.category;
    return Card(
      elevation: 3.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Foto kegiatan dengan label kategori di pojok kiri bawah.
          SizedBox(
            height: 180,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _ExperienceImage(experience),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Chip(
                    label: Text(
                      category.label,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: category.color,
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  experience.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Icon(Icons.business, size: 16, color: Colors.grey),
                    const SizedBox(width: 6.0),
                    Expanded(child: Text(experience.institution)),
                  ],
                ),
                const SizedBox(height: 2.0),
                Row(
                  children: [
                    const Icon(Icons.event, size: 16, color: Colors.grey),
                    const SizedBox(width: 6.0),
                    Text(experience.period),
                  ],
                ),
                const SizedBox(height: 10.0),
                Text(experience.description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Foto experience. Jika URL kosong atau gagal dimuat, tampilkan placeholder
/// bergradasi warna kategori agar kartu tetap rapi.
class _ExperienceImage extends StatelessWidget {
  final Experience experience;

  const _ExperienceImage(this.experience);

  @override
  Widget build(BuildContext context) {
    final url = experience.imageUrl;
    final placeholder = _Placeholder(color: experience.category.color);
    if (url == null || url.isEmpty) return placeholder;

    // Path "assets/..." dimuat dari file lokal, selain itu dianggap URL.
    // Keduanya jatuh ke placeholder jika gagal dimuat.
    if (url.startsWith('assets/')) {
      // Aset (mis. logo) ditampilkan utuh di atas latar putih agar tidak terpotong.
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12),
        child: Image.asset(
          url,
          fit: BoxFit.contain,
          // Dikecilkan saat decode supaya hemat memori untuk file besar.
          cacheHeight: 400,
          errorBuilder: (_, _, _) => placeholder,
        ),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : placeholder,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}

class _Placeholder extends StatelessWidget {
  final Color color;

  const _Placeholder({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, Color.alphaBlend(Colors.black26, color)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.photo_camera_outlined, color: Colors.white70, size: 48),
      ),
    );
  }
}
