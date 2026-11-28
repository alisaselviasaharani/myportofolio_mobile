import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/utils/period_format.dart';
import 'package:myportofolio_mobile/widgets/ocean_button.dart';

final _institutionField = find.byKey(const Key('institutionField'));
final _levelField = find.byKey(const Key('levelField'));
final _majorField = find.byKey(const Key('majorField'));
final _startDateField = find.byKey(const Key('startDateField'));
final _coursesField = find.byKey(const Key('coursesField'));
final _currentCheckbox = find.byKey(const Key('currentCheckbox'));
final _saveButton = find.widgetWithText(OceanButton, 'Simpan');

Future<void> _pumpForm(WidgetTester tester, {Education? education}) async {
  // Layar setinggi cukup agar semua field terlihat tanpa menggulir.
  tester.view.physicalSize = const Size(800, 2600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(home: EducationFormPage(education: education)),
  );
}

Future<void> _pickDate(WidgetTester tester, Finder field) async {
  await tester.tap(field);
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

Future<void> _pickLevel(WidgetTester tester, String label) async {
  await tester.tap(_levelField);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Future<void> _fillRequired(WidgetTester tester) async {
  await tester.enterText(_institutionField, 'Universitas Indonesia');
  await _pickLevel(tester, 'S1 (Sarjana)');
  await tester.enterText(_majorField, 'Ilmu Komputer');
  await _pickDate(tester, _startDateField);
}

void main() {
  setUp(() => PortfolioStore.instance.clear());

  testWidgets('Tampilan mengikuti mockup Tambah Pendidikan', (tester) async {
    await _pumpForm(tester);

    expect(find.text('Tambah Pendidikan'), findsOneWidget);
    expect(find.text('Pilih jenjang pendidikan'), findsOneWidget);
    expect(find.text('Masukkan nama institusi'), findsOneWidget);
    expect(find.text('Masih berstatus sebagai mahasiswa'), findsOneWidget);
    expect(find.text('Simpan'), findsOneWidget);
  });

  testWidgets('Simpan dengan input kosong menampilkan error tiap kolom', (
    tester,
  ) async {
    await _pumpForm(tester);

    await tester.tap(_saveButton);
    await tester.pump();

    expect(find.text('Institusi tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Jenjang harus dipilih!'), findsOneWidget);
    expect(find.text('Program studi tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Tanggal mulai harus dipilih!'), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
    expect(PortfolioStore.instance.educations.value, isEmpty);
  });

  testWidgets('Institusi yang hanya berisi spasi ditolak', (tester) async {
    await _pumpForm(tester);

    await _fillRequired(tester);
    await tester.enterText(_institutionField, '     ');
    await tester.tap(_saveButton);
    await tester.pump();

    expect(find.text('Institusi tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('Mata kuliah terlalu panjang ditolak', (tester) async {
    await _pumpForm(tester);

    await _fillRequired(tester);
    await tester.enterText(_coursesField, 'a' * 51);
    await tester.tap(_saveButton);
    await tester.pump();

    expect(find.text('Setiap mata kuliah maksimal 50 karakter!'), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('Input valid menampilkan dialog, OK mereset form', (
    tester,
  ) async {
    await _pumpForm(tester);

    await _fillRequired(tester);
    await tester.tap(_currentCheckbox);
    await tester.pump();
    await tester.enterText(_coursesField, 'Algoritma, Basis Data');
    await tester.tap(_saveButton);
    await tester.pumpAndSettle();

    final dialog = find.byType(Dialog);
    expect(dialog, findsOneWidget);
    for (final text in [
      'Education Saved!',
      'Universitas Indonesia',
      'S1 (Sarjana)',
      'Ilmu Komputer',
      'Aktif',
      'Algoritma, Basis Data',
      '${formatMonthYear(DateTime.now())} – Sekarang',
    ]) {
      expect(
        find.descendant(of: dialog, matching: find.text(text)),
        findsOneWidget,
        reason: 'Dialog harus menampilkan "$text"',
      );
    }

    // Data valid tersimpan di PortfolioStore.
    final saved = PortfolioStore.instance.educations.value;
    expect(saved, hasLength(1));
    expect(saved.first.isCurrent, isTrue);
    expect(saved.first.courses, ['Algoritma', 'Basis Data']);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsNothing);
    final institution = tester.widget<EditableText>(
      find.descendant(
        of: _institutionField,
        matching: find.byType(EditableText),
      ),
    );
    expect(institution.controller.text, isEmpty);
    expect(find.text('Pilih jenjang pendidikan'), findsOneWidget);
  });

  testWidgets('Mode edit mengisi field dan memperbarui data', (tester) async {
    final original = Education(
      institution: 'Universitas Indonesia',
      degree: 'S1 - Ilmu Komputer',
      level: DegreeLevel.bachelor,
      major: 'Ilmu Komputer',
      startDate: DateTime(2023, 9, 1),
      endDate: DateTime(2027, 6, 1),
      isCurrent: true,
      period: 'Sep 2023 – Jun 2027',
      courses: const ['Algoritma'],
    );
    PortfolioStore.instance.addEducation(original);
    await _pumpForm(tester, education: original);

    expect(find.text('Edit Pendidikan'), findsOneWidget);
    expect(find.text('Sep 2023'), findsOneWidget);
    expect(find.text('Jun 2027'), findsOneWidget);

    await tester.enterText(_majorField, 'Sistem Informasi');
    await tester.tap(_saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Education Updated!'), findsOneWidget);
    final list = PortfolioStore.instance.educations.value;
    expect(list, hasLength(1));
    expect(list.first.major, 'Sistem Informasi');
  });
}
