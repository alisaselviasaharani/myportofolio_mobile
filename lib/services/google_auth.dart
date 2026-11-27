import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myportofolio_mobile/config.dart';

/// Fungsi yang mengembalikan ID token Google, atau `null` jika pengguna
/// membatalkan. Dibuat sebagai tipe agar bisa diganti palsu di test.
typedef GoogleIdTokenProvider = Future<String?> Function();

/// Login Google tidak bisa dijalankan (belum dikonfigurasi atau platform
/// tidak didukung). [message] aman ditampilkan langsung ke pengguna.
class GoogleAuthUnavailable implements Exception {
  const GoogleAuthUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Membuka pemilih akun Google di Android/iOS dan mengambil ID token-nya.
class GoogleAuthService {
  const GoogleAuthService._();

  static bool _initialized = false;

  static Future<String?> getIdToken() async {
    if (kIsWeb) {
      throw const GoogleAuthUnavailable(
        'Masuk dengan Google belum tersedia di versi web. '
        'Jalankan di emulator atau HP Android.',
      );
    }
    if (googleServerClientId.isEmpty) {
      throw const GoogleAuthUnavailable(
        'Masuk dengan Google belum dikonfigurasi. Jalankan dengan '
        '--dart-define=GOOGLE_SERVER_CLIENT_ID=<web client id>.',
      );
    }

    final signIn = GoogleSignIn.instance;
    if (!_initialized) {
      await signIn.initialize(serverClientId: googleServerClientId);
      _initialized = true;
    }

    try {
      final account = await signIn.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const GoogleAuthUnavailable(
          'Google tidak mengirim token. Periksa konfigurasi Client ID.',
        );
      }
      return idToken;
    } on GoogleSignInException catch (e) {
      // Pengguna menutup pemilih akun: bukan error.
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }
}
