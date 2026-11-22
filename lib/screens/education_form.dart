import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/period_format.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/date_form_field.dart';
import 'package:myportofolio_mobile/widgets/form_header.dart';
import 'package:myportofolio_mobile/widgets/labeled_field.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';
import 'package:myportofolio_mobile/widgets/ocean_button.dart';
import 'package:myportofolio_mobile/widgets/summary_dialog.dart';

/// Halaman formulir untuk menambah riwayat pendidikan.
///
/// Field mengikuti model Django `Education`: institusi, jenjang + jurusan
/// (menjadi `degree`), periode (dari dua tanggal), dan website opsional.
class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  // Batas panjang mengikuti model Django. Jurusan dibatasi 90 agar gabungan
  // "jenjang - jurusan" tetap di bawah 100 karakter.
  static const int _institutionMaxLength = 100;
  static const int _majorMaxLength = 90;
  static const int _websiteMaxLength = 255;
  static const DegreeLevel _defaultLevel = DegreeLevel.bachelor;

  final _formKey = GlobalKey<FormState>();
  final _institutionController = TextEditingController();
  final _majorController = TextEditingController();
  final _websiteController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  DegreeLevel _level = _defaultLevel;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _institutionController.dispose();
    _majorController.dispose();
    _websiteController.dispose();
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

  /// Dipanggil tombol Simpan: validasi dulu, dialog hanya jika semua valid.
  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final start = _startDate!;
    final end = _endDate!;
    final education = Education(
      institution: _institutionController.text.trim(),
      degree: '${_level.label} - ${_majorController.text.trim()}',
      startDate: start,
      endDate: end,
      period: formatPeriod(start, end),
      website: _websiteController.text.trim(),
    );
    PortfolioStore.instance.addEducation(education);
    showSummaryDialog(
      context,
      title: 'Education Saved!',
      message: 'Here is the summary of your input:',
      items: [
        SummaryItem(
          label: 'Institution',
          value: education.institution,
          icon: Icons.account_balance_outlined,
        ),
        SummaryItem(
          label: 'Degree',
          value: education.degree,
          icon: Icons.school_outlined,
        ),
        SummaryItem(
          label: 'Start Date',
          value: formatDate(education.startDate),
          icon: Icons.calendar_today_outlined,
        ),
        SummaryItem(
          label: 'End Date',
          value: formatDate(education.endDate),
          icon: Icons.event_available_outlined,
        ),
        SummaryItem(
          label: 'Website',
          value: education.website,
          icon: Icons.link,
        ),
      ],
      onClosed: _resetForm,
    );
  }

  /// Mengembalikan form dan semua state ke kondisi awal.
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _level = _defaultLevel;
      _startDate = null;
      _endDate = null;
      _startDateController.clear();
      _endDateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: oceanAppBar(title: 'Add Education Form'),
      // Drawer yang sama dengan halaman lain.
      drawer: const LeftDrawer(selected: DrawerDestination.education),
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
                      emoji: '🎓',
                      title: 'Add Education',
                      subtitle: 'Fill in your education details below.',
                    ),
                    // === Institusi ===
                    LabeledField(
                      label: 'Institusi',
                      isRequired: true,
                      child: TextFormField(
                        key: const Key('institutionField'),
                        controller: _institutionController,
                        maxLength: _institutionMaxLength,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: oceanInputDecoration(
                          hint: 'Contoh: Universitas Indonesia',
                          prefixIcon: const Icon(Icons.account_balance_outlined),
                        ),
                        validator: (value) => FormValidators.requiredText(
                          value,
                          fieldName: 'Institusi',
                          maxLength: _institutionMaxLength,
                        ),
                      ),
                    ),
                    // === Jenjang ===
                    LabeledField(
                      label: 'Jenjang',
                      isRequired: true,
                      child: DropdownButtonFormField<DegreeLevel>(
                        key: const Key('levelField'),
                        decoration: oceanInputDecoration(
                          prefixIcon: const Icon(Icons.school_outlined),
                        ),
                        // Nilai awal konstan agar reset() kembali ke default.
                        initialValue: _defaultLevel,
                        items: DegreeLevel.values
                            .map(
                              (level) => DropdownMenuItem(
                                value: level,
                                child: Text(level.label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _level = value);
                          }
                        },
                      ),
                    ),
                    // === Jurusan ===
                    LabeledField(
                      label: 'Jurusan',
                      isRequired: true,
                      child: TextFormField(
                        key: const Key('majorField'),
                        controller: _majorController,
                        maxLength: _majorMaxLength,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: oceanInputDecoration(
                          hint: 'Contoh: Ilmu Komputer',
                          prefixIcon: const Icon(Icons.menu_book_outlined),
                        ),
                        validator: (value) => FormValidators.requiredText(
                          value,
                          fieldName: 'Jurusan',
                          maxLength: _majorMaxLength,
                        ),
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
                    // === Tanggal Selesai (wajib, tidak sebelum mulai) ===
                    DateFormField(
                      key: const Key('endDateField'),
                      controller: _endDateController,
                      label: 'Tanggal Selesai',
                      isRequired: true,
                      onTap: () => _pickDate(isStart: false),
                      validator: (_) =>
                          FormValidators.requiredDate(
                            _endDate,
                            fieldName: 'Tanggal selesai',
                          ) ??
                          FormValidators.dateOrder(_startDate, _endDate),
                    ),
                    // === Website (opsional) ===
                    LabeledField(
                      label: 'Website (opsional)',
                      child: TextFormField(
                        key: const Key('websiteField'),
                        controller: _websiteController,
                        maxLength: _websiteMaxLength,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        decoration: oceanInputDecoration(
                          hint: 'https://www.ui.ac.id',
                          prefixIcon: const Icon(Icons.link),
                        ),
                        validator: (value) => FormValidators.optionalUrl(
                          value,
                          fieldName: 'URL website',
                          maxLength: _websiteMaxLength,
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
