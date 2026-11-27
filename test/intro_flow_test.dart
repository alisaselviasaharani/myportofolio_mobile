import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/onboarding_screen.dart';
import 'package:myportofolio_mobile/screens/splash_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Membuka aplikasi dari splash dengan penyimpanan palsu [prefs].
Future<void> _launch(
  WidgetTester tester, {
  Map<String, Object> prefs = const {},
  MockClient? server,
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final api = ApiClient(
    baseUrl: 'http://test',
    client: server ?? MockClient((_) async => http.Response('{}', 200)),
  );
  await tester.pumpWidget(MyApp(apiClient: api, showIntro: true));
}

void main() {
  testWidgets('splash menampilkan bar loading lalu pindah halaman', (
    tester,
  ) async {
    await _launch(tester);
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byKey(const Key('splashLoadingBar')), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(SplashScreen), findsNothing);
  });

  testWidgets('pertama kali: onboarding 3 halaman lalu login', (tester) async {
    await _launch(tester);
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('Kelola Perjalananmu'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboardingNext')));
    await tester.pumpAndSettle();
    expect(find.text('Tampilkan Keahlianmu'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboardingNext')));
    await tester.pumpAndSettle();
    expect(find.text('Lacak Perkembanganmu'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboardingNext')));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);

    // Onboarding tidak tampil lagi pada peluncuran berikutnya.
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('onboarding_seen'), isTrue);
  });

  testWidgets('Lewati langsung membuka login', (tester) async {
    await _launch(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('onboardingSkip')));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('onboarding sudah pernah dilihat: langsung ke login', (
    tester,
  ) async {
    await _launch(tester, prefs: {'onboarding_seen': true});
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('sesi tersimpan (Ingat saya): langsung ke beranda', (
    tester,
  ) async {
    await _launch(
      tester,
      prefs: {'onboarding_seen': true, 'auth_token': 'abc123'},
    );
    await tester.pumpAndSettle();

    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('login berhasil dari pintu masuk membuka beranda', (
    tester,
  ) async {
    await _launch(
      tester,
      prefs: {'onboarding_seen': true},
      server: MockClient(
        (_) async => http.Response('{"token":"tok-1"}', 200),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('usernameField')), 'alisa');
    await tester.enterText(find.byKey(const Key('passwordField')), 'rahasia12');
    await tester.tap(find.byKey(const Key('rememberCheckbox')));
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    expect(find.byType(MyHomePage), findsOneWidget);
    // "Ingat saya" dicentang, jadi token tersimpan.
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('auth_token'), 'tok-1');
  });

  testWidgets('Lanjut sebagai tamu membuka beranda tanpa login', (
    tester,
  ) async {
    await _launch(tester, prefs: {'onboarding_seen': true});
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('guestLink')));
    await tester.tap(find.byKey(const Key('guestLink')));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
  });
}
