import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/form_header.dart';
import 'package:myportofolio_mobile/widgets/labeled_field.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';
import 'package:myportofolio_mobile/widgets/ocean_button.dart';
import 'package:myportofolio_mobile/widgets/summary_dialog.dart';

/// Halaman formulir untuk menambah experience (hasil adaptasi form tambah
/// proyek dari Tutorial 09).
///
/// Posisi, perusahaan, dan deskripsi wajib diisi; periode dan tautan
/// opsional (tautan harus URL `http`/`https` jika diisi).
class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  static const int _positionMaxLength = 255;
  static const int _companyMaxLength = 100;
  static const int _descriptionMaxLength = 500;
  static const int _periodMaxLength = 50;
  static const int _linkMaxLength = 500;

  static const List<String> _types = [
    'Full-time',
    'Part-time',
    'Internship',
    'Freelance',
    'Volunteer',
  ];

  final _formKey = GlobalKey<FormState>();
  final _positionController = TextEditingController();
  final _companyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _periodController = TextEditingController();
  final _linkController = TextEditingController();

  String _type = _types.first;

  @override
  void dispose() {
    _positionController.dispose();
    _companyController.dispose();
    _descriptionController.dispose();
    _periodController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  /// Dipanggil tombol Simpan: validasi dulu, dialog hanya jika semua valid.
  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    PortfolioStore.instance.addExperience();
    showSummaryDialog(
      context,
      title: 'Experience berhasil ditambahkan!',
      emoji: '💼',
      items: [
        SummaryItem(
          label: 'Posisi',
          value: _positionController.text.trim(),
          icon: Icons.badge_outlined,
        ),
        SummaryItem(
          label: 'Perusahaan',
          value: _companyController.text.trim(),
          icon: Icons.business_outlined,
        ),
        SummaryItem(
          label: 'Deskripsi',
          value: _descriptionController.text.trim(),
          icon: Icons.notes_outlined,
        ),
        SummaryItem(
          label: 'Tipe',
          value: _type,
          icon: Icons.category_outlined,
        ),
        SummaryItem(
          label: 'Periode',
          value: _periodController.text.trim(),
          icon: Icons.calendar_today_outlined,
        ),
        SummaryItem(
          label: 'Tautan',
          value: _linkController.text.trim(),
          icon: Icons.link,
        ),
      ],
      onClosed: _resetForm,
    );
  }

  /// Mengembalikan form dan semua state ke kondisi awal.
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() => _type = _types.first);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: oceanAppBar(title: 'Add Experience Form'),
      // Drawer yang sama dengan halaman utama
      drawer: const LeftDrawer(selected: DrawerDestination.experience),
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
                      emoji: '💼',
                      title: 'Add Experience',
                      subtitle: 'Fill in your experience details below.',
                    ),
                    // === Position ===
                    LabeledField(
                      label: 'Posisi / Jabatan',
                      isRequired: true,
                      child: TextFormField(
                        key: const Key('positionField'),
                        controller: _positionController,
                        maxLength: _positionMaxLength,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: oceanInputDecoration(
                          hint: 'Contoh: Backend Developer Intern',
                          prefixIcon: const Icon(Icons.badge_outlined),
                        ),
                        validator: (value) => FormValidators.requiredText(
                          value,
                          fieldName: 'Posisi',
                          maxLength: _positionMaxLength,
                        ),
                      ),
                    ),
                    // === Company ===
                    LabeledField(
                      label: 'Perusahaan / Organisasi',
                      isRequired: true,
                      child: TextFormField(
                        key: const Key('companyField'),
                        controller: _companyController,
                        maxLength: _companyMaxLength,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: oceanInputDecoration(
                          hint: 'Nama Perusahaan / Organisasi',
                          prefixIcon: const Icon(Icons.business_outlined),
                        ),
                        validator: (value) => FormValidators.requiredText(
                          value,
                          fieldName: 'Perusahaan / organisasi',
                          maxLength: _companyMaxLength,
                        ),
                      ),
                    ),
                    // === Description ===
                    LabeledField(
                      label: 'Deskripsi Experience',
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
                          hint: 'Ceritakan pekerjaanmu',
                          showCounter: true,
                        ),
                        validator: (value) => FormValidators.requiredText(
                          value,
                          fieldName: 'Deskripsi',
                          maxLength: _descriptionMaxLength,
                        ),
                      ),
                    ),
                    // === Type ===
                    LabeledField(
                      label: 'Tipe Experience',
                      isRequired: true,
                      child: DropdownButtonFormField<String>(
                        key: const Key('typeField'),
                        decoration: oceanInputDecoration(
                          prefixIcon: const Icon(Icons.category_outlined),
                        ),
                        // Nilai awal konstan agar reset() kembali ke default.
                        initialValue: _types.first,
                        items: _types
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _type = value);
                          }
                        },
                      ),
                    ),
                    // === Period (opsional) ===
                    LabeledField(
                      label: 'Periode (opsional)',
                      child: TextFormField(
                        key: const Key('periodField'),
                        controller: _periodController,
                        maxLength: _periodMaxLength,
                        textInputAction: TextInputAction.next,
                        decoration: oceanInputDecoration(
                          hint: 'Contoh: Jan 2025 - Des 2025',
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                        ),
                        validator: (value) {
                          if ((value?.trim().length ?? 0) > _periodMaxLength) {
                            return 'Periode maksimal $_periodMaxLength karakter!';
                          }
                          return null;
                        },
                      ),
                    ),
                    // === Link (opsional) ===
                    LabeledField(
                      label: 'Tautan Experience (opsional)',
                      child: TextFormField(
                        key: const Key('linkField'),
                        controller: _linkController,
                        maxLength: _linkMaxLength,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        decoration: oceanInputDecoration(
                          hint: 'https://contoh.com',
                          prefixIcon: const Icon(Icons.link),
                        ),
                        validator: (value) => FormValidators.optionalUrl(
                          value,
                          fieldName: 'Tautan',
                          maxLength: _linkMaxLength,
                        ),
                      ),
                    ),
                    // === Tombol Simpan ===
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 12, 8, 24),
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
