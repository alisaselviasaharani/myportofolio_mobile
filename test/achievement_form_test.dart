import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/screens/achievement_form.dart';
import 'package:myportofolio_mobile/utils/period_format.dart';
import 'package:myportofolio_mobile/widgets/ocean_button.dart';

final _titleField = find.byKey(const Key('titleField'));
final _descriptionField = find.byKey(const Key('descriptionField'));
final _startDateField = find.byKey(const Key('startDateField'));
final _imageUrlField = find.byKey(const Key('imageUrlField'));
final _saveButton = find.widgetWithText(OceanButton, 'Simpan');
const _title = 'Juara 1 Mencintai Diri Sendiri';
Future<void> _pumpForm(WidgetTester tester) async {
  // Layar setinggi cukup agar semua field terlihat tanpa menggulir.
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MaterialApp(home: AchievementFormPage()));
}

Future<void> _pickStartDate(WidgetTester tester) async {
  await tester.tap(_startDateField);
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

Future<void> _fillRequired(WidgetTester tester) async {
  await tester.enterText(_titleField, _title);
  await tester.enterText(_descriptionField, 'Juara pertama tingkat nasional.');
  await _pickStartDate(tester);
}

void main() {
  setUp(() => PortfolioStore.instance.clear());

  testWidgets('Simpan dengan input kosong menampilkan error tiap kolom', (
    tester,
  ) async {
    await _pumpForm(tester);

    await tester.tap(_saveButton);
    await tester.pump();

    expect(find.text('Nama penghargaan tidak boleh kosong!'), findsOneWidget);
    expect(
      find.text('Deskripsi penghargaan tidak boleh kosong!'),
      findsOneWidget,
    );
    expect(find.text('Tanggal mulai harus dipilih!'), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('Nama yang hanya berisi spasi ditolak', (tester) async {
    await _pumpForm(tester);

    await tester.enterText(_titleField, '     ');
    await tester.enterText(_descriptionField, 'Deskripsi');
    await _pickStartDate(tester);
    await tester.tap(_saveButton);
    await tester.pump();

    expect(find.text('Nama penghargaan tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
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
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('Input valid menampilkan dialog ringkasan, OK mereset form', (
    tester,
  ) async {
    await _pumpForm(tester);

    await _fillRequired(tester);
    await tester.tap(find.byKey(const Key('categoryField')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Competition').last);
    await tester.pumpAndSettle();
    await tester.enterText(_imageUrlField, 'https://contoh.com/gambar.png');
    await tester.tap(_saveButton);
    await tester.pumpAndSettle();

    final dialog = find.byType(Dialog);
    expect(dialog, findsOneWidget);
    for (final text in [
      'Certification Saved!',
      _title,
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

    // Data valid tersimpan di PortfolioStore.
    expect(PortfolioStore.instance.achievements.value, hasLength(1));

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsNothing);
    final titleText = tester.widget<EditableText>(
      find.descendant(of: _titleField, matching: find.byType(EditableText)),
    );
    expect(titleText.controller.text, isEmpty);
  });
}
