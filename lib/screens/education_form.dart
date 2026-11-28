import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/course_parser.dart';
import 'package:myportofolio_mobile/utils/period_format.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/date_form_field.dart';
import 'package:myportofolio_mobile/widgets/labeled_field.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';
import 'package:myportofolio_mobile/widgets/ocean_button.dart';
import 'package:myportofolio_mobile/widgets/summary_dialog.dart';

/// Halaman "Tambah Pendidikan" (dan "Edit Pendidikan" jika [education]
/// diberikan), mengikuti mockup: Institusi, Jenjang, Program Studi, Tanggal
/// Mulai/Selesai, centang status mahasiswa, Deskripsi, dan Mata Kuliah Relevan.
///
/// Saat mengedit, Simpan memperbarui data di [PortfolioStore] lalu menutup
/// halaman dengan mengembalikan [Education] yang baru (`Navigator.pop`).
class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key, this.education});

  /// Data yang diedit; `null` berarti menambah data baru.
  final Education? education;

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  // Batas panjang mengikuti model Django. Program studi dibatasi 90 agar
  // gabungan "jenjang - program studi" tetap di bawah 100 karakter.
  static const int _institutionMaxLength = 100;
  static const int _majorMaxLength = 90;
  static const int _descriptionMaxLength = 500;

  final _formKey = GlobalKey<FormState>();
  final _institutionController = TextEditingController();
  final _majorController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _coursesController = TextEditingController();

  DegreeLevel? _level;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrent = false;

  bool get _isEditing => widget.education != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.education;
    if (initial == null) {
      return;
    }
    _institutionController.text = initial.institution;
    _majorController.text = initial.major;
    _descriptionController.text = initial.description;
    _coursesController.text = initial.courses.join(', ');
    _level = initial.level;
    _startDate = initial.startDate;
    _endDate = initial.endDate;
    _isCurrent = initial.isCurrent;
    final start = initial.startDate;
    if (start != null) {
      _startDateController.text = formatMonthYear(start);
    }
    final end = initial.endDate;
    if (end != null) {
      _endDateController.text = formatMonthYear(end);
    }
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _majorController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    _coursesController.dispose();
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
        _startDateController.text = formatMonthYear(picked);
      } else {
        _endDate = picked;
        _endDateController.text = formatMonthYear(picked);
      }
    });
  }

  /// Dipanggil tombol Simpan: validasi dulu, dialog hanya jika semua valid.
  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final level = _level!;
    final start = _startDate!;
    final end = _endDate;
    final major = _majorController.text.trim();
    final original = widget.education;
    final education = Education(
      id: original?.id,
      logo: original?.logo ?? '',
      institution: _institutionController.text.trim(),
      degree: '${level.label} - $major',
      level: level,
      major: major,
      startDate: start,
      endDate: end,
      isCurrent: _isCurrent,
      period: formatMonthPeriod(start, end, isCurrent: _isCurrent),
      description: _descriptionController.text.trim(),
      courses: parseCourses(_coursesController.text),
      website: original?.website ?? '',
    );
    if (original == null) {
      PortfolioStore.instance.addEducation(education);
    } else {
      PortfolioStore.instance.updateEducation(original, education);
    }
    showSummaryDialog(
      context,
      title: original == null ? 'Education Saved!' : 'Education Updated!',
      message: 'Here is the summary of your input:',
      items: [
        SummaryItem(
          label: 'Institusi',
          value: education.institution,
          icon: Icons.account_balance_outlined,
        ),
        SummaryItem(
          label: 'Jenjang',
          value: level.fullLabel,
          icon: Icons.school_outlined,
        ),
        SummaryItem(
          label: 'Program Studi',
          value: education.major,
          icon: Icons.menu_book_outlined,
        ),
        SummaryItem(
          label: 'Periode',
          value: education.period,
          icon: Icons.calendar_today_outlined,
        ),
        SummaryItem(
          label: 'Status',
          value: education.statusLabel,
          icon: Icons.verified_outlined,
        ),
        SummaryItem(
          label: 'Mata Kuliah Relevan',
          value: education.courses.join(', '),
          icon: Icons.library_books_outlined,
        ),
      ],
      onClosed: () {
        if (!mounted) {
          return;
        }
        if (original == null) {
          _resetForm();
        } else {
          Navigator.pop(context, education);
        }
      },
    );
  }

  /// Mengembalikan form dan semua state ke kondisi awal.
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _level = null;
      _startDate = null;
      _endDate = null;
      _isCurrent = false;
      _startDateController.clear();
      _endDateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: oceanAppBar(
        title: _isEditing ? 'Edit Pendidikan' : 'Tambah Pendidikan',
        centerTitle: true,
      ),
      // Drawer yang sama dengan halaman lain.
      drawer: const LeftDrawer(selected: DrawerDestination.education),
      bottomNavigationBar: const OceanBottomBar(portfolioSelected: true),
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
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, top + 8, 16, 130),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            hint: 'Masukkan nama institusi',
                            radius: 22,
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
                          isExpanded: true,
                          decoration: oceanInputDecoration(radius: 22),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconEnabledColor: OceanColors.navy,
                          hint: const Text(
                            'Pilih jenjang pendidikan',
                            style: TextStyle(color: Colors.black38),
                          ),
                          // Nilai awal tetap agar reset() kembali ke kosong.
                          initialValue: widget.education?.level,
                          items: DegreeLevel.values
                              .map(
                                (level) => DropdownMenuItem(
                                  value: level,
                                  child: Text(level.fullLabel),
                                ),
                              )
                              .toList(),
                          onChanged: (value) => setState(() => _level = value),
                          validator: (value) =>
                              value == null ? 'Jenjang harus dipilih!' : null,
                        ),
                      ),
                      // === Program Studi ===
                      LabeledField(
                        label: 'Program Studi',
                        isRequired: true,
                        child: TextFormField(
                          key: const Key('majorField'),
                          controller: _majorController,
                          maxLength: _majorMaxLength,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          decoration: oceanInputDecoration(
                            hint: 'Masukkan program studi',
                            radius: 22,
                          ),
                          validator: (value) => FormValidators.requiredText(
                            value,
                            fieldName: 'Program studi',
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
                        trailingIcon: true,
                        onTap: () => _pickDate(isStart: true),
                        validator: (_) => FormValidators.requiredDate(
                          _startDate,
                          fieldName: 'Tanggal mulai',
                        ),
                      ),
                      // === Tanggal Selesai (opsional, tidak sebelum mulai) ===
                      DateFormField(
                        key: const Key('endDateField'),
                        controller: _endDateController,
                        label: 'Tanggal Selesai',
                        trailingIcon: true,
                        onTap: () => _pickDate(isStart: false),
                        validator: (_) =>
                            FormValidators.dateOrder(_startDate, _endDate),
                      ),
                      // === Status mahasiswa ===
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: InkWell(
                          key: const Key('currentCheckbox'),
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => setState(() => _isCurrent = !_isCurrent),
                          child: Row(
                            children: [
                              Checkbox(
                                value: _isCurrent,
                                activeColor: OceanColors.deep,
                                side: const BorderSide(
                                  color: OceanColors.navy,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                onChanged: (value) =>
                                    setState(() => _isCurrent = value ?? false),
                              ),
                              const SizedBox(width: 4),
                              const Expanded(
                                child: Text(
                                  'Masih berstatus sebagai mahasiswa',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: OceanColors.navy,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // === Deskripsi (opsional) ===
                      LabeledField(
                        label: 'Deskripsi',
                        isOptional: true,
                        child: TextFormField(
                          key: const Key('descriptionField'),
                          controller: _descriptionController,
                          maxLength: _descriptionMaxLength,
                          minLines: 3,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: oceanInputDecoration(
                            hint: 'Ceritakan singkat tentang pendidikan ini...',
                            radius: 20,
                          ),
                        ),
                      ),
                      // === Mata Kuliah Relevan (opsional) ===
                      LabeledField(
                        label: 'Mata Kuliah Relevan',
                        isOptional: true,
                        child: TextFormField(
                          key: const Key('coursesField'),
                          controller: _coursesController,
                          textInputAction: TextInputAction.done,
                          decoration: oceanInputDecoration(
                            hint: 'Tambahkan mata kuliah, pisahkan dengan koma',
                            radius: 22,
                          ),
                          validator: validateCourses,
                        ),
                      ),
                      // === Tombol Simpan ===
                      Padding(
                        padding: const EdgeInsets.fromLTRB(36, 18, 36, 0),
                        child: OceanButton(
                          label: 'Simpan',
                          onPressed: _submit,
                          colors: const [
                            OceanColors.purpleStart,
                            OceanColors.purpleEnd,
                          ],
                          shadowColor: OceanColors.purpleEnd,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
