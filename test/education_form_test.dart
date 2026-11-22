import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/utils/period_format.dart';

final _institutionField = find.byKey(const Key('institutionField'));
final _majorField = find.byKey(const Key('majorField'));
final _startDateField = find.byKey(const Key('startDateField'));
final _endDateField = find.byKey(const Key('endDateField'));
final _websiteField = find.byKey(const Key('websiteField'));
final _saveButton = find.widgetWithText(ElevatedButton, 'Simpan');

Future<void> _pumpForm(WidgetTester tester) async {
  // Layar setinggi cukup agar semua field terlihat tanpa menggulir.
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MaterialApp(home: EducationFormPage()));
}

Future<void> _pickDate(WidgetTester tester, Finder field) async {
  await tester.tap(field);
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

Future<void> _fillRequired(WidgetTester tester) async {
  await tester.enterText(_institutionField, 'Universitas Indonesia');
  await tester.enterText(_majorField, 'Ilmu Komputer');
  await _pickDate(tester, _startDateField);
  await _pickDate(tester, _endDateField);
}

void main() {
  testWidgets('Simpan dengan input kosong menampilkan error tiap kolom',
      (tester) async {
    await _pumpForm(tester);

    await tester.tap(_saveButton);
    await tester.pump();

    expect(find.text('Institusi tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Jurusan tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Tanggal mulai harus dipilih!'), findsOneWidget);
    expect(find.text('Tanggal selesai harus dipilih!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Institusi yang hanya berisi spasi ditolak', (tester) async {
    await _pumpForm(tester);

    await tester.enterText(_institutionField, '     ');
    await tester.enterText(_majorField, 'Ilmu Komputer');
    await _pickDate(tester, _startDateField);
    await _pickDate(tester, _endDateField);
    await tester.tap(_saveButton);
    await tester.pump();

    expect(find.text('Institusi tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('URL website yang tidak valid ditolak', (tester) async {
    await _pumpForm(tester);

    await _fillRequired(tester);
    await tester.enterText(_websiteField, 'www.ui.ac.id');
    await tester.tap(_saveButton);
    await tester.pump();

    expect(
      find.text(
        'URL website harus berupa URL valid (diawali http:// atau https://)!',
      ),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Input valid menampilkan dialog ringkasan, OK mereset form',
      (tester) async {
    await _pumpForm(tester);

    await _fillRequired(tester);
    await tester.enterText(_websiteField, 'https://www.ui.ac.id');
    await tester.tap(_saveButton);
    await tester.pumpAndSettle();

    final dialog = find.byType(AlertDialog);
    expect(dialog, findsOneWidget);
    for (final text in [
      'Education Saved!',
      'Universitas Indonesia',
      'S1 - Ilmu Komputer',
      'https://www.ui.ac.id',
    ]) {
      expect(
        find.descendant(of: dialog, matching: find.text(text)),
        findsOneWidget,
        reason: 'Dialog harus menampilkan "$text"',
      );
    }
    // Tanggal mulai dan selesai sama-sama hari ini.
    expect(
      find.descendant(
        of: dialog,
        matching: find.text(formatDate(DateTime.now())),
      ),
      findsNWidgets(2),
    );

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    final institution = tester.widget<EditableText>(
      find.descendant(
        of: _institutionField,
        matching: find.byType(EditableText),
      ),
    );
    expect(institution.controller.text, isEmpty);
  });
}
