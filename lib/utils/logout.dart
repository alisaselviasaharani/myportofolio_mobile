import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// Logout lalu kembali ke halaman Login.
///
/// Token dicabut di server dan dihapus dari penyimpanan lokal (hasil "Ingat
/// saya"). Setelah itu seluruh stack halaman diganti [LoginScreen], supaya
/// pengguna tidak bisa menekan "kembali" ke halaman yang butuh login. Dipakai
/// bersama oleh beranda, drawer, dan Pengaturan.
Future<void> logoutAndShowLogin(
  BuildContext context, {
  String message = 'Berhasil logout.',
}) async {
  // Ambil dulu sebelum await, karena context bisa tidak berlaku lagi setelahnya.
  final auth = context.read<AuthState>();
  final navigator = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);

  await auth.logout();

  navigator.pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const LoginScreen(entry: true)),
    (route) => false,
  );
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
