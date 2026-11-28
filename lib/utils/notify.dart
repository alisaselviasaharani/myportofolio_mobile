import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/services/notification_state.dart';
import 'package:provider/provider.dart';

/// Menambahkan notifikasi dalam aplikasi dari mana saja.
///
/// Aman dipanggil walau [NotificationState] tidak tersedia (misalnya pada
/// test widget): dalam kasus itu tidak terjadi apa-apa. Tidak menambah apa pun
/// jika pengguna mematikan notifikasi di layar Notifikasi.
void pushNotification(BuildContext context, String title, String body) {
  try {
    context.read<NotificationState>().add(title, body);
  } on ProviderNotFoundException {
    // Tidak ada NotificationState di pohon widget: lewati.
  }
}
