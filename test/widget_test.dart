import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Halaman utama menampilkan identitas dan 3 tombol aksi', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // 3 InfoCard berisi identitas pemilik portofolio.
    expect(find.text('NPM'), findsOneWidget);
    expect(find.text('2506618433'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Alisa Selvia Saharani'), findsOneWidget);
    expect(find.text('Class'), findsOneWidget);
    expect(find.text('PBP D'), findsOneWidget);

    // 3 ItemCard.
    expect(find.text('Lihat Experience'), findsOneWidget);
    expect(find.text('Tambah Experience'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('Menekan Logout memunculkan SnackBar yang sesuai', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Logout'));
    await tester.pump();

    expect(find.text('Kamu telah menekan tombol Logout!'), findsOneWidget);
  });

  testWidgets('Menekan Lihat Experience membuka daftar experience', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Lihat Experience'));
    await tester.pumpAndSettle();

    expect(find.text('Math Club Chairperson'), findsOneWidget);
  });
}
