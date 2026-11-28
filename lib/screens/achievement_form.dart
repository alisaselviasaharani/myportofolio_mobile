import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/achievement.dart';
import 'package:myportofolio_mobile/screens/achievement_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/period_format.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/date_form_field.dart';
import 'package:myportofolio_mobile/widgets/form_card.dart';
import 'package:myportofolio_mobile/widgets/form_header.dart';
import 'package:myportofolio_mobile/widgets/illustrations.dart';
import 'package:myportofolio_mobile/widgets/labeled_field.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_button.dart';
import 'package:myportofolio_mobile/widgets/summary_dialog.dart';
import 'package:provider/provider.dart';

/// Halaman formulir untuk menambah achievement (penghargaan/sertifikasi).
///
/// Field mengikuti model Django `Achievements`: nama, periode, deskripsi,
/// kategori, dan URL gambar. Setelah semua input lolos validasi, data dikirim
/// ke backend Django (`POST /api/v1/achievements/`) dengan token, sehingga
/// pengguna harus login lebih dulu, lalu ringkasan ditampilkan lewat
/// [showSummaryDialog].
///
/// Setelah dialog ditutup, form ditutup: kembali ke halaman sebelumnya jika
/// [popOnSuccess] (dipakai daftar agar memuat ulang), atau diganti dengan
/// [AchievementListScreen] agar hasilnya langsung terlihat.
class AchievementFormPage extends StatefulWidget {
  const AchievementFormPage({super.key, this.popOnSuccess = false});

  /// `true` jika form dibuka dari daftar dan cukup kembali ke daftar itu.
  final bool popOnSuccess;

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

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  AchievementCategory _category = _defaultCategory;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSubmitting = false;

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

  /// Dipanggil tombol Simpan: validasi, pastikan login, kirim ke Django, lalu
  /// tampilkan dialog ringkasan jika berhasil.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Pastikan sudah login (membuka LoginScreen jika belum).
    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    final auth = context.read<AuthState>();
    final apiClient = context.read<ApiClient>();
    final token = auth.token;
    if (token == null) return;

    final newAchievement = Achievement(
      title: _titleController.text.trim(),
      period: formatPeriod(_startDate!, _endDate),
      description: _descriptionController.text.trim(),
      category: _category,
      imageUrl: _imageUrlController.text.trim(),
    );

    Achievement? saved;
    setState(() => _isSubmitting = true);
    try {
      saved = await apiClient.createAchievement(newAchievement, token: token);
      if (!mounted) return;
      PortfolioStore.instance.addAchievement(saved);
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        // Token tidak valid/kedaluwarsa: logout lalu minta login ulang.
        await auth.logout();
        if (!mounted) return;
        showInfoSnackBar(context, 'Sesi berakhir. Silakan login kembali.');
        await ensureLoggedIn(context);
      } else {
        showInfoSnackBar(
          context,
          'Gagal menyimpan sertifikasi (status ${e.statusCode}).',
        );
      }
      return;
    } catch (_) {
      if (!mounted) return;
      showInfoSnackBar(
        context,
        'Tidak dapat terhubung ke server. Pastikan backend Django berjalan.',
      );
      return;
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
    final achievement = saved;
    if (!mounted || achievement == null) return;
    showSummaryDialog(
      context,
      title: 'Certification Saved!',
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
      onClosed: _finish,
    );
  }

  /// Menutup form setelah dialog sukses: kembali ke daftar yang membukanya,
  /// atau membuka daftar sertifikasi agar data baru langsung terlihat.
  void _finish() {
    if (!mounted) return;
    if (widget.popOnSuccess) {
      Navigator.pop(context, true);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AchievementListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: oceanAppBar(title: 'Add Certification'),
      // Drawer yang sama dengan halaman utama.
      drawer: const LeftDrawer(selected: DrawerDestination.certification),
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
                      kind: FormKind.certification,
                      title: 'Add Certification',
                      subtitle: 'Fill in your certification details below.',
                    ),
                    FormCard(
                      children: [
                        // === Nama Penghargaan ===
                        LabeledField(
                          label: 'Nama Penghargaan',
                          isRequired: true,
                          child: TextFormField(
                            key: const Key('titleField'),
                            controller: _titleController,
                            maxLength: _titleMaxLength,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: oceanInputDecoration(
                              hint: 'Contoh: Juara 1 Mencintai Diri Sendiri',
                              prefixIcon: const Icon(
                                Icons.emoji_events_outlined,
                              ),
                            ),
                            validator: (value) => FormValidators.requiredText(
                              value,
                              fieldName: 'Nama penghargaan',
                              maxLength: _titleMaxLength,
                            ),
                          ),
                        ),
                        // === Deskripsi ===
                        LabeledField(
                          label: 'Deskripsi Penghargaan',
                          isRequired: true,
                          child: TextFormField(
                            key: const Key('descriptionField'),
                            controller: _descriptionController,
                            minLines: 3,
                            maxLines: 5,
                            maxLength: _descriptionMaxLength,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: oceanInputDecoration(
                              hint: 'Ceritakan penghargaanmu',
                              showCounter: true,
                            ),
                            validator: (value) => FormValidators.requiredText(
                              value,
                              fieldName: 'Deskripsi penghargaan',
                              maxLength: _descriptionMaxLength,
                            ),
                          ),
                        ),
                        // === Kategori ===
                        LabeledField(
                          label: 'Kategori Penghargaan',
                          isRequired: true,
                          child: DropdownButtonFormField<AchievementCategory>(
                            key: const Key('categoryField'),
                            decoration: oceanInputDecoration(
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
                        DateFormField(
                          key: const Key('startDateField'),
                          controller: _startDateController,
                          label: 'Tanggal Mulai',
                          isRequired: true,
                          onTap: () => _pickDate(isStart: true),
                          validator: (_) => FormValidators.requiredDate(
                            _startDate,
                            fieldName: 'Tanggal mulai',
                          ),
                        ),
                        // === Tanggal Selesai (opsional) ===
                        DateFormField(
                          key: const Key('endDateField'),
                          controller: _endDateController,
                          label: 'Tanggal Selesai (opsional)',
                          onTap: () => _pickDate(isStart: false),
                          onClear: _endDate == null ? null : _clearEndDate,
                          clearTooltip: 'Hapus tanggal selesai',
                          validator: (_) =>
                              FormValidators.dateOrder(_startDate, _endDate),
                        ),
                        // Pratinjau periode yang akan disimpan.
                        if (_startDate != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: OceanColors.aqua.withValues(alpha: 0.6),
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
                        LabeledField(
                          label: 'URL Gambar Penghargaan (opsional)',
                          child: TextFormField(
                            key: const Key('imageUrlField'),
                            controller: _imageUrlController,
                            maxLength: _imageUrlMaxLength,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            decoration: oceanInputDecoration(
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
                      ],
                    ),
                    // === Tombol Simpan ===
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                      child: _isSubmitting
                          ? const Center(child: CircularProgressIndicator())
                          : OceanButton(
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
