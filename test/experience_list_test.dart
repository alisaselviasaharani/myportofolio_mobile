import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/screens/experience_detail_screen.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

const _backend = {
  'id': '1',
  'title': 'Backend Intern',
  'institution': 'PT Contoh',
  'description': 'Membuat REST API.',
  'category': 'Internship',
  'period': 'Jan 2025 - Des 2025',
  'website': 'https://contoh.com',
};

const _volunteer = {
  'id': '2',
  'title': 'Panitia Acara',
  'institution': 'BEM Fasilkom',
  'description': 'Mengurus acara kampus.',
  'category': 'Volunteer',
  'period': null,
  'website': null,
};

Future<void> _pump(WidgetTester tester, MockClientHandler handler) async {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final apiClient = ApiClient(
    client: MockClient(handler),
    baseUrl: 'http://test',
  );
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider.value(value: apiClient),
        ChangeNotifierProvider(create: (_) => AuthState(apiClient)),
      ],
      child: const MaterialApp(home: ExperienceListScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

http.Response _ok(List<Map<String, Object?>> items) =>
    http.Response(jsonEncode(items), 200);

void main() {
  setUp(() => PortfolioStore.instance.clear());

  testWidgets('Menampilkan kartu experience dari API', (tester) async {
    await _pump(tester, (request) async => _ok([_backend, _volunteer]));

    expect(find.text('Pengalaman'), findsOneWidget);
    expect(find.text('Backend Intern'), findsOneWidget);
    expect(find.text('PT Contoh'), findsOneWidget);
    expect(find.text('Jan 2025 - Des 2025'), findsOneWidget);
    expect(find.text('Internship'), findsOneWidget);
    expect(find.text('Panitia Acara'), findsOneWidget);
    expect(find.text('Tambah'), findsOneWidget);
    // Jumlah di beranda ikut disamakan dengan data Django.
    expect(PortfolioStore.instance.experienceCount.value, 2);
  });

  testWidgets('Daftar kosong menampilkan pesan', (tester) async {
    await _pump(tester, (request) async => _ok([]));

    expect(find.text('Belum ada pengalaman.'), findsOneWidget);
  });

  testWidgets('Gagal memuat menampilkan tombol coba lagi', (tester) async {
    var calls = 0;
    await _pump(tester, (request) async {
      calls++;
      return calls == 1 ? http.Response('error', 500) : _ok([_backend]);
    });

    expect(find.text('Gagal memuat pengalaman.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('retryButton')));
    await tester.pumpAndSettle();

    expect(find.text('Backend Intern'), findsOneWidget);
    expect(calls, 2);
  });

  testWidgets('Pencarian menyaring experience', (tester) async {
    await _pump(tester, (request) async => _ok([_backend, _volunteer]));

    await tester.enterText(find.byKey(const Key('searchField')), 'panitia');
    await tester.pump();

    expect(find.text('Panitia Acara'), findsOneWidget);
    expect(find.text('Backend Intern'), findsNothing);

    await tester.enterText(find.byKey(const Key('searchField')), 'zzz');
    await tester.pump();
    expect(find.text('Pengalaman tidak ditemukan.'), findsOneWidget);
  });

  testWidgets('Filter tipe menyaring experience', (tester) async {
    await _pump(tester, (request) async => _ok([_backend, _volunteer]));

    await tester.tap(find.byKey(const Key('filterButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Volunteer').last);
    await tester.pumpAndSettle();

    expect(find.text('Filter: Volunteer'), findsOneWidget);
    expect(find.text('Panitia Acara'), findsOneWidget);
    expect(find.text('Backend Intern'), findsNothing);
  });

  testWidgets('Menekan kartu membuka detail pengalaman', (tester) async {
    await _pump(tester, (request) async => _ok([_backend]));

    await tester.tap(find.text('Backend Intern'));
    await tester.pumpAndSettle();

    expect(find.byType(ExperienceDetailScreen), findsOneWidget);
    expect(find.text('Detail Pengalaman'), findsOneWidget);
    expect(find.text('Membuat REST API.'), findsOneWidget);
    expect(find.text('https://contoh.com'), findsOneWidget);
  });
}
