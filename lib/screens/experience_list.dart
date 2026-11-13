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
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12.0),
            itemBuilder: (context, index) => ExperienceCard(items[index]),
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

/// Kartu yang menampilkan satu [Experience].
class ExperienceCard extends StatelessWidget {
  final Experience experience;

  const ExperienceCard(this.experience, {super.key});

  @override
  Widget build(BuildContext context) {
    final category = experience.category;
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              experience.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4.0),
            Text('${experience.institution} • ${experience.period}'),
            const SizedBox(height: 8.0),
            Chip(
              label: Text(
                category.label,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: category.color,
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(height: 8.0),
            Text(experience.description),
          ],
        ),
      ),
    );
  }
}
