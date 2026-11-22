import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/achievement_form.dart';
import 'package:myportofolio_mobile/utils/period_format.dart';

final _titleField = find.byKey(const Key('titleField'));
final _descriptionField = find.byKey(const Key('descriptionField'));
final _startDateField = find.byKey(const Key('startDateField'));
final _imageUrlField = find.byKey(const Key('imageUrlField'));
final _saveButton = find.widgetWithText(ElevatedButton, 'Simpan');

Future<void> _pumpForm(WidgetTester tester) async {
  // Layar setinggi cukup agar semua field terlihat tanpa menggulir.
  tester.view.physicalSize = const Size(800, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    const MaterialApp(home: AchievementFormPage()),
  );
}

Future<void> _pickStartDate(WidgetTester tester) async {
  await tester.tap(_startDateField);
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

Future<void> _fillRequired(WidgetTester tester) async {
  await tester.enterText(_titleField, 'Juara 1 Hackathon');
  await tester.enterText(_descriptionField, 'Juara pertama tingkat nasional.');
  await _pickStartDate(tester);
}

void main() {
  testWidgets('Simpan dengan input kosong menampilkan error tiap kolom',
      (tester) async {
    await _pumpForm(tester);

    await tester.tap(_saveButton);
    await tester.pump();

    expect(find.text('Nama penghargaan tidak boleh kosong!'), findsOneWidget);
    expect(
      find.text('Deskripsi penghargaan tidak boleh kosong!'),
      findsOneWidget,
    );
    expect(find.text('Tanggal mulai harus dipilih!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Nama yang hanya berisi spasi ditolak', (tester) async {
    await _pumpForm(tester);

    await tester.enterText(_titleField, '     ');
    await tester.enterText(_descriptionField, 'Deskripsi');
    await _pickStartDate(tester);
    await tester.tap(_saveButton);
    await tester.pump();

    expect(find.text('Nama penghargaan tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('URL gambar yang tidak valid ditolak', (tester) async {
    await _pumpForm(tester);

    await _fillRequired(tester);
    await tester.enterText(_imageUrlField, 'www.google.com');
    await tester.tap(_saveButton);
    await tester.pump();

    expect(
      find.text(
        'URL gambar harus berupa URL valid (diawali http:// atau https://)!',
      ),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Input valid menampilkan dialog ringkasan, Tutup mereset form',
      (tester) async {
    await _pumpForm(tester);

    await _fillRequired(tester);
    await tester.tap(find.byKey(const Key('categoryField')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Competition').last);
    await tester.pumpAndSettle();
    await tester.enterText(_imageUrlField, 'https://contoh.com/gambar.png');
    await tester.tap(_saveButton);
    await tester.pumpAndSettle();

    final dialog = find.byType(AlertDialog);
    expect(dialog, findsOneWidget);
    for (final text in [
      'Achievement berhasil ditambahkan!',
      'Juara 1 Hackathon',
      'Juara pertama tingkat nasional.',
      'Competition',
      formatDate(DateTime.now()),
      'https://contoh.com/gambar.png',
    ]) {
      expect(
        find.descendant(of: dialog, matching: find.text(text)),
        findsOneWidget,
        reason: 'Dialog harus menampilkan "$text"',
      );
    }

    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    final titleText = tester.widget<EditableText>(
      find.descendant(of: _titleField, matching: find.byType(EditableText)),
    );
    expect(titleText.controller.text, isEmpty);
  });
}
