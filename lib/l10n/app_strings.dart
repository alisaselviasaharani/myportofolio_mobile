import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/services/app_settings.dart';
import 'package:provider/provider.dart';

/// Teks dua bahasa (Indonesia / Inggris) untuk layar Pengaturan.
class AppStrings {
  const AppStrings._(this._values);

  final Map<String, String> _values;

  /// Mengambil teks sesuai bahasa aktif; ikut dibangun ulang saat bahasa
  /// berubah.
  static AppStrings of(BuildContext context) {
    final language = context.watch<AppSettings>().language;
    return forLanguage(language);
  }

  static AppStrings forLanguage(AppLanguage language) =>
      language == AppLanguage.id ? _id : _en;

  String get(String key) => _values[key] ?? key;

  String get settings => get('settings');
  String get accountProfile => get('accountProfile');
  String get language => get('language');
  String get notifications => get('notifications');
  String get appearance => get('appearance');
  String get light => get('light');
  String get about => get('about');
  String get version => get('version');
  String get logout => get('logout');
  String get indonesian => get('indonesian');
  String get english => get('english');
  String get navHome => get('navHome');
  String get navPortfolio => get('navPortfolio');
  String get navFavorite => get('navFavorite');
  String get navProfile => get('navProfile');
  String get navAdd => get('navAdd');
  String get addData => get('addData');
  String get logoutTitle => get('logoutTitle');
  String get logoutMessage => get('logoutMessage');
  String get cancel => get('cancel');
  String get notLoggedIn => get('notLoggedIn');
  String get loggedOut => get('loggedOut');
  String get comingSoon => get('comingSoon');
  String get close => get('close');

  static const AppStrings _id = AppStrings._({
    'settings': 'Pengaturan',
    'accountProfile': 'Akun & Profil',
    'language': 'Bahasa',
    'notifications': 'Notifikasi',
    'appearance': 'Tampilan Aplikasi',
    'light': 'Terang',
    'about': 'Tentang Aplikasi',
    'version': 'Versi',
    'logout': 'Keluar',
    'indonesian': 'Bahasa Indonesia (ID)',
    'english': 'English (EN)',
    'navHome': 'Beranda',
    'navPortfolio': 'Portofolio',
    'navFavorite': 'Favorit',
    'navProfile': 'Profil',
    'navAdd': 'Tambah',
    'addData': 'Tambah data',
    'logoutTitle': 'Keluar dari akun?',
    'logoutMessage': 'Kamu perlu login lagi untuk menambah pengalaman.',
    'cancel': 'Batal',
    'notLoggedIn': 'Kamu belum login.',
    'loggedOut': 'Berhasil keluar.',
    'comingSoon': 'akan hadir di tahap berikutnya.',
    'close': 'Tutup',
  });

  static const AppStrings _en = AppStrings._({
    'settings': 'Settings',
    'accountProfile': 'Account & Profile',
    'language': 'Language',
    'notifications': 'Notifications',
    'appearance': 'App Appearance',
    'light': 'Light',
    'about': 'About the App',
    'version': 'Version',
    'logout': 'Log out',
    'indonesian': 'Bahasa Indonesia (ID)',
    'english': 'English (EN)',
    'navHome': 'Home',
    'navPortfolio': 'Portfolio',
    'navFavorite': 'Favorites',
    'navProfile': 'Profile',
    'navAdd': 'Add',
    'addData': 'Add data',
    'logoutTitle': 'Log out?',
    'logoutMessage': 'You will need to log in again to add experience.',
    'cancel': 'Cancel',
    'notLoggedIn': 'You are not logged in.',
    'loggedOut': 'Logged out.',
    'comingSoon': 'is coming in a later stage.',
    'close': 'Close',
  });
}
