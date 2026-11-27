
import 'package:flutter/foundation.dart';

/// Bahasa yang didukung aplikasi.
enum AppLanguage { id, en }

/// Menyimpan pengaturan aplikasi selama sesi berjalan.
class AppSettings extends ChangeNotifier {
  AppLanguage _language;

  AppSettings([this._language = AppLanguage.id]);

  AppLanguage get language => _language;

  void setLanguage(AppLanguage value) {
    if (value == _language) return;

    _language = value;
    notifyListeners();
  }
}
