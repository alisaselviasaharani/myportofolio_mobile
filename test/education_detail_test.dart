import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_detail_screen.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

final Education _ui = Education(
  institution: 'Universitas Indonesia',
  degree: 'S1 - Ilmu Komputer',
  level: DegreeLevel.bachelor,
  major: 'Ilmu Komputer',
  startDate: DateTime(2023, 9, 1),
  endDate: DateTime(2027, 6, 1),
  isCurrent: true,
  period: 'Sep 2023 – Jun 2027',
  description: 'Program studi Ilmu Komputer yang berfokus pada perangkat lunak.',
  courses: const ['Algoritma', 'Struktur Data', 'Basis Data'],
);

Future<void> _pumpDetail(WidgetTester tester, Education education) async {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  // Form edit butuh ApiClient dan AuthState (server tidak dipanggil di sini).
  final client = ApiClient(
    baseUrl: 'http://test',
    client: MockClient((request) async => throw StateError('tidak dipakai')),
  );
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider.value(value: client),
        ChangeNotifierProvider(
          create: (_) => AuthState(client, initialToken: 'tok'),
        ),
      ],
      child: MaterialApp(home: EducationDetailScreen(education: education)),
    ),
  );
}

void main() {
  setUp(() => PortfolioStore.instance.clear());

  testWidgets('Menampilkan seluruh bagian detail sesuai mockup', (
    tester,
  ) async {
    await _pumpDetail(tester, _ui);

    for (final text in [
      'Detail Pendidikan',
      'Universitas Indonesia',
      'Jenjang',
      'S1 (Sarjana)',
      'Program Studi',
      'Ilmu Komputer',
      'Periode',
      'Sep 2023 – Jun 2027',
      'Status',
      'Aktif',
      'Deskripsi',
      'Mata Kuliah Relevan',
      'Algoritma',
      'Struktur Data',
      'Basis Data',
    ]) {
      expect(find.text(text), findsOneWidget, reason: 'Harus ada "$text"');
    }
    expect(find.byTooltip('Edit pendidikan'), findsOneWidget);
    expect(find.byTooltip('Bagikan'), findsOneWidget);
  });

  testWidgets('Deskripsi dan mata kuliah disembunyikan jika kosong', (
    tester,
  ) async {
    final minimal = Education(
      institution: 'SMA Negeri 8 Jakarta',
      degree: 'SMA - IPA',
      level: DegreeLevel.highSchool,
      major: 'IPA',
      startDate: DateTime(2020, 7, 1),
      period: 'Jul 2020',
    );
    await _pumpDetail(tester, minimal);

    expect(find.text('Lulus'), findsOneWidget);
    expect(find.text('Deskripsi'), findsNothing);
    expect(find.text('Mata Kuliah Relevan'), findsNothing);
  });

  testWidgets('Tombol bagikan menampilkan SnackBar', (tester) async {
    await _pumpDetail(tester, _ui);

    await tester.tap(find.byTooltip('Bagikan'));
    await tester.pump();

    expect(
      find.text('Ringkasan pendidikan disalin ke clipboard.'),
      findsOneWidget,
    );
  });

  testWidgets('Tombol edit membuka form berisi data yang sama', (tester) async {
    PortfolioStore.instance.addEducation(_ui);
    await _pumpDetail(tester, _ui);

    await tester.tap(find.byTooltip('Edit pendidikan'));
    await tester.pumpAndSettle();

    expect(find.byType(EducationFormPage), findsOneWidget);
    expect(find.text('Edit Pendidikan'), findsOneWidget);
    expect(find.text('Universitas Indonesia'), findsOneWidget);
  });
}
