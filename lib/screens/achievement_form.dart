import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/achievement.dart';
import 'package:myportofolio_mobile/utils/period_format.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Halaman formulir untuk menambah achievement (penghargaan/sertifikasi).
///
/// Field mengikuti model Django `Achievements`: nama, periode, deskripsi,
/// kategori, dan URL gambar. Setelah semua input lolos validasi, ringkasan
/// isian ditampilkan dalam [AlertDialog].
class AchievementFormPage extends StatefulWidget {
  const AchievementFormPage({super.key});

  @override
  State<AchievementFormPage> createState() => _AchievementFormPageState();
}

class _AchievementFormPageState extends State<AchievementFormPage> {
  // Batas panjang. Judul dan URL mengikuti model Django (255 dan 500);
  // deskripsi dibatasi 500 sebagai aturan aplikasi mobile.
  static const int _titleMaxLength = 255;
  static const int _descriptionMaxLength = 500;
  static const int _imageUrlMaxLength = 500;
  static const AchievementCategory _defaultCategory =
      AchievementCategory.academic;
  static const EdgeInsets _fieldPadding = EdgeInsets.all(8.0);

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  AchievementCategory _category = _defaultCategory;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  /// Dekorasi input yang seragam untuk semua field.
  InputDecoration _decoration({
    required String label,
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  /// Membuka `showDatePicker` lalu menyimpan tanggal terpilih.
  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = (isStart ? _startDate : (_endDate ?? _startDate)) ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1990),
      lastDate: DateTime(now.year + 10),
      helpText: isStart ? 'Pilih tanggal mulai' : 'Pilih tanggal selesai',
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      if (isStart) {
        _startDate = picked;
        _startDateController.text = formatDate(picked);
      } else {
        _endDate = picked;
        _endDateController.text = formatDate(picked);
      }
    });
  }

  void _clearEndDate() {
    setState(() {
      _endDate = null;
      _endDateController.clear();
    });
  }

  /// Dipanggil tombol Simpan: menjalankan validasi seluruh field.
  /// Dialog ringkasan ditambahkan pada commit berikutnya.
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
                  // === Kategori ===
                  Padding(
                    padding: _fieldPadding,
                    child: DropdownButtonFormField<AchievementCategory>(
                      key: const Key('categoryField'),
                      decoration: _decoration(label: 'Kategori Penghargaan'),
                      // Nilai awal konstan agar reset() kembali ke default.
                      initialValue: _defaultCategory,
                      items: AchievementCategory.values
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _category = value);
                        }
                      },
                    ),
                  ),
                  // === Tanggal Mulai ===
                  Padding(
                    padding: _fieldPadding,
                    child: TextFormField(
                      key: const Key('startDateField'),
                      controller: _startDateController,
                      readOnly: true,
                      onTap: () => _pickDate(isStart: true),
                      decoration: _decoration(
                        label: 'Tanggal Mulai',
                        hint: 'Pilih tanggal',
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      validator: (_) => FormValidators.requiredDate(
                        _startDate,
                        fieldName: 'Tanggal mulai',
                      ),
                    ),
                  ),
                  // === Tanggal Selesai (opsional) ===
                  Padding(
                    padding: _fieldPadding,
                    child: TextFormField(
                      key: const Key('endDateField'),
                      controller: _endDateController,
                      readOnly: true,
                      onTap: () => _pickDate(isStart: false),
                      decoration: _decoration(
                        label: 'Tanggal Selesai (opsional)',
                        hint: 'Pilih tanggal',
                        suffixIcon: _endDate == null
                            ? const Icon(Icons.calendar_today)
                            : IconButton(
                                tooltip: 'Hapus tanggal selesai',
                                icon: const Icon(Icons.clear),
                                onPressed: _clearEndDate,
                              ),
                      ),
                      validator: (_) =>
                          FormValidators.dateOrder(_startDate, _endDate),
                    ),
                  ),
                  // Pratinjau periode yang akan disimpan.
                  if (_startDate != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                      child: Text(
                        'Periode: ${formatPeriod(_startDate!, _endDate)}',
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  // === URL Gambar (opsional) ===
                  Padding(
                    padding: _fieldPadding,
                    child: TextFormField(
                      key: const Key('imageUrlField'),
                      controller: _imageUrlController,
                      maxLength: _imageUrlMaxLength,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      decoration: _decoration(
                        label: 'URL Gambar Penghargaan (opsional)',
                        hint: 'https://contoh.com/gambar.png',
                      ),
                      validator: (value) => FormValidators.optionalUrl(
                        value,
                        fieldName: 'URL gambar',
                        maxLength: _imageUrlMaxLength,
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
