import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/achievement.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/achievement_detail_screen.dart';
import 'package:myportofolio_mobile/screens/education_detail_screen.dart';
import 'package:myportofolio_mobile/screens/experience_detail_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/ocean_button.dart';
import 'package:provider/provider.dart';

const _experience = Experience(
  id: 'e1',
  position: 'Backend Intern',
  company: 'PT Contoh',
  description: 'Membuat REST API.',
  type: 'Internship',
  period: 'Jan 2025 - Des 2025',
);

const _achievement = Achievement(
  id: 'a1',
  title: 'Juara 1 Hackathon',
  period: '5 Nov 2026',
  description: 'Menang lomba nasional.',
  category: AchievementCategory.competition,
);

final _education = Education(
  id: 'ed1',
  institution: 'Universitas Indonesia',
  degree: 'S1 - Ilmu Komputer',
  period: 'Sep 2023 – Jun 2027',
);

final _saveButton = find.widgetWithText(OceanButton, 'Simpan');
final List<http.Request> _requests = [];

/// Membuka halaman detail lewat tombol (agar ada route di bawahnya untuk pop)
/// dengan server palsu: PATCH membalas isi yang dikirim, DELETE membalas
/// [deleteStatus].
Future<void> _open(
  WidgetTester tester,
  Widget detail, {
  int deleteStatus = 204,
}) async {
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final client = ApiClient(
    baseUrl: 'http://test',
    client: MockClient((request) async {
      _requests.add(request);
      expect(request.headers['Authorization'], 'Token tok');
      if (request.method == 'DELETE') {
        return http.Response('', deleteStatus);
      }
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      final id = request.url.pathSegments.where((s) => s.isNotEmpty).last;
      return http.Response(jsonEncode({...body, 'id': id}), 200);
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
      child: MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => detail),
                ),
                child: const Text('buka'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('buka'));
  await tester.pumpAndSettle();
}

Future<void> _confirmDelete(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('deleteButton')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('confirmDeleteButton')));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    PortfolioStore.instance.clear();
    _requests.clear();
  });

  group('Experience', () {
    testWidgets('Edit mengisi form, PATCH ke Django, lalu detail diperbarui', (
      tester,
    ) async {
      await _open(tester, const ExperienceDetailScreen(experience: _experience));

      await tester.tap(find.byKey(const Key('editButton')));
      await tester.pumpAndSettle();

      expect(find.text('Edit Experience'), findsWidgets);
      expect(find.text('Backend Intern'), findsOneWidget); // terisi di form

      await tester.enterText(
        find.byKey(const Key('positionField')),
        'Senior Backend Intern',
      );
      await tester.tap(_saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Experience Updated!'), findsOneWidget);
      expect(_requests.single.method, 'PATCH');
      expect(
        _requests.single.url.toString(),
        'http://test/api/v1/experience/e1/',
      );

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(ExperienceDetailScreen), findsOneWidget);
      expect(find.text('Senior Backend Intern'), findsWidgets);
    });

    testWidgets('Hapus: konfirmasi, DELETE ke Django, lalu detail menutup', (
      tester,
    ) async {
      PortfolioStore.instance.experienceCount.value = 3;
      await _open(tester, const ExperienceDetailScreen(experience: _experience));

      await _confirmDelete(tester);

      expect(_requests.single.method, 'DELETE');
      expect(
        _requests.single.url.toString(),
        'http://test/api/v1/experience/e1/',
      );
      expect(find.byType(ExperienceDetailScreen), findsNothing);
      expect(find.text('Pengalaman dihapus.'), findsOneWidget);
      expect(PortfolioStore.instance.experienceCount.value, 2);
    });

    testWidgets('Batal pada konfirmasi tidak menghapus', (tester) async {
      await _open(tester, const ExperienceDetailScreen(experience: _experience));

      await tester.tap(find.byKey(const Key('deleteButton')));
      await tester.pumpAndSettle();
      expect(find.text('Hapus pengalaman?'), findsOneWidget);
      await tester.tap(find.byKey(const Key('cancelDeleteButton')));
      await tester.pumpAndSettle();

      expect(_requests, isEmpty);
      expect(find.byType(ExperienceDetailScreen), findsOneWidget);
    });

    testWidgets('Gagal menghapus menampilkan pesan dan tetap di detail', (
      tester,
    ) async {
      await _open(
        tester,
        const ExperienceDetailScreen(experience: _experience),
        deleteStatus: 500,
      );

      await _confirmDelete(tester);

      expect(find.text('Gagal menghapus (status 500).'), findsOneWidget);
      expect(find.byType(ExperienceDetailScreen), findsOneWidget);
    });
  });

  group('Achievement', () {
    testWidgets('Edit membaca tanggal dari periode dan PATCH ke Django', (
      tester,
    ) async {
      await _open(
        tester,
        const AchievementDetailScreen(achievement: _achievement),
      );

      await tester.tap(find.byKey(const Key('editButton')));
      await tester.pumpAndSettle();

      // Tanggal mulai terisi dari teks periode "5 Nov 2026".
      expect(find.text('5 Nov 2026'), findsWidgets);

      await tester.enterText(
        find.byKey(const Key('titleField')),
        'Juara 2 Hackathon',
      );
      await tester.tap(_saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Certification Updated!'), findsOneWidget);
      expect(_requests.single.method, 'PATCH');
      expect(
        _requests.single.url.toString(),
        'http://test/api/v1/achievements/a1/',
      );
      final sent = jsonDecode(_requests.single.body) as Map<String, dynamic>;
      expect(sent['title'], 'Juara 2 Hackathon');
      expect(sent['period'], '5 Nov 2026');

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(AchievementDetailScreen), findsOneWidget);
      expect(find.text('Juara 2 Hackathon'), findsWidgets);
    });

    testWidgets('Periode yang tak bisa dibaca dipertahankan saat edit', (
      tester,
    ) async {
      await _open(
        tester,
        const AchievementDetailScreen(
          achievement: Achievement(
            id: 'a2',
            title: 'Sertifikat',
            period: 'Tahun lalu',
            description: 'Deskripsi',
            category: AchievementCategory.certification,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('editButton')));
      await tester.pumpAndSettle();
      await tester.tap(_saveButton);
      await tester.pumpAndSettle();

      final sent = jsonDecode(_requests.single.body) as Map<String, dynamic>;
      expect(sent['period'], 'Tahun lalu');
    });

    testWidgets('Hapus mengirim DELETE dan menutup detail', (tester) async {
      PortfolioStore.instance.achievements.value = [_achievement];
      await _open(
        tester,
        const AchievementDetailScreen(achievement: _achievement),
      );

      await _confirmDelete(tester);

      expect(_requests.single.method, 'DELETE');
      expect(
        _requests.single.url.toString(),
        'http://test/api/v1/achievements/a1/',
      );
      expect(find.byType(AchievementDetailScreen), findsNothing);
      expect(PortfolioStore.instance.achievements.value, isEmpty);
    });
  });

  group('Education', () {
    testWidgets('Hapus mengirim DELETE, mengosongkan store, menutup detail', (
      tester,
    ) async {
      PortfolioStore.instance
        ..addEducation(_education)
        ..toggleFavorite(_education);
      await _open(tester, EducationDetailScreen(education: _education));

      await _confirmDelete(tester);

      expect(_requests.single.method, 'DELETE');
      expect(
        _requests.single.url.toString(),
        'http://test/api/v1/education/ed1/',
      );
      expect(find.byType(EducationDetailScreen), findsNothing);
      expect(PortfolioStore.instance.educations.value, isEmpty);
      expect(PortfolioStore.instance.favorites.value, isEmpty);
    });
  });
}
