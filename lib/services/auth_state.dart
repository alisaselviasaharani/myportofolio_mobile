import 'package:flutter/foundation.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Menyimpan token autentikasi sesi saat ini.
///
/// Token selalu ada di memori. Jika pengguna mencentang "Ingat saya", token
/// juga disimpan di penyimpanan lokal (kunci `auth_token`) dan dipulihkan
/// lewat [restore] saat aplikasi dibuka lagi.
class AuthState extends ChangeNotifier {
  AuthState(this._apiClient, {String? initialToken}) : _token = initialToken;

  static const String _tokenKey = 'auth_token';

  final ApiClient _apiClient;
  String? _token;

  /// `true` jika ada token yang tersimpan di penyimpanan lokal.
  bool _stored = false;

  String? get token => _token;

  bool get isLoggedIn => _token != null;

  /// Memulihkan token yang tersimpan ("Ingat saya"). Tidak melakukan apa-apa
  /// jika belum ada token atau penyimpanan tidak bisa dibaca.
  Future<void> restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_tokenKey);
      if (saved != null && saved.isNotEmpty) {
        _token = saved;
        _stored = true;
        notifyListeners();
      }
    } catch (_) {
      // Abaikan: pengguna cukup login ulang.
    }
  }

  Future<void> login(
    String username,
    String password, {
    bool remember = false,
  }) async {
    _token = await _apiClient.obtainToken(username, password);
    await _persist(remember);
    notifyListeners();
  }

  /// Login dengan ID token Google (ditukar menjadi token DRF oleh backend).
  Future<void> loginWithGoogle(String idToken, {bool remember = false}) async {
    _token = await _apiClient.loginWithGoogle(idToken);
    await _persist(remember);
    notifyListeners();
  }

  Future<void> logout() async {
    final current = _token;
    if (current == null) return;
    try {
      await _apiClient.logout(token: current);
    } on ApiException {
      // Token mungkin sudah kedaluwarsa/dicabut di server; sesi lokal tetap
      // harus dibersihkan.
    } finally {
      _token = null;
      await _persist(false);
      notifyListeners();
    }
  }

  /// Menyimpan token jika [remember], atau menghapus token tersimpan.
  /// Penyimpanan tidak disentuh jika tidak ada yang perlu disimpan/dihapus.
  Future<void> _persist(bool remember) async {
    final shouldSave = remember && _token != null;
    if (!shouldSave && !_stored) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = _token;
      if (shouldSave && token != null) {
        await prefs.setString(_tokenKey, token);
        _stored = true;
      } else {
        await prefs.remove(_tokenKey);
        _stored = false;
      }
    } catch (_) {
      // Abaikan: sesi tetap berjalan di memori.
    }
  }
}
