import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/models/achievement.dart';
import 'package:myportofolio_mobile/models/user_profile.dart';

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

  /// Isi respons sebagai teks UTF-8.
  ///
  /// `response.body` memakai charset dari header, dan jatuh ke latin1 jika
  /// tidak ada. Django REST Framework mengirim `application/json` tanpa
  /// charset, jadi teks seperti "Sep 2023 – Jun 2027" bisa rusak. JSON selalu
  /// UTF-8, maka byte-nya didecode langsung.
  String _utf8Body(http.Response response) => utf8.decode(response.bodyBytes);

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

    final decoded = jsonDecode(_utf8Body(response));

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

    final decoded = jsonDecode(_utf8Body(response)) as Map<String, dynamic>;

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

    final decoded = jsonDecode(_utf8Body(response)) as Map<String, dynamic>;

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

    final decoded = jsonDecode(_utf8Body(response)) as Map<String, dynamic>;

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

    final decoded = jsonDecode(_utf8Body(response)) as Map<String, dynamic>;

    return Achievement.fromJson(decoded);
  }

  Map<String, String> _authJsonHeaders(String token) => {
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Token $token',
  };

  Future<Map<String, dynamic>> _patchJson(
    String path,
    Map<String, dynamic> body, {
    required String token,
  }) async {
    final response = await _client.patch(
      _uri(path),
      headers: _authJsonHeaders(token),
      body: jsonEncode(body),
    );

    _ensureSuccess(response);

    return jsonDecode(_utf8Body(response)) as Map<String, dynamic>;
  }

  /// DELETE dengan token; Django membalas 204 tanpa isi.
  Future<void> _delete(String path, {required String token}) async {
    final response = await _client.delete(
      _uri(path),
      headers: {'Accept': 'application/json', 'Authorization': 'Token $token'},
    );

    _ensureSuccess(response);
  }

  /// Memperbarui experience yang sudah punya `id` (PATCH).
  Future<Experience> updateExperience(
    Experience experience, {
    required String token,
  }) async {
    final json = await _patchJson(
      '$_experiencesPath${experience.id}/',
      experience.toJson(),
      token: token,
    );
    return Experience.fromJson(json);
  }

  Future<void> deleteExperience(Experience experience, {required String token}) {
    return _delete('$_experiencesPath${experience.id}/', token: token);
  }

  Future<void> deleteEducation(Education education, {required String token}) {
    return _delete('$_educationPath${education.id}/', token: token);
  }

  /// Memperbarui achievement yang sudah punya `id` (PATCH).
  Future<Achievement> updateAchievement(
    Achievement achievement, {
    required String token,
  }) async {
    final json = await _patchJson(
      '$_achievementsPath${achievement.id}/',
      achievement.toJson(),
      token: token,
    );
    return Achievement.fromJson(json);
  }

  Future<void> deleteAchievement(
    Achievement achievement, {
    required String token,
  }) {
    return _delete('$_achievementsPath${achievement.id}/', token: token);
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

    final decoded = jsonDecode(_utf8Body(response)) as Map<String, dynamic>;

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

    final decoded = jsonDecode(_utf8Body(response)) as Map<String, dynamic>;

    return decoded['token'] as String;
  }

  /// Mengirim pesan dari form Contact Me; backend meneruskannya ke email
  /// pemilik portofolio. Tidak butuh login.
  Future<void> sendContactMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    final response = await _client.post(
      _uri('/api/v1/contact/'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'name': name, 'email': email, 'message': message}),
    );

    _ensureSuccess(response);
  }

  /// Data akun milik [token].
  Future<UserProfile> getProfile({required String token}) async {
    final response = await _client.get(
      _uri('/api/v1/auth/me/'),
      headers: {'Accept': 'application/json', 'Authorization': 'Token $token'},
    );

    _ensureSuccess(response);

    return UserProfile.fromJson(
      jsonDecode(_utf8Body(response)) as Map<String, dynamic>,
    );
  }

  /// Mengubah nama lengkap akun.
  Future<UserProfile> updateProfileName(
    String fullName, {
    required String token,
  }) async {
    final response = await _client.patch(
      _uri('/api/v1/auth/me/'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode({'full_name': fullName}),
    );

    _ensureSuccess(response);

    return UserProfile.fromJson(
      jsonDecode(_utf8Body(response)) as Map<String, dynamic>,
    );
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
