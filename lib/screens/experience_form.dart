import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/data/experience_repository.dart';
import 'package:myportofolio_mobile/models/experience.dart';

/// Halaman form untuk menambah experience baru.
///
/// Berupa [StatefulWidget] karena menyimpan state form: controller teks
/// dan kategori yang sedang dipilih.
class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _institutionController = TextEditingController();
  final _periodController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  ExperienceCategory _category = ExperienceCategory.fullTime;

  @override
  void dispose() {
    _titleController.dispose();
    _institutionController.dispose();
    _periodController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  /// Validator bersama: field tidak boleh kosong.
  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Wajib diisi';
    }
    return null;
  }

  /// Foto bersifat opsional, tetapi jika diisi harus berupa URL http(s).
  String? _optionalUrl(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    if (!text.startsWith('http://') &&
        !text.startsWith('https://') &&
        !text.startsWith('assets/')) {
      return 'Harus diawali http(s):// atau assets/';
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    experienceRepository.add(
      Experience(
        title: _titleController.text.trim(),
        institution: _institutionController.text.trim(),
        period: _periodController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _category,
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Experience "${_titleController.text.trim()}" '
            'berhasil ditambahkan!')),
      );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Experience',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
              validator: _required,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _institutionController,
              decoration: const InputDecoration(
                labelText: 'Institusi',
                border: OutlineInputBorder(),
              ),
              validator: _required,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _periodController,
              decoration: const InputDecoration(
                labelText: 'Periode (mis. 2024 - 2025)',
                border: OutlineInputBorder(),
              ),
              validator: _required,
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<ExperienceCategory>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: ExperienceCategory.values
                  .map(
                    (c) => DropdownMenuItem(value: c, child: Text(c.label)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: _required,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _imageUrlController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Foto: URL atau assets/images/... (opsional)',
                prefixIcon: Icon(Icons.image_outlined),
                border: OutlineInputBorder(),
              ),
              validator: _optionalUrl,
            ),
            const SizedBox(height: 24.0),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
