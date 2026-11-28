import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_detail_screen.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

Education _ui() => Education(
  id: 'ui',
  institution: 'Universitas Indonesia',
  degree: 'S1 - Ilmu Komputer',
  level: DegreeLevel.bachelor,
  major: 'Ilmu Komputer',
  startDate: DateTime(2023, 9, 1),
  endDate: DateTime(2027, 6, 1),
  isCurrent: true,
  period: 'Sep 2023 – Jun 2027',
  description: 'Program studi Ilmu Komputer.',
  courses: const ['Algoritma', 'Struktur Data'],
);

Education _sma() => Education(
  id: 'sma',
  institution: 'SMA Negeri 8 Jakarta',
  degree: 'SMA - IPA',
  level: DegreeLevel.highSchool,
  major: 'IPA',
  startDate: DateTime(2020, 7, 1),
  endDate: DateTime(2023, 6, 1),
  period: 'Jul 2020 – Jun 2023',
);

/// Membuka daftar dengan server palsu. Server membalas isi store saat ini
/// (hanya field yang disimpan Django), kecuali [handler] diberikan.
Future<void> _pumpList(
  WidgetTester tester, {
  MockClientHandler? handler,
}) async {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final served = PortfolioStore.instance.educations.value;
  final client = ApiClient(
    baseUrl: 'http://test',
    client: MockClient(
      handler ??
          (request) async => http.Response(
            jsonEncode([
              for (final e in served) {...e.toJson(), 'id': e.id},
            ]),
            200,
          ),
    ),
  );
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider.value(value: client),
        ChangeNotifierProvider(create: (_) => AuthState(client)),
      ],
      child: const MaterialApp(home: EducationListScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => PortfolioStore.instance.clear());

  testWidgets('Daftar kosong menampilkan pesan dan tombol Tambah', (
    tester,
  ) async {
    await _pumpList(tester);

    expect(find.text('Pendidikan'), findsOneWidget);
    expect(find.text('Cari pendidikan...'), findsOneWidget);
    expect(find.text('Belum ada riwayat pendidikan.'), findsOneWidget);
    expect(find.text('Tambah'), findsOneWidget);
  });

  testWidgets('Kartu menampilkan institusi, jenjang, periode, dan status', (
    tester,
  ) async {
    PortfolioStore.instance
      ..addEducation(_ui())
      ..addEducation(_sma());
    await _pumpList(tester);

    expect(find.text('Universitas Indonesia'), findsOneWidget);
    expect(find.text('S1 – Ilmu Komputer'), findsOneWidget);
    expect(find.text('Sep 2023 – Jun 2027'), findsOneWidget);
    expect(find.text('Aktif'), findsOneWidget);
    expect(find.text('SMA Negeri 8 Jakarta'), findsOneWidget);
    expect(find.text('SMA – IPA'), findsOneWidget);
    expect(find.text('Lulus'), findsOneWidget);
  });

  testWidgets('Pencarian menyaring daftar', (tester) async {
    PortfolioStore.instance
      ..addEducation(_ui())
      ..addEducation(_sma());
    await _pumpList(tester);

    await tester.enterText(find.byKey(const Key('searchField')), 'sma');
    await tester.pump();

    expect(find.text('SMA Negeri 8 Jakarta'), findsOneWidget);
    expect(find.text('Universitas Indonesia'), findsNothing);

    await tester.enterText(find.byKey(const Key('searchField')), 'zzz');
    await tester.pump();
    expect(find.text('Pendidikan tidak ditemukan.'), findsOneWidget);
  });

  testWidgets('Filter status Aktif hanya menampilkan pendidikan aktif', (
    tester,
  ) async {
    PortfolioStore.instance
      ..addEducation(_ui())
      ..addEducation(_sma());
    await _pumpList(tester);

    await tester.tap(find.byKey(const Key('filterButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aktif').last);
    await tester.pumpAndSettle();

    expect(find.text('Universitas Indonesia'), findsOneWidget);
    expect(find.text('SMA Negeri 8 Jakarta'), findsNothing);
    expect(find.text('Filter: Aktif'), findsOneWidget);
  });

  testWidgets('Menekan kartu membuka halaman detail', (tester) async {
    PortfolioStore.instance.addEducation(_ui());
    await _pumpList(tester);

    await tester.tap(find.text('Universitas Indonesia'));
    await tester.pumpAndSettle();

    expect(find.byType(EducationDetailScreen), findsOneWidget);
    expect(find.text('Detail Pendidikan'), findsOneWidget);
  });

  testWidgets('Tombol Tambah membuka form Tambah Pendidikan', (tester) async {
    await _pumpList(tester);

    await tester.tap(find.byKey(const Key('addEducationButton')));
    await tester.pumpAndSettle();

    expect(find.byType(EducationFormPage), findsOneWidget);
    expect(find.text('Tambah Pendidikan'), findsOneWidget);
  });

  testWidgets('Memuat pendidikan dari Django saat halaman dibuka', (
    tester,
  ) async {
    await _pumpList(
      tester,
      handler: (request) async {
        expect(request.url.toString(), 'http://test/api/v1/education/');
        return http.Response(
          jsonEncode([
            {
              'id': 'x1',
              'institution': 'Universitas Gadjah Mada',
              'degree': 'S2 - Teknik Informatika',
              'period': 'Sep 2027 – Sekarang',
              'logo': '',
              'website': '',
            },
          ]),
          200,
        );
      },
    );

    expect(find.text('Universitas Gadjah Mada'), findsOneWidget);
    expect(find.text('S2 – Teknik Informatika'), findsOneWidget);
    // Periode berakhir "Sekarang" dibaca sebagai status Aktif.
    expect(find.text('Aktif'), findsOneWidget);
    expect(PortfolioStore.instance.educations.value, hasLength(1));
  });

  testWidgets('Gagal memuat menampilkan tombol coba lagi', (tester) async {
    var calls = 0;
    await _pumpList(
      tester,
      handler: (request) async {
        calls++;
        return calls == 1
            ? http.Response('error', 500)
            : http.Response(
                jsonEncode([
                  {
                    'id': 'x1',
                    'institution': 'SMA Negeri 8 Jakarta',
                    'degree': 'SMA - IPA',
                    'period': 'Jul 2020 – Jun 2023',
                  },
                ]),
                200,
              );
      },
    );

    expect(find.text('Gagal memuat pendidikan.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('retryButton')));
    await tester.pumpAndSettle();

    expect(find.text('SMA Negeri 8 Jakarta'), findsOneWidget);
    expect(calls, 2);
  });
}
