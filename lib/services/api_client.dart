import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/experience.dart';

/// Exception thrown when an API request returns a non-2xx status code.
class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// HTTP client for the MyPortfolio Django REST Framework backend.
///
/// Memakai kunci header berupa string biasa (bukan `HttpHeaders` dari
/// `dart:io`) agar tetap berjalan di Flutter Web.
class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        baseUrl = baseUrl ?? apiBaseUrl;

  final http.Client _client;
  final String baseUrl;

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  /// Path endpoint experience pada backend Django.
  static const String _experiencesPath = '/api/v1/experiences/';

  /// GET /api/v1/experiences/ (publik).
  Future<List<Experience>> getExperiences() async {
    final response = await _client.get(
      _uri(_experiencesPath),
      headers: const {'Accept': 'application/json'},
    );
    _ensureSuccess(response);
    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => Experience.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// POST /api/v1/experiences/ (butuh token).
  Future<Experience> createExperience(
    Experience experience, {
    required String token,
  }) async {
    final response = await _client.post(
      _uri(_experiencesPath),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(experience.toJson()),
    );
    _ensureSuccess(response);
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return Experience.fromJson(decoded);
  }

  /// POST /api/v1/auth/token/ : menukar username + password menjadi token.
  Future<String> obtainToken(String username, String password) async {
    final response = await _client.post(
      _uri('/api/v1/auth/token/'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );
    _ensureSuccess(response);
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return decoded['token'] as String;
  }

  /// POST /api/v1/auth/logout/ : mencabut token saat ini (204 No Content).
  Future<void> logout({required String token}) async {
    final response = await _client.post(
      _uri('/api/v1/auth/logout/'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      },
    );
    _ensureSuccess(response);
  }

  /// POST /api/v1/auth/register/ : membuat akun baru (publik).
  ///
  /// Backend Django perlu menyediakan endpoint ini; body-nya berisi
  /// `full_name`, `email`, `username`, dan `password`.
  Future<void> register({
    required String fullName,
    required String email,
    required String username,
    required String password,
  }) async {
    final response = await _client.post(
      _uri('/api/v1/auth/register/'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'username': username,
        'password': password,
      }),
    );
    _ensureSuccess(response);
  }

  /// POST /api/v1/auth/password-reset/ : meminta tautan atur ulang lewat email.
  ///
  /// Server sebaiknya selalu membalas sukses meski email tidak terdaftar,
  /// agar tidak membocorkan daftar akun.
  Future<void> requestPasswordReset(String email) async {
    final response = await _client.post(
      _uri('/api/v1/auth/password-reset/'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email}),
    );
    _ensureSuccess(response);
  }

  /// POST /api/v1/auth/password-reset/confirm/ : menyimpan kata sandi baru
  /// memakai `uid` dan `token` dari tautan di email.
  Future<void> confirmPasswordReset({
    required String uid,
    required String token,
    required String newPassword,
  }) async {
    final response = await _client.post(
      _uri('/api/v1/auth/password-reset/confirm/'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'uid': uid,
        'token': token,
        'new_password': newPassword,
      }),
    );
    _ensureSuccess(response);
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw ApiException(response.statusCode, response.body);
  }
}