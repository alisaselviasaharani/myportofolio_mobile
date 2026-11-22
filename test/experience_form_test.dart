import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';

final _positionField = find.byKey(const Key('positionField'));
final _companyField = find.byKey(const Key('companyField'));
final _descriptionField = find.byKey(const Key('descriptionField'));
final _linkField = find.byKey(const Key('linkField'));
final _saveButton = find.widgetWithText(ElevatedButton, 'Simpan');

Future<void> _pumpForm(WidgetTester tester) async {
  // Layar setinggi cukup agar semua field terlihat tanpa menggulir.
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MaterialApp(home: ExperienceFormPage()));
}

void main() {
  setUp(() => PortfolioStore.instance.clear());

  testWidgets('Simpan dengan input kosong menampilkan error tiap kolom',
      (tester) async {
    await _pumpForm(tester);

    await tester.tap(_saveButton);
    await tester.pump();

    expect(find.text('Posisi tidak boleh kosong!'), findsOneWidget);
    expect(
      find.text('Perusahaan / organisasi tidak boleh kosong!'),
      findsOneWidget,
    );
    expect(find.text('Deskripsi tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    expect(PortfolioStore.instance.experienceCount.value, 0);
  });

  testWidgets('Tautan yang tidak valid ditolak', (tester) async {
    await _pumpForm(tester);

    await tester.enterText(_positionField, 'Backend Intern');
    await tester.enterText(_companyField, 'PT Contoh');
    await tester.enterText(_descriptionField, 'Membuat REST API.');
    await tester.enterText(_linkField, 'bukan-url');
    await tester.tap(_saveButton);
    await tester.pump();

    expect(
      find.text(
        'Tautan harus berupa URL valid (diawali http:// atau https://)!',
      ),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Input valid menampilkan dialog ringkasan, OK mereset form',
      (tester) async {
    await _pumpForm(tester);

    await tester.enterText(_positionField, 'Backend Intern');
    await tester.enterText(_companyField, 'PT Contoh');
    await tester.enterText(_descriptionField, 'Membuat REST API.');
    await tester.tap(_saveButton);
    await tester.pumpAndSettle();

    final dialog = find.byType(AlertDialog);
    expect(dialog, findsOneWidget);
    for (final text in [
      'Experience berhasil ditambahkan!',
      'Backend Intern',
      'PT Contoh',
      'Membuat REST API.',
      'Full-time',
    ]) {
      expect(
        find.descendant(of: dialog, matching: find.text(text)),
        findsOneWidget,
        reason: 'Dialog harus menampilkan "$text"',
      );
    }
    expect(PortfolioStore.instance.experienceCount.value, 1);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    final position = tester.widget<EditableText>(
      find.descendant(of: _positionField, matching: find.byType(EditableText)),
    );
    expect(position.controller.text, isEmpty);
  });
}
