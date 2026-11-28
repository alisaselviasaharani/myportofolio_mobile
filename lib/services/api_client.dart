import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/models/achievement.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      baseUrl = baseUrl ?? apiBaseUrl;

  final http.Client _client;
  final String baseUrl;

  Uri _uri(String path) {
    final cleanBaseUrl = baseUrl.replaceFirst(RegExp(r'/+$'), '');

    final cleanPath = path.startsWith('/') ? path : '/$path';

    return Uri.parse('$cleanBaseUrl$cleanPath');
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    throw ApiException(response.statusCode, response.body);
  }

  Future<List<T>> _getList<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final response = await _client.get(
      _uri(path),
      headers: const {'Accept': 'application/json'},
    );

    _ensureSuccess(response);

    final decoded = jsonDecode(response.body);

    final List<dynamic> results;

    if (decoded is List) {
      results = decoded;
    } else if (decoded is Map<String, dynamic> && decoded['results'] is List) {
      results = decoded['results'] as List<dynamic>;
    } else {
      throw const FormatException('Format respons API tidak sesuai.');
    }

    return results.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Format item API tidak sesuai.');
      }

      return fromJson(item);
    }).toList();
  }

  static const String _experiencesPath = '/api/v1/experience/';

  Future<List<Experience>> getExperiences() {
    return _getList<Experience>(_experiencesPath, Experience.fromJson);
  }

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

  static const String _educationPath = '/api/v1/education/';

  Future<List<Education>> getEducations() {
    return _getList<Education>(_educationPath, Education.fromJson);
  }

  Future<Education> createEducation(
    Education education, {
    required String token,
  }) async {
    final response = await _client.post(
      _uri(_educationPath),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(education.toJson()),
    );

    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    return Education.fromJson(decoded);
  }

  /// Memperbarui pendidikan yang sudah punya `id` (PATCH).
  Future<Education> updateEducation(
    Education education, {
    required String token,
  }) async {
    final response = await _client.patch(
      _uri('$_educationPath${education.id}/'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(education.toJson()),
    );

    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    return Education.fromJson(decoded);
  }

  static const String _achievementsPath = '/api/v1/achievements/';

  Future<List<Achievement>> getAchievements() {
    return _getList<Achievement>(_achievementsPath, Achievement.fromJson);
  }

  Future<Achievement> createAchievement(
    Achievement achievement, {
    required String token,
  }) async {
    final response = await _client.post(
      _uri(_achievementsPath),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(achievement.toJson()),
    );

    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    return Achievement.fromJson(decoded);
  }

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

  /// Menukar ID token Google menjadi token DRF (backend memverifikasi ke Google).
  Future<String> loginWithGoogle(String idToken) async {
    final response = await _client.post(
      _uri('/api/v1/auth/google/'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id_token': idToken}),
    );

    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    return decoded['token'] as String;
  }

  Future<void> logout({required String token}) async {
    final response = await _client.post(
      _uri('/api/v1/auth/logout/'),
      headers: {'Accept': 'application/json', 'Authorization': 'Token $token'},
    );

    _ensureSuccess(response);
  }

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
}
