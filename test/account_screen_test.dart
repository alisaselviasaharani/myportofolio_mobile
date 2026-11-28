import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/account_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

Widget _app(ApiClient api, {String? token}) {
  return MultiProvider(
    providers: [
      Provider.value(value: api),
      ChangeNotifierProvider(create: (_) => AuthState(api, initialToken: token)),
    ],
    child: const MaterialApp(home: AccountScreen()),
  );
}

http.Response _json(Object body, [int status = 200]) => http.Response(
  jsonEncode(body),
  status,
  headers: const {'content-type': 'application/json; charset=utf-8'},
);

void main() {
  void tall(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('belum login menampilkan tombol Login', (tester) async {
    tall(tester);
    await tester.pumpWidget(_app(ApiClient(baseUrl: 'http://test')));

    expect(find.text('Kamu belum login.'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('sudah login menampilkan data akun dari server', (tester) async {
    tall(tester);
    final api = ApiClient(
      baseUrl: 'http://test',
      client: MockClient((request) async {
        expect(request.url.path, '/api/v1/auth/me/');
        expect(request.headers['Authorization'], 'Token tok');
        return _json({
          'username': 'alisa',
          'email': 'alisa@example.com',
          'full_name': 'Alisa Selvia',
        });
      }),
    );
    await tester.pumpWidget(_app(api, token: 'tok'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('accountName')), findsOneWidget);
    expect(find.text('Alisa Selvia'), findsOneWidget);
    expect(find.text('alisa@example.com'), findsOneWidget);
  });

  testWidgets('ubah nama mengirim PATCH dan memperbarui tampilan', (
    tester,
  ) async {
    tall(tester);
    final methods = <String>[];
    final api = ApiClient(
      baseUrl: 'http://test',
      client: MockClient((request) async {
        methods.add(request.method);
        if (request.method == 'PATCH') {
          expect(jsonDecode(request.body), {'full_name': 'Alisa S'});
          return _json({
            'username': 'alisa',
            'email': 'a@b.c',
            'full_name': 'Alisa S',
          });
        }
        return _json({
          'username': 'alisa',
          'email': 'a@b.c',
          'full_name': 'Alisa Selvia',
        });
      }),
    );
    await tester.pumpWidget(_app(api, token: 'tok'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ubah nama'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('fullNameField')), 'Alisa S');
    await tester.tap(find.byKey(const Key('saveNameButton')));
    await tester.pumpAndSettle();

    expect(methods, ['GET', 'PATCH']);
    expect(find.text('Alisa S'), findsOneWidget);
  });

  testWidgets('server lama (404) menampilkan pesan yang jelas', (tester) async {
    tall(tester);
    final api = ApiClient(
      baseUrl: 'http://test',
      client: MockClient((request) async => http.Response('nope', 404)),
    );
    await tester.pumpWidget(_app(api, token: 'tok'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('accountError')), findsOneWidget);
    expect(find.textContaining('Perbarui backend'), findsOneWidget);
  });
}
