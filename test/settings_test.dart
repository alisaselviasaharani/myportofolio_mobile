import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/language_screen.dart';
import 'package:myportofolio_mobile/screens/settings_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/app_settings.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

Widget _app({AppSettings? settings}) {
  final apiClient = ApiClient();
  return MultiProvider(
    providers: [
      Provider.value(value: apiClient),
      ChangeNotifierProvider(create: (_) => AuthState(apiClient)),
      ChangeNotifierProvider(create: (_) => settings ?? AppSettings()),
    ],
    child: const MaterialApp(home: SettingsScreen()),
  );
}

void _tallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  group('AppSettings', () {
    test('bahasa awal Indonesia dan memberi tahu listener saat berubah', () {
      final settings = AppSettings();
      var notified = 0;
      settings.addListener(() => notified++);

      expect(settings.language, AppLanguage.id);
      settings.setLanguage(AppLanguage.en);
      expect(settings.language, AppLanguage.en);
      expect(notified, 1);

      // Memilih bahasa yang sama tidak memicu notifikasi.
      settings.setLanguage(AppLanguage.en);
      expect(notified, 1);
    });
  });

  group('SettingsScreen', () {
    testWidgets('menampilkan semua menu Pengaturan', (tester) async {
      _tallScreen(tester);
      await tester.pumpWidget(_app());

      expect(find.text('Pengaturan'), findsOneWidget);
      expect(find.text('Akun & Profil'), findsOneWidget);
      expect(find.text('Bahasa'), findsOneWidget);
      expect(find.text('Notifikasi'), findsOneWidget);
      expect(find.text('Tampilan Aplikasi'), findsOneWidget);
      expect(find.text('Terang'), findsOneWidget);
      expect(find.text('Tentang Aplikasi'), findsOneWidget);
      expect(find.text('Versi 2.0.0'), findsOneWidget);
      expect(find.text('Keluar'), findsOneWidget);
    });

    testWidgets('Keluar saat belum login menampilkan info', (tester) async {
      _tallScreen(tester);
      await tester.pumpWidget(_app());

      await tester.tap(find.text('Keluar'));
      await tester.pump();
      expect(find.text('Kamu belum login.'), findsOneWidget);
    });
  });

  group('LanguageScreen', () {
    testWidgets('memilih English mengganti bahasa Pengaturan', (tester) async {
      _tallScreen(tester);
      await tester.pumpWidget(_app());

      await tester.tap(find.text('Bahasa'));
      await tester.pumpAndSettle();
      expect(find.byType(LanguageScreen), findsOneWidget);
      expect(find.text('Bahasa Indonesia (ID)'), findsOneWidget);
      expect(find.text('English (EN)'), findsOneWidget);

      await tester.tap(find.byKey(const Key('languageOption_en')));
      await tester.pumpAndSettle();

      // Judul halaman Bahasa kini berbahasa Inggris.
      expect(find.text('Language'), findsOneWidget);

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Account & Profile'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);
    });
  });
}
