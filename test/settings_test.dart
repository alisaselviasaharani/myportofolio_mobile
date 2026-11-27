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

    test('tema awal adalah Terang', () {
      final settings = AppSettings();

      expect(settings.themeMode, AppThemeMode.light);
    });

    test('mengubah tema menjadi Gelap', () {
      final settings = AppSettings();

      settings.setThemeMode(AppThemeMode.dark);

      expect(settings.themeMode, AppThemeMode.dark);
    });

    test('mengubah tema menjadi Ikuti sistem', () {
      final settings = AppSettings();

      settings.setThemeMode(AppThemeMode.system);

      expect(settings.themeMode, AppThemeMode.system);
    });

    test('notifikasi awal aktif', () {
      final settings = AppSettings();

      expect(settings.notificationsEnabled, isTrue);
    });

    test('dapat mengaktifkan dan menonaktifkan notifikasi', () {
      final settings = AppSettings();

      settings.setNotificationsEnabled(false);

      expect(settings.notificationsEnabled, isFalse);

      settings.setNotificationsEnabled(true);

      expect(settings.notificationsEnabled, isTrue);
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

    testWidgets('memilih tema Gelap mengubah pilihan tema', (tester) async {
      _tallScreen(tester);

      final settings = AppSettings();

      await tester.pumpWidget(_app(settings: settings));

      await tester.tap(find.text('Tampilan Aplikasi'));
      await tester.pumpAndSettle();

      expect(find.text('Ikuti sistem'), findsOneWidget);
      expect(find.text('Gelap'), findsOneWidget);

      await tester.tap(find.byKey(const Key('themeOption_dark')));

      await tester.pumpAndSettle();

      expect(settings.themeMode, AppThemeMode.dark);
      expect(find.text('Gelap'), findsOneWidget);
      expect(find.text('Terang'), findsNothing);
    });

    testWidgets('memilih tema Ikuti sistem', (tester) async {
      _tallScreen(tester);

      final settings = AppSettings();

      await tester.pumpWidget(_app(settings: settings));

      await tester.tap(find.text('Tampilan Aplikasi'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('themeOption_system')));

      await tester.pumpAndSettle();

      expect(settings.themeMode, AppThemeMode.system);
      expect(find.text('Ikuti sistem'), findsOneWidget);
    });

    testWidgets('Keluar saat belum login menampilkan info', (tester) async {
      _tallScreen(tester);

      await tester.pumpWidget(_app());

      await tester.tap(find.text('Keluar'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

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

      expect(find.text('Language'), findsOneWidget);

      await tester.tap(find.byTooltip('Back'));

      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Account & Profile'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);
    });
  });
}
