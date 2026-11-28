import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/screens/achievement_detail_screen.dart';
import 'package:myportofolio_mobile/screens/achievement_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

const _juara = {
  'id': '1',
  'title': 'Juara 1 Hackathon',
  'period': '5 Nov 2026',
  'description': 'Menang lomba hackathon nasional.',
  'category': 'Competition',
  'achievements_image_url': '',
};

const _sertifikat = {
  'id': '2',
  'title': 'Sertifikat Flutter',
  'period': '',
  'description': 'Kursus Flutter dasar.',
  'category': 'Certification',
  'achievements_image_url': null,
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
      child: const MaterialApp(home: AchievementListScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

http.Response _ok(List<Map<String, Object?>> items) =>
    http.Response(jsonEncode(items), 200);

void main() {
  setUp(() => PortfolioStore.instance.clear());

  testWidgets('Menampilkan kartu achievement dari API', (tester) async {
    await _pump(tester, (request) async {
      expect(request.url.toString(), 'http://test/api/v1/achievements/');
      return _ok([_juara, _sertifikat]);
    });

    expect(find.text('Sertifikasi'), findsOneWidget);
    expect(find.text('Juara 1 Hackathon'), findsOneWidget);
    expect(find.text('5 Nov 2026'), findsOneWidget);
    expect(find.text('Competition'), findsOneWidget);
    expect(find.text('Sertifikat Flutter'), findsOneWidget);
    expect(find.text('Tambah'), findsOneWidget);
    // Jumlah di beranda ikut disamakan dengan data Django.
    expect(PortfolioStore.instance.achievements.value, hasLength(2));
  });

  testWidgets('Daftar kosong menampilkan pesan', (tester) async {
    await _pump(tester, (request) async => _ok([]));

    expect(find.text('Belum ada sertifikasi.'), findsOneWidget);
  });

  testWidgets('Gagal memuat menampilkan tombol coba lagi', (tester) async {
    var calls = 0;
    await _pump(tester, (request) async {
      calls++;
      return calls == 1 ? http.Response('error', 500) : _ok([_juara]);
    });

    expect(find.text('Gagal memuat sertifikasi.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('retryButton')));
    await tester.pumpAndSettle();

    expect(find.text('Juara 1 Hackathon'), findsOneWidget);
    expect(calls, 2);
  });

  testWidgets('Pencarian dan filter kategori menyaring achievement', (
    tester,
  ) async {
    await _pump(tester, (request) async => _ok([_juara, _sertifikat]));

    await tester.enterText(find.byKey(const Key('searchField')), 'flutter');
    await tester.pump();
    expect(find.text('Sertifikat Flutter'), findsOneWidget);
    expect(find.text('Juara 1 Hackathon'), findsNothing);

    await tester.enterText(find.byKey(const Key('searchField')), '');
    await tester.pump();

    await tester.tap(find.byKey(const Key('filterButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Competition').last);
    await tester.pumpAndSettle();

    expect(find.text('Filter: Competition'), findsOneWidget);
    expect(find.text('Juara 1 Hackathon'), findsOneWidget);
    expect(find.text('Sertifikat Flutter'), findsNothing);
  });

  testWidgets('Menekan kartu membuka detail sertifikasi', (tester) async {
    await _pump(tester, (request) async => _ok([_juara]));

    await tester.tap(find.text('Juara 1 Hackathon'));
    await tester.pumpAndSettle();

    expect(find.byType(AchievementDetailScreen), findsOneWidget);
    expect(find.text('Detail Sertifikasi'), findsOneWidget);
    expect(find.text('Menang lomba hackathon nasional.'), findsOneWidget);
  });
}
