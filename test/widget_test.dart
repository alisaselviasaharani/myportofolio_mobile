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

  for (final name in ['Lihat Experience', 'Tambah Experience', 'Logout']) {
    testWidgets('Tombol $name menampilkan SnackBar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text(name));
      await tester.pump();

      expect(find.text('Kamu telah menekan tombol $name!'), findsOneWidget);
    });
  }
}
