import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

/// Mengubah error dari permintaan auth menjadi pesan yang mudah dipahami.
///
/// [failed] adalah kalimat dasar, mis. "Login gagal". Jika server membalas
/// 400 atau 401 dan [rejected] diberikan, [rejected] yang dipakai. Error
/// selain [ApiException] dianggap masalah koneksi (server mati, alamat
/// salah, atau CORS di Chrome).
String authErrorMessage(
  Object error, {
  required String failed,
  String? rejected,
}) {
  if (error is ApiException) {
    final isRejected = error.statusCode == 400 || error.statusCode == 401;
    if (isRejected && rejected != null) {
      return rejected;
    }
    return '$failed (status ${error.statusCode}).';
  }
  return 'Tidak dapat terhubung ke $apiBaseUrl: $error';
}
