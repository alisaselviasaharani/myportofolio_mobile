import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/achievement_form.dart';
import 'package:myportofolio_mobile/screens/contact_page.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/favorite_screen.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/profile_screen.dart';
import 'package:myportofolio_mobile/screens/skills_page.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/app_settings.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';
import 'package:provider/provider.dart';

/// Kartu aksi di beranda beserta halaman tujuannya.
const List<(String, Type)> _cards = [
  ('Add Education', EducationFormPage),
  ('My Education', EducationListScreen),
  ('Add Experience', ExperienceFormPage),
  ('Add Certification', AchievementFormPage),
  ('My Skills', SkillsPage),
  ('Contact Me', ContactPage),
];

/// Kartu yang langsung membuka halaman (Add Experience dilindungi login,
/// jadi dites terpisah).
final List<(String, Type)> _openCards = _cards
    .where((card) => card.$2 != ExperienceFormPage)
    .toList();

/// Layar tinggi agar semua kartu dan tile drawer terlihat tanpa menggulir.
void _useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// Membuka drawer lewat tombol hamburger pada AppBar.
Future<void> _openDrawer(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Open navigation menu'));
  await tester.pumpAndSettle();
}

/// Teks di dalam drawer (judul yang sama juga ada di kartu beranda).
Finder _inDrawer(String text) =>
    find.descendant(of: find.byType(Drawer), matching: find.text(text));

/// Membungkus [child] dengan provider yang dibutuhkan MyHomePage dan drawer.
Widget _withProviders(Widget child) {
  final apiClient = ApiClient();
  return MultiProvider(
    providers: [
      Provider.value(value: apiClient),
      ChangeNotifierProvider(create: (_) => AuthState(apiClient)),
      ChangeNotifierProvider(create: (_) => AppSettings()),
    ],
    child: child,
  );
}

void main() {
  setUp(() => PortfolioStore.instance.clear());

  testWidgets('Halaman utama menampilkan kartu aksi dan bagian portofolio', (
    WidgetTester tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));

    // Judul AppBar dan label bagian "My Portfolio".
    expect(find.text('My Portfolio'), findsNWidgets(2));

    for (final (name, _) in _cards) {
      expect(find.text(name), findsOneWidget);
    }
    for (final title in ['Education', 'Experience', 'Certifications']) {
      expect(find.text(title), findsOneWidget);
    }
  });

  for (final (name, _) in _cards) {
    testWidgets('Kartu $name menampilkan SnackBar', (
      WidgetTester tester,
    ) async {
      _useTallScreen(tester);
      await tester.pumpWidget(MyApp(apiClient: ApiClient()));

      await tester.tap(find.text(name));
      await tester.pump();

      expect(find.text('Kamu telah menekan tombol $name!'), findsOneWidget);
    });
  }

  for (final (name, page) in _openCards) {
    testWidgets('Kartu $name membuka form dan bisa kembali', (
      WidgetTester tester,
    ) async {
      _useTallScreen(tester);
      await tester.pumpWidget(MyApp(apiClient: ApiClient()));

      await tester.tap(find.text(name));
      await tester.pumpAndSettle();
      expect(find.byType(page), findsOneWidget);

      // Setara tombol kembali bawaan perangkat (Navigator.pop).
      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();
      expect(find.byType(page), findsNothing);
      expect(find.byType(MyHomePage), findsOneWidget);
    });
  }

  for (final (name, page) in _openCards) {
    testWidgets('Drawer membuka $name dan Home kembali ke utama', (
      WidgetTester tester,
    ) async {
      _useTallScreen(tester);
      await tester.pumpWidget(MyApp(apiClient: ApiClient()));

      await _openDrawer(tester);
      await tester.tap(_inDrawer(name));
      await tester.pumpAndSettle();
      expect(find.byType(page), findsOneWidget);

      // Drawer yang sama tersedia di halaman form.
      await _openDrawer(tester);
      await tester.tap(_inDrawer('Home'));
      await tester.pumpAndSettle();
      expect(find.byType(MyHomePage), findsOneWidget);
      expect(find.byType(page), findsNothing);
    });
  }

  testWidgets('Kartu Add Experience mengarah ke Login jika belum login', (
    WidgetTester tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));

    await tester.tap(find.text('Add Experience'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(ExperienceFormPage), findsNothing);
  });

  testWidgets('Drawer Add Experience mengarah ke Login jika belum login', (
    WidgetTester tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));

    await _openDrawer(tester);
    await tester.tap(_inDrawer('Add Experience'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Bagian My Portfolio menampilkan jumlah item dari store', (
    WidgetTester tester,
  ) async {
    _useTallScreen(tester);
    PortfolioStore.instance.addEducation(
      Education(
        institution: 'Universitas Indonesia',
        degree: 'S1 - Ilmu Komputer',
        startDate: DateTime(2023, 9, 1),
        endDate: DateTime(2027, 6, 1),
        period: '1 Sep 2023 - 1 Jun 2027',
      ),
    );
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));

    expect(find.text('Education'), findsOneWidget);
    expect(find.text('1 item'), findsOneWidget);
    expect(find.text('0 items'), findsNWidgets(2));
  });

  testWidgets('Tile Education di My Portfolio membuka daftar pendidikan', (
    WidgetTester tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));

    await tester.ensureVisible(find.text('Education'));
    await tester.tap(find.text('Education'));
    await tester.pumpAndSettle();

    expect(find.byType(EducationListScreen), findsOneWidget);
  });

  group('Halaman Skills dan Contact', () {
    testWidgets('Skills menampilkan tiga bagian kemampuan', (tester) async {
      _useTallScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: SkillsPage()));

      for (final text in [
        'My Skills',
        'Technical Skills',
        'Soft Skills',
        'Tools & Others',
        'Python',
        'Java',
        'Git',
        'Teamwork',
        'GitHub',
      ]) {
        expect(find.text(text), findsOneWidget);
      }
    });

    testWidgets('Contact menolak form kosong dan email tidak valid', (
      tester,
    ) async {
      _useTallScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: ContactPage()));

      await tester.ensureVisible(find.text('Kirim Pesan'));
      await tester.tap(find.text('Kirim Pesan'));
      await tester.pump();
      expect(find.text('Nama lengkap tidak boleh kosong!'), findsOneWidget);
      expect(find.text('Email tidak boleh kosong!'), findsOneWidget);
      expect(find.text('Pesan tidak boleh kosong!'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('contactEmailField')),
        'bukan-email',
      );
      await tester.pump();
      expect(find.text('Format email tidak valid!'), findsOneWidget);
    });

    testWidgets('Contact mengirim pesan ke backend lalu menampilkan dialog', (
      tester,
    ) async {
      _useTallScreen(tester);
      final requests = <http.Request>[];
      final api = ApiClient(
        baseUrl: 'http://test',
        client: MockClient((request) async {
          requests.add(request);
          return http.Response('{"detail":"Pesan terkirim."}', 201);
        }),
      );
      await tester.pumpWidget(
        Provider.value(
          value: api,
          child: const MaterialApp(home: ContactPage()),
        ),
      );

      await tester.enterText(
        find.byKey(const Key('contactNameField')),
        'Alisa',
      );
      await tester.enterText(
        find.byKey(const Key('contactEmailField')),
        'alisa@ui.ac.id',
      );
      await tester.enterText(
        find.byKey(const Key('contactMessageField')),
        'Halo!',
      );
      await tester.ensureVisible(find.text('Kirim Pesan'));
      await tester.tap(find.text('Kirim Pesan'));
      await tester.pumpAndSettle();

      expect(requests, hasLength(1));
      expect(requests.single.url.path, '/api/v1/contact/');
      expect(jsonDecode(requests.single.body), {
        'name': 'Alisa',
        'email': 'alisa@ui.ac.id',
        'message': 'Halo!',
      });
      expect(find.text('Message Sent!'), findsOneWidget);
    });

    testWidgets('Contact gagal kirim: tidak ada dialog sukses, isian tetap', (
      tester,
    ) async {
      _useTallScreen(tester);
      final api = ApiClient(
        baseUrl: 'http://test',
        client: MockClient((request) async => http.Response('{}', 503)),
      );
      await tester.pumpWidget(
        Provider.value(
          value: api,
          child: const MaterialApp(home: ContactPage()),
        ),
      );

      await tester.enterText(
        find.byKey(const Key('contactNameField')),
        'Alisa',
      );
      await tester.enterText(
        find.byKey(const Key('contactEmailField')),
        'alisa@ui.ac.id',
      );
      await tester.enterText(
        find.byKey(const Key('contactMessageField')),
        'Halo!',
      );
      await tester.ensureVisible(find.text('Kirim Pesan'));
      await tester.tap(find.text('Kirim Pesan'));
      await tester.pumpAndSettle();

      expect(find.text('Message Sent!'), findsNothing);
      expect(find.textContaining('belum bisa mengirim email'), findsOneWidget);
      expect(find.text('Halo!'), findsOneWidget);
    });
  });

  group('OceanBottomBar', () {
    Future<void> pumpBar(WidgetTester tester) async {
      _useTallScreen(tester);
      await tester.pumpWidget(
        _withProviders(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox.expand(),
              bottomNavigationBar: OceanBottomBar(),
            ),
          ),
        ),
      );
    }

    testWidgets('Tombol tambah membuka lembar pilihan form', (
      WidgetTester tester,
    ) async {
      await pumpBar(tester);

      await tester.tap(find.byTooltip('Tambah'));
      await tester.pumpAndSettle();
      expect(find.text('Tambah data'), findsOneWidget);

      await tester.tap(find.text('Add Education'));
      await tester.pumpAndSettle();
      expect(find.byType(EducationFormPage), findsOneWidget);
    });

    testWidgets('Tombol Portofolio membuka daftar pendidikan', (
      WidgetTester tester,
    ) async {
      await pumpBar(tester);

      await tester.tap(find.byTooltip('Portofolio'));
      await tester.pumpAndSettle();
      expect(find.byType(EducationListScreen), findsOneWidget);
    });

    testWidgets('Tombol Favorit membuka halaman favorit', (
      WidgetTester tester,
    ) async {
      await pumpBar(tester);

      await tester.tap(find.byTooltip('Favorit'));
      await tester.pumpAndSettle();
      expect(find.byType(FavoriteScreen), findsOneWidget);
    });

    testWidgets('Tombol Profil membuka halaman profil', (
      WidgetTester tester,
    ) async {
      await pumpBar(tester);

      await tester.tap(find.byTooltip('Profil'));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('Tombol Beranda membuka halaman utama', (
      WidgetTester tester,
    ) async {
      await pumpBar(tester);

      await tester.tap(find.byTooltip('Beranda'));
      await tester.pumpAndSettle();
      expect(find.byType(MyHomePage), findsOneWidget);
    });
  });
}
