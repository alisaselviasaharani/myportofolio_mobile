import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/utils/notify.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

/// Alur hapus yang dipakai semua halaman detail: dialog konfirmasi, pastikan
/// login, lalu panggil [request] (permintaan DELETE ke Django).
///
/// Mengembalikan `true` jika data berhasil dihapus. Jika gagal, pesan
/// kesalahan ditampilkan dan hasilnya `false`; token yang kedaluwarsa (401)
/// memicu logout lalu meminta login ulang.
Future<bool> confirmAndDelete(
  BuildContext context, {
  required String title,
  required String message,
  required String successMessage,
  required Future<void> Function(ApiClient api, String token) request,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          key: const Key('cancelDeleteButton'),
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Batal'),
        ),
        TextButton(
          key: const Key('confirmDeleteButton'),
          onPressed: () => Navigator.pop(dialogContext, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return false;

  // Pastikan sudah login (membuka LoginScreen jika belum).
  final loggedIn = await ensureLoggedIn(context);
  if (!loggedIn || !context.mounted) return false;

  final auth = context.read<AuthState>();
  final api = context.read<ApiClient>();
  final token = auth.token;
  if (token == null) return false;

  try {
    await request(api, token);
    if (context.mounted) {
      pushNotification(context, 'Data dihapus', successMessage);
      showInfoSnackBar(context, successMessage);
    }
    return true;
  } on ApiException catch (e) {
    if (!context.mounted) return false;
    if (e.statusCode == 401) {
      await auth.logout();
      if (!context.mounted) return false;
      showInfoSnackBar(context, 'Sesi berakhir. Silakan login kembali.');
      await ensureLoggedIn(context);
    } else if (e.statusCode == 404) {
      showInfoSnackBar(context, 'Data tidak ditemukan di server.');
    } else {
      showInfoSnackBar(context, 'Gagal menghapus (status ${e.statusCode}).');
    }
    return false;
  } catch (_) {
    if (context.mounted) {
      showInfoSnackBar(
        context,
        'Tidak dapat terhubung ke server. Pastikan backend Django berjalan.',
      );
    }
    return false;
  }
}
