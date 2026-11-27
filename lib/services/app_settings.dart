import 'package:flutter/foundation.dart';

/// Bahasa yang didukung aplikasi.
enum AppLanguage { id, en }

/// Menyimpan pengaturan aplikasi (saat ini: bahasa) selama sesi berjalan.
///
/// Sama seperti `AuthState`, nilainya disimpan di memori. Dibaca lewat
/// `context.watch<AppSettings>()` agar layar ikut berganti bahasa.
class AppSettings extends ChangeNotifier {
  AppSettings({AppLanguage language = AppLanguage.id}) : _language = language;

  AppLanguage _language;

  AppLanguage get language => _language;

  void setLanguage(AppLanguage value) {
    if (value == _language) return;
    _language = value;
    notifyListeners();
  }
}
