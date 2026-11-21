import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Halaman formulir untuk menambah achievement (penghargaan/sertifikasi).
///
/// Commit ini baru berisi kerangka halaman (Scaffold, AppBar, Drawer, Form
/// dengan GlobalKey) serta dua field teks wajib beserta validasinya.
class AchievementFormPage extends StatefulWidget {
  const AchievementFormPage({super.key});

  @override
  State<AchievementFormPage> createState() => _AchievementFormPageState();
}

class _AchievementFormPageState extends State<AchievementFormPage> {
  static const int _titleMaxLength = 255;
  static const int _descriptionMaxLength = 500;
  static const EdgeInsets _fieldPadding = EdgeInsets.all(8.0);

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Dekorasi input yang seragam untuk semua field.
  InputDecoration _decoration({required String label, String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  /// Dipanggil tombol Simpan: menjalankan validasi seluruh field.
  void _submit() {
    _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Achievement Form'),
        centerTitle: true,
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      // Drawer yang sama dengan halaman utama.
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          // Papan ketik ditutup saat form digulir.
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === Nama Penghargaan ===
                  Padding(
                    padding: _fieldPadding,
                    child: TextFormField(
                      key: const Key('titleField'),
                      controller: _titleController,
                      maxLength: _titleMaxLength,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: _decoration(
                        label: 'Nama Penghargaan',
                        hint: 'Contoh: Juara 1 Hackathon Nasional',
                      ),
                      validator: (value) => FormValidators.requiredText(
                        value,
                        fieldName: 'Nama penghargaan',
                        maxLength: _titleMaxLength,
                      ),
                    ),
                  ),
                  // === Deskripsi ===
                  Padding(
                    padding: _fieldPadding,
                    child: TextFormField(
                      key: const Key('descriptionField'),
                      controller: _descriptionController,
                      minLines: 3,
                      maxLines: 5,
                      maxLength: _descriptionMaxLength,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: _decoration(
                        label: 'Deskripsi Penghargaan',
                        hint: 'Ceritakan penghargaanmu',
                      ),
                      validator: (value) => FormValidators.requiredText(
                        value,
                        fieldName: 'Deskripsi penghargaan',
                        maxLength: _descriptionMaxLength,
                      ),
                    ),
                  ),
                  // === Tombol Simpan ===
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: _submit,
                        child: const Text('Simpan'),
                      ),
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
