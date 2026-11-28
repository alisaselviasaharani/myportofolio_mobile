import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/ocean_button.dart';
import 'package:provider/provider.dart';

final _positionField = find.byKey(const Key('positionField'));
final _companyField = find.byKey(const Key('companyField'));
final _descriptionField = find.byKey(const Key('descriptionField'));
final _linkField = find.byKey(const Key('linkField'));
final _saveButton = find.widgetWithText(OceanButton, 'Simpan');

Future<void> _pumpForm(WidgetTester tester) async {
  // Layar setinggi cukup agar semua field terlihat tanpa menggulir.
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  // Server palsu: membalas 201 dengan data yang dikirim + id.
  final client = ApiClient(
    baseUrl: 'http://test',
    client: MockClient((request) async {
      // Daftar yang terbuka setelah berhasil menyimpan memuat data lewat GET.
      if (request.method == 'GET') {
        return http.Response('[]', 200);
      }
      expect(request.headers['Authorization'], 'Token tok');
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(jsonEncode({...body, 'id': 'abc'}), 201);
    }),
  );
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider.value(value: client),
        // Sudah login, jadi guard langsung lolos.
        ChangeNotifierProvider(
          create: (_) => AuthState(client, initialToken: 'tok'),
        ),
      ],
      child: const MaterialApp(home: ExperienceFormPage()),
    ),
  );
}

void main() {
  setUp(() => PortfolioStore.instance.clear());

  testWidgets('Simpan dengan input kosong menampilkan error tiap kolom', (
    tester,
  ) async {
    await _pumpForm(tester);

    await tester.tap(_saveButton);
    await tester.pump();

    expect(find.text('Posisi tidak boleh kosong!'), findsOneWidget);
    expect(
      find.text('Perusahaan / organisasi tidak boleh kosong!'),
      findsOneWidget,
    );
    expect(find.text('Deskripsi tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
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
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('Input valid menampilkan dialog, OK membuka daftar', (
    tester,
  ) async {
    await _pumpForm(tester);

    await tester.enterText(_positionField, 'Backend Intern');
    await tester.enterText(_companyField, 'PT Contoh');
    await tester.enterText(_descriptionField, 'Membuat REST API.');
    await tester.tap(_saveButton);
    await tester.pumpAndSettle();

    final dialog = find.byType(Dialog);
    expect(dialog, findsOneWidget);
    for (final text in [
      'Experience Saved!',
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

    // Form ditutup dan diganti daftar experience.
    expect(find.byType(Dialog), findsNothing);
    expect(find.byType(ExperienceFormPage), findsNothing);
    expect(find.byType(ExperienceListScreen), findsOneWidget);
  });

  testWidgets('Dibuka dari daftar: OK kembali ke daftar', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final client = ApiClient(
      baseUrl: 'http://test',
      client: MockClient((request) async {
        if (request.method == 'GET') {
          return http.Response('[]', 200);
        }
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({...body, 'id': 'abc'}), 201);
      }),
    );
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: client),
          ChangeNotifierProvider(
            create: (_) => AuthState(client, initialToken: 'tok'),
          ),
        ],
        child: const MaterialApp(home: ExperienceListScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('addExperienceButton')));
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceFormPage), findsOneWidget);

    await tester.enterText(_positionField, 'Backend Intern');
    await tester.enterText(_companyField, 'PT Contoh');
    await tester.enterText(_descriptionField, 'Membuat REST API.');
    await tester.tap(_saveButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.byType(ExperienceFormPage), findsNothing);
    expect(find.byType(ExperienceListScreen), findsOneWidget);
  });
}
