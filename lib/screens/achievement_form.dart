import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/achievement.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/period_format.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/date_form_field.dart';
import 'package:myportofolio_mobile/widgets/form_header.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';
import 'package:myportofolio_mobile/widgets/ocean_button.dart';
import 'package:myportofolio_mobile/widgets/summary_dialog.dart';

/// Halaman formulir untuk menambah achievement (penghargaan/sertifikasi).
///
/// Field mengikuti model Django `Achievements`: nama, periode, deskripsi,
/// kategori, dan URL gambar. Setelah semua input lolos validasi, ringkasan
/// isian ditampilkan lewat [showSummaryDialog].
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

  /// Membuka date picker lalu menyimpan tanggal terpilih.
  Future<void> _pickDate({required bool isStart}) async {
    final picked = await pickDate(
      context,
      initial: isStart ? _startDate : (_endDate ?? _startDate),
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

  /// Dipanggil tombol Simpan: validasi dulu, dialog hanya jika semua valid.
  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final achievement = Achievement(
      title: _titleController.text.trim(),
      period: formatPeriod(_startDate!, _endDate),
      description: _descriptionController.text.trim(),
      category: _category,
      imageUrl: _imageUrlController.text.trim(),
    );
    PortfolioStore.instance.addAchievement(achievement);
    showSummaryDialog(
      context,
      title: 'Achievement berhasil ditambahkan!',
      emoji: '🏆',
      closeLabel: 'Tutup',
      items: [
        SummaryItem(
          label: 'Nama Penghargaan',
          value: achievement.title,
          icon: Icons.emoji_events_outlined,
        ),
        SummaryItem(
          label: 'Periode',
          value: achievement.period,
          icon: Icons.calendar_today_outlined,
        ),
        SummaryItem(
          label: 'Kategori',
          value: achievement.category.label,
          icon: Icons.category_outlined,
        ),
        SummaryItem(
          label: 'Deskripsi',
          value: achievement.description,
          icon: Icons.notes_outlined,
        ),
        SummaryItem(
          label: 'URL Gambar',
          value: achievement.imageUrl,
          icon: Icons.image_outlined,
        ),
      ],
      onClosed: _resetForm,
    );
  }

  /// Mengembalikan form dan semua state ke kondisi awal.
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _category = _defaultCategory;
      _startDate = null;
      _endDate = null;
      _startDateController.clear();
      _endDateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: oceanAppBar(title: 'Add Achievement Form'),
      // Drawer yang sama dengan halaman utama.
      drawer: const LeftDrawer(selected: DrawerDestination.achievement),
      bottomNavigationBar: const OceanBottomBar(),
      body: OceanBackground(
        child: Form(
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
                    const FormHeader(
                      emoji: '🏆',
                      title: 'Add Achievement',
                      subtitle: 'Fill in your achievement details below.',
                    ),
                    // === Nama Penghargaan ===
                    Padding(
                      padding: _fieldPadding,
                      child: TextFormField(
                        key: const Key('titleField'),
                        controller: _titleController,
                        maxLength: _titleMaxLength,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: oceanInputDecoration(
                          label: 'Nama Penghargaan',
                          hint: 'Contoh: Juara 1 Hackathon Nasional',
                          prefixIcon: const Icon(Icons.emoji_events_outlined),
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
                        decoration: oceanInputDecoration(
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
                        decoration: oceanInputDecoration(
                          label: 'Kategori Penghargaan',
                          prefixIcon: const Icon(Icons.category_outlined),
                        ),
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
                      child: DateFormField(
                        key: const Key('startDateField'),
                        controller: _startDateController,
                        label: 'Tanggal Mulai',
                        onTap: () => _pickDate(isStart: true),
                        validator: (_) => FormValidators.requiredDate(
                          _startDate,
                          fieldName: 'Tanggal mulai',
                        ),
                      ),
                    ),
                    // === Tanggal Selesai (opsional) ===
                    Padding(
                      padding: _fieldPadding,
                      child: DateFormField(
                        key: const Key('endDateField'),
                        controller: _endDateController,
                        label: 'Tanggal Selesai (opsional)',
                        onTap: () => _pickDate(isStart: false),
                        onClear: _endDate == null ? null : _clearEndDate,
                        clearTooltip: 'Hapus tanggal selesai',
                        validator: (_) =>
                            FormValidators.dateOrder(_startDate, _endDate),
                      ),
                    ),
                    // Pratinjau periode yang akan disimpan.
                    if (_startDate != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Periode: ${formatPeriod(_startDate!, _endDate)}',
                            style: const TextStyle(
                              color: OceanColors.deep,
                              fontWeight: FontWeight.w600,
                            ),
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
                        decoration: oceanInputDecoration(
                          label: 'URL Gambar Penghargaan (opsional)',
                          hint: 'https://contoh.com/gambar.png',
                          prefixIcon: const Icon(Icons.link),
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
                      child: OceanButton(
                        label: 'Simpan',
                        icon: Icons.save_outlined,
                        onPressed: _submit,
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
