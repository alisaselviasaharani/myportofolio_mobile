import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/reset_password_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/services/google_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Membuka [page] lewat `Navigator.push` dari halaman dummy (seperti di
/// aplikasi sungguhan), lalu mengembalikan [AuthState]-nya.
Future<AuthState> _open(
  WidgetTester tester,
  Widget page, {
  MockClient? server,
}) async {
  SharedPreferences.setMockInitialValues({});
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final api = ApiClient(
    baseUrl: 'http://test',
    client: server ?? MockClient((_) async => http.Response('{}', 200)),
  );
  final auth = AuthState(api);
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider.value(value: api),
        ChangeNotifierProvider.value(value: auth),
      ],
      child: MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push<Object?>(
                  context,
                  MaterialPageRoute(builder: (_) => page),
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
  return auth;
}

Future<void> _tapGoogle(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Masuk dengan Google'));
  await tester.pumpAndSettle();
}

void main() {
  group('Masuk dengan Google', () {
    testWidgets('berhasil: ID token ditukar jadi token dan halaman ditutup', (
      tester,
    ) async {
      final auth = await _open(
        tester,
        LoginScreen(googleIdTokenProvider: () async => 'idtok'),
        server: MockClient((request) async {
          expect(request.url.path, '/api/v1/auth/google/');
          expect(jsonDecode(request.body), {'id_token': 'idtok'});
          return http.Response('{"token":"gtok"}', 200);
        }),
      );

      await _tapGoogle(tester);

      expect(auth.isLoggedIn, isTrue);
      expect(auth.token, 'gtok');
      expect(find.byType(LoginScreen), findsNothing);
    });

    testWidgets('dibatalkan pengguna: tetap di halaman login tanpa error', (
      tester,
    ) async {
      final auth = await _open(
        tester,
        LoginScreen(googleIdTokenProvider: () async => null),
      );

      await _tapGoogle(tester);

      expect(auth.isLoggedIn, isFalse);
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('belum dikonfigurasi: pesan jelas ditampilkan', (tester) async {
      final auth = await _open(
        tester,
        LoginScreen(
          googleIdTokenProvider: () async =>
              throw const GoogleAuthUnavailable('Belum dikonfigurasi.'),
        ),
      );

      await _tapGoogle(tester);

      expect(find.text('Belum dikonfigurasi.'), findsOneWidget);
      expect(auth.isLoggedIn, isFalse);
    });

    testWidgets('server menolak token (400): pesan ditampilkan', (tester) async {
      final auth = await _open(
        tester,
        LoginScreen(googleIdTokenProvider: () async => 'idtok'),
        server: MockClient((_) async => http.Response('{}', 400)),
      );

      await _tapGoogle(tester);

      expect(find.text('Akun Google tidak dapat diverifikasi.'), findsOneWidget);
      expect(auth.isLoggedIn, isFalse);
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });

  group('Atur Ulang Kata Sandi dengan kode dari email', () {
    Future<void> type(WidgetTester tester, String key, String text) =>
        tester.enterText(find.byKey(Key(key)), text);

    testWidgets('kode uid.token dipecah dan dikirim ke backend', (tester) async {
      await _open(
        tester,
        const ResetPasswordScreen(),
        server: MockClient((request) async {
          expect(request.url.path, '/api/v1/auth/password-reset/confirm/');
          expect(jsonDecode(request.body), {
            'uid': 'Mg',
            'token': 'c5x2k9-3f1a7b',
            'new_password': 'sandibaru123',
          });
          return http.Response('{}', 200);
        }),
      );

      await type(tester, 'resetCodeField', 'Mg.c5x2k9-3f1a7b');
      await type(tester, 'resetPasswordField', 'sandibaru123');
      await type(tester, 'resetConfirmField', 'sandibaru123');
      await tester.tap(find.text('Simpan Kata Sandi'));
      await tester.pumpAndSettle();

      expect(find.byType(ResetPasswordScreen), findsNothing);
      expect(find.text('Kata sandi diperbarui. Silakan masuk.'), findsOneWidget);
    });

    testWidgets('kode tanpa titik ditolak sebelum dikirim', (tester) async {
      await _open(tester, const ResetPasswordScreen());

      await type(tester, 'resetCodeField', 'kodesalah');
      await type(tester, 'resetPasswordField', 'sandibaru123');
      await type(tester, 'resetConfirmField', 'sandibaru123');
      await tester.tap(find.text('Simpan Kata Sandi'));
      await tester.pumpAndSettle();

      expect(find.text('Kode dari email tidak valid!'), findsOneWidget);
      expect(find.byType(ResetPasswordScreen), findsOneWidget);
    });

    testWidgets('kolom kode disembunyikan jika uid dan token sudah ada', (
      tester,
    ) async {
      await _open(tester, const ResetPasswordScreen(uid: 'u1', token: 't1'));

      expect(find.byKey(const Key('resetCodeField')), findsNothing);
    });
  });
}
