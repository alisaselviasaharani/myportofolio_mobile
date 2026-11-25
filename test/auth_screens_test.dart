import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/forgot_password_screen.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/register_screen.dart';
import 'package:myportofolio_mobile/screens/reset_password_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_form_parts.dart';
import 'package:provider/provider.dart';

/// Membuka [page] lewat `Navigator.push` dari halaman dummy, seperti di
/// aplikasi sungguhan (tombol kembali muncul dan hasil `pop` bisa dibaca
/// lewat [onPop]).
Future<AuthState> _open(
  WidgetTester tester,
  Widget page, {
  MockClient? server,
  void Function(Object? result)? onPop,
}) async {
  // Layar tinggi agar semua field terlihat tanpa menggulir.
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
                onPressed: () async {
                  final result = await Navigator.push<Object?>(
                    context,
                    MaterialPageRoute(builder: (_) => page),
                  );
                  onPop?.call(result);
                },
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

Future<void> _type(WidgetTester tester, String key, String text) async {
  await tester.enterText(find.byKey(Key(key)), text);
}

Future<void> _tapButton(WidgetTester tester, String label) async {
  await tester.tap(find.widgetWithText(AuthButton, label));
  await tester.pumpAndSettle();
}

void main() {
  group('LoginScreen', () {
    testWidgets('menampilkan error saat dikirim kosong', (tester) async {
      await _open(tester, const LoginScreen());

      await _tapButton(tester, 'Masuk');

      expect(find.text('Email atau username tidak boleh kosong!'), findsOneWidget);
      expect(find.text('Kata sandi tidak boleh kosong!'), findsOneWidget);
    });

    testWidgets('berhasil: menyimpan token dan pop dengan true', (
      tester,
    ) async {
      Object? popped;
      final auth = await _open(
        tester,
        const LoginScreen(),
        onPop: (result) => popped = result,
        server: MockClient((request) async {
          expect(request.url.path, '/api/v1/auth/token/');
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body, {'username': 'alisa', 'password': 'rahasia123'});
          return http.Response(jsonEncode({'token': 'abc'}), 200);
        }),
      );

      await _type(tester, 'usernameField', '  alisa  ');
      await _type(tester, 'passwordField', 'rahasia123');
      await _tapButton(tester, 'Masuk');

      expect(auth.isLoggedIn, isTrue);
      expect(popped, isTrue);
      expect(find.byType(LoginScreen), findsNothing);
    });

    testWidgets('gagal: menampilkan pesan dan tetap di halaman login', (
      tester,
    ) async {
      final auth = await _open(
        tester,
        const LoginScreen(),
        server: MockClient((_) async => http.Response('{}', 400)),
      );

      await _type(tester, 'usernameField', 'alisa');
      await _type(tester, 'passwordField', 'salah-salah');
      await _tapButton(tester, 'Masuk');

      expect(find.text('Email/username atau kata sandi salah.'), findsOneWidget);
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(auth.isLoggedIn, isFalse);
    });

    testWidgets('kata sandi bisa ditampilkan lewat tombol mata', (
      tester,
    ) async {
      await _open(tester, const LoginScreen());

      EditableText field() => tester.widget<EditableText>(
        find.descendant(
          of: find.byKey(const Key('passwordField')),
          matching: find.byType(EditableText),
        ),
      );

      expect(field().obscureText, isTrue);
      await tester.tap(find.byTooltip('Tampilkan kata sandi'));
      await tester.pump();
      expect(field().obscureText, isFalse);
    });

    testWidgets('membuka halaman Daftar dan Lupa Kata Sandi', (tester) async {
      await _open(tester, const LoginScreen());

      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle();
      expect(find.byType(RegisterScreen), findsOneWidget);

      await tester.tap(find.text('Masuk')); // Tautan "Sudah punya akun? Masuk".
      await tester.pumpAndSettle();
      expect(find.byType(RegisterScreen), findsNothing);

      await tester.tap(find.text('Lupa Kata Sandi?'));
      await tester.pumpAndSettle();
      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    });
  });

  group('RegisterScreen', () {
    testWidgets('validasi: semua field kosong', (tester) async {
      await _open(tester, const RegisterScreen());

      await _tapButton(tester, 'Daftar');

      expect(find.text('Nama lengkap tidak boleh kosong!'), findsOneWidget);
      expect(find.text('Email tidak boleh kosong!'), findsOneWidget);
      expect(find.text('Username tidak boleh kosong!'), findsOneWidget);
      expect(find.text('Kata sandi tidak boleh kosong!'), findsOneWidget);
      expect(
        find.text('Konfirmasi kata sandi tidak boleh kosong!'),
        findsOneWidget,
      );
    });

    testWidgets('validasi: email salah dan konfirmasi tidak sama', (
      tester,
    ) async {
      await _open(tester, const RegisterScreen());

      await _type(tester, 'registerNameField', 'Alisa Selvia');
      await _type(tester, 'registerEmailField', 'bukan-email');
      await _type(tester, 'registerUsernameField', 'alisa');
      await _type(tester, 'registerPasswordField', 'rahasia123');
      await _type(tester, 'registerConfirmField', 'rahasia124');
      await _tapButton(tester, 'Daftar');

      expect(find.text('Format email tidak valid!'), findsOneWidget);
      expect(find.text('Konfirmasi kata sandi tidak sama!'), findsOneWidget);
    });

    testWidgets('berhasil: kirim data lalu kembali dengan pesan sukses', (
      tester,
    ) async {
      await _open(
        tester,
        const RegisterScreen(),
        server: MockClient((request) async {
          expect(request.url.path, '/api/v1/auth/register/');
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body, {
            'full_name': 'Alisa Selvia',
            'email': 'alisa@example.com',
            'username': 'alisa',
            'password': 'rahasia123',
          });
          return http.Response('{}', 201);
        }),
      );

      await _type(tester, 'registerNameField', ' Alisa Selvia ');
      await _type(tester, 'registerEmailField', 'alisa@example.com');
      await _type(tester, 'registerUsernameField', 'alisa');
      await _type(tester, 'registerPasswordField', 'rahasia123');
      await _type(tester, 'registerConfirmField', 'rahasia123');
      await _tapButton(tester, 'Daftar');

      expect(find.byType(RegisterScreen), findsNothing);
      expect(find.text('Akun berhasil dibuat. Silakan masuk.'), findsOneWidget);
    });

    testWidgets('gagal 400: menampilkan pesan dan tetap di halaman', (
      tester,
    ) async {
      await _open(
        tester,
        const RegisterScreen(),
        server: MockClient((_) async => http.Response('{}', 400)),
      );

      await _type(tester, 'registerNameField', 'Alisa Selvia');
      await _type(tester, 'registerEmailField', 'alisa@example.com');
      await _type(tester, 'registerUsernameField', 'alisa');
      await _type(tester, 'registerPasswordField', 'rahasia123');
      await _type(tester, 'registerConfirmField', 'rahasia123');
      await _tapButton(tester, 'Daftar');

      expect(find.byType(RegisterScreen), findsOneWidget);
      expect(find.textContaining('Pendaftaran ditolak'), findsOneWidget);
    });
  });

  group('ForgotPasswordScreen', () {
    testWidgets('validasi: email kosong dan email salah', (tester) async {
      await _open(tester, const ForgotPasswordScreen());

      await _tapButton(tester, 'Kirim Tautan');
      expect(find.text('Email tidak boleh kosong!'), findsOneWidget);

      await _type(tester, 'forgotEmailField', 'bukan-email');
      await _tapButton(tester, 'Kirim Tautan');
      expect(find.text('Format email tidak valid!'), findsOneWidget);
    });

    testWidgets('berhasil: dialog tampil, lanjut ke Atur Ulang', (
      tester,
    ) async {
      await _open(
        tester,
        const ForgotPasswordScreen(),
        server: MockClient((request) async {
          expect(request.url.path, '/api/v1/auth/password-reset/');
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body, {'email': 'alisa@example.com'});
          return http.Response('{}', 200);
        }),
      );

      await _type(tester, 'forgotEmailField', 'alisa@example.com');
      await _tapButton(tester, 'Kirim Tautan');

      expect(find.text('Cek emailmu'), findsOneWidget);

      await tester.tap(find.text('Atur ulang sekarang'));
      await tester.pumpAndSettle();

      expect(find.byType(ResetPasswordScreen), findsOneWidget);
      expect(find.byType(ForgotPasswordScreen), findsNothing);
    });

    testWidgets('tombol Tutup pada dialog tetap di halaman Lupa', (
      tester,
    ) async {
      await _open(tester, const ForgotPasswordScreen());

      await _type(tester, 'forgotEmailField', 'alisa@example.com');
      await _tapButton(tester, 'Kirim Tautan');
      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
      expect(find.text('Cek emailmu'), findsNothing);
    });
  });

  group('ResetPasswordScreen', () {
    testWidgets('validasi: terlalu pendek dan konfirmasi tidak sama', (
      tester,
    ) async {
      await _open(tester, const ResetPasswordScreen());

      await _type(tester, 'resetPasswordField', 'pendek');
      await _type(tester, 'resetConfirmField', 'beda');
      await _tapButton(tester, 'Simpan Kata Sandi');

      expect(find.text('Kata sandi minimal 8 karakter!'), findsOneWidget);
      expect(find.text('Konfirmasi kata sandi tidak sama!'), findsOneWidget);
    });

    testWidgets('berhasil: kirim uid, token, dan sandi baru', (tester) async {
      await _open(
        tester,
        const ResetPasswordScreen(uid: 'u1', token: 't1'),
        server: MockClient((request) async {
          expect(request.url.path, '/api/v1/auth/password-reset/confirm/');
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body, {
            'uid': 'u1',
            'token': 't1',
            'new_password': 'sandibaru123',
          });
          return http.Response('{}', 200);
        }),
      );

      await _type(tester, 'resetPasswordField', 'sandibaru123');
      await _type(tester, 'resetConfirmField', 'sandibaru123');
      await _tapButton(tester, 'Simpan Kata Sandi');

      expect(find.byType(ResetPasswordScreen), findsNothing);
      expect(find.text('Kata sandi diperbarui. Silakan masuk.'), findsOneWidget);
    });

    testWidgets('tautan kedaluwarsa (400): pesan error dan tetap di halaman', (
      tester,
    ) async {
      await _open(
        tester,
        const ResetPasswordScreen(uid: 'u1', token: 'lama'),
        server: MockClient((_) async => http.Response('{}', 400)),
      );

      await _type(tester, 'resetPasswordField', 'sandibaru123');
      await _type(tester, 'resetConfirmField', 'sandibaru123');
      await _tapButton(tester, 'Simpan Kata Sandi');

      expect(find.byType(ResetPasswordScreen), findsOneWidget);
      expect(find.textContaining('kedaluwarsa'), findsOneWidget);
    });
  });
}
