import 'package:flutter/foundation.dart';

/// Bahasa yang didukung aplikasi.
enum AppLanguage { id, en }

/// Pilihan tema aplikasi.
enum AppThemeMode { system, light, dark }

/// Menyimpan pengaturan aplikasi selama sesi berjalan.
class AppSettings extends ChangeNotifier {
  AppSettings([
    this._language = AppLanguage.id,
    this._themeMode = AppThemeMode.light,
    this._notificationsEnabled = true,
  ]);

  AppLanguage _language;
  AppThemeMode _themeMode;
  bool _notificationsEnabled;

  /// Bahasa aplikasi saat ini.
  AppLanguage get language => _language;

  /// Tema aplikasi saat ini.
  AppThemeMode get themeMode => _themeMode;

  /// Status notifikasi aplikasi.
  bool get notificationsEnabled => _notificationsEnabled;

  /// Mengubah bahasa aplikasi.
  void setLanguage(AppLanguage value) {
    if (value == _language) return;

    _language = value;
    notifyListeners();
  }

  /// Mengubah tema aplikasi.
  void setThemeMode(AppThemeMode value) {
    if (value == _themeMode) return;

    _themeMode = value;
    notifyListeners();
  }

  /// Mengaktifkan atau menonaktifkan notifikasi.
  void setNotificationsEnabled(bool value) {
    if (value == _notificationsEnabled) return;

    _notificationsEnabled = value;
    notifyListeners();
  }
}
