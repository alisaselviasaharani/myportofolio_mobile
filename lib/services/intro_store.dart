import 'package:shared_preferences/shared_preferences.dart';

/// Menyimpan apakah onboarding sudah pernah dilihat, agar hanya tampil sekali.
class IntroStore {
  const IntroStore._();

  static const String _key = 'onboarding_seen';

  /// `false` jika belum pernah dilihat atau penyimpanan tidak bisa dibaca.
  static Future<bool> hasSeenOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_key) ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> markOnboardingSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, true);
    } catch (_) {
      // Abaikan: onboarding akan tampil lagi pada peluncuran berikutnya.
    }
  }
}
