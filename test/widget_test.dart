// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Halaman utama menampilkan identitas dan menu', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('2506618433'), findsOneWidget);
    expect(find.text('Alisa Selvia Saharani'), findsOneWidget);
    expect(find.text('PBP D'), findsOneWidget);

    expect(find.text('Lihat Experience'), findsOneWidget);
    expect(find.text('Tambah Experience'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('Tombol Logout menampilkan SnackBar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Logout'));
    await tester.pump();

    expect(find.text('Kamu telah menekan tombol Logout!'), findsOneWidget);
  });

  testWidgets('Tombol Lihat Experience membuka daftar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Lihat Experience'));
    await tester.pumpAndSettle();

    expect(find.text('Experience'), findsOneWidget);
    expect(find.text('Math Club Chairperson'), findsOneWidget);
  });
}
