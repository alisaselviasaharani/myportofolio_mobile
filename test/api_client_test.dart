import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

const _experienceJson = {
  'id': '3f2b8c1e-0000-0000-0000-000000000001',
  'title': 'Backend Intern',
  'institution': 'PT Contoh',
  'description': 'Membuat REST API.',
  'category': 'Internship',
  'period': null,
  'website': null,
};

ApiClient _clientWith(MockClientHandler handler) {
  return ApiClient(client: MockClient(handler), baseUrl: 'http://test');
}

void main() {
  group('Experience', () {
    test('fromJson memetakan field dan null menjadi kosong', () {
      final experience = Experience.fromJson(_experienceJson);
      expect(experience.id, '3f2b8c1e-0000-0000-0000-000000000001');
      expect(experience.position, 'Backend Intern');
      expect(experience.period, '');
      expect(experience.link, '');
    });

    test('toJson tidak menyertakan id', () {
      final json = Experience.fromJson(_experienceJson).toJson();
      expect(json.containsKey('id'), isFalse);
      expect(json['institution'], 'PT Contoh');
      expect(json['category'], 'Internship');
    });
  });

  group('ApiClient', () {
    test('getExperiences mengembalikan daftar Experience', () async {
      final client = _clientWith((request) async {
        expect(request.method, 'GET');
        expect(request.url.toString(), 'http://test/api/v1/experience/');
        return http.Response(jsonEncode([_experienceJson]), 200);
      });
      final experiences = await client.getExperiences();
      expect(experiences, hasLength(1));
      expect(experiences.first.position, 'Backend Intern');
    });

    test('createExperience mengirim header Authorization dan body', () async {
      final client = _clientWith((request) async {
        expect(request.method, 'POST');
        expect(request.headers['Authorization'], 'Token abc123');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['title'], 'Baru');
        expect(body['institution'], 'PT Contoh');
        expect(body['category'], 'Full-time');
        expect(body.containsKey('id'), isFalse);
        return http.Response(jsonEncode(_experienceJson), 201);
      });
      final created = await client.createExperience(
        const Experience(
          position: 'Baru',
          company: 'PT Contoh',
          description: 'Deskripsi',
          type: 'Full-time',
        ),
        token: 'abc123',
      );
      expect(created.id, isNotNull);
    });

    test('obtainToken mengembalikan token', () async {
      final client = _clientWith((request) async {
        expect(request.url.path, '/api/v1/auth/token/');
        return http.Response(jsonEncode({'token': 'xyz'}), 200);
      });
      expect(await client.obtainToken('alisa', 'rahasia'), 'xyz');
    });

    test('status non-2xx melempar ApiException', () async {
      final client = _clientWith(
        (request) async => http.Response('{"detail":"nope"}', 400),
      );
      expect(
        () => client.obtainToken('a', 'b'),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'code', 400)),
      );
    });
  });

  group('AuthState', () {
    test('login menyimpan token dan logout membersihkannya', () async {
      final client = _clientWith((request) async {
        if (request.url.path == '/api/v1/auth/token/') {
          return http.Response(jsonEncode({'token': 'tok'}), 200);
        }
        return http.Response('', 204);
      });
      final auth = AuthState(client);
      expect(auth.isLoggedIn, isFalse);

      await auth.login('alisa', 'rahasia');
      expect(auth.isLoggedIn, isTrue);
      expect(auth.token, 'tok');

      await auth.logout();
      expect(auth.isLoggedIn, isFalse);
    });

    test('logout tetap membersihkan token walau server menolak', () async {
      final client = _clientWith((request) async => http.Response('', 401));
      final auth = AuthState(client, initialToken: 'lama');
      await auth.logout();
      expect(auth.token, isNull);
    });
  });
}
