import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';

const _cardNames = [
  'Lihat Experience',
  'Tambah Experience',
  'Tambah Education',
  'Tambah Achievement',
  'Logout',
];

/// Membuka drawer lewat tombol hamburger pada AppBar.
Future<void> _openDrawer(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Open navigation menu'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Halaman utama menampilkan identitas dan menu', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('2506618433'), findsOneWidget);
    expect(find.text('Alisa Selvia Saharani'), findsOneWidget);
    expect(find.text('PBP D'), findsOneWidget);

    for (final name in _cardNames) {
      expect(find.text(name), findsOneWidget);
    }
  });

  for (final name in _cardNames) {
    testWidgets('Tombol $name menampilkan SnackBar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      await tester.ensureVisible(find.text(name));
      await tester.tap(find.text(name));
      await tester.pump();

      expect(find.text('Kamu telah menekan tombol $name!'), findsOneWidget);
    });
  }

  testWidgets('Kartu Tambah Achievement membuka form dan bisa kembali', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Tambah Achievement'));
    await tester.tap(find.text('Tambah Achievement'));
    await tester.pumpAndSettle();
    expect(find.text('Add Achievement Form'), findsOneWidget);

    // Setara tombol kembali bawaan perangkat (Navigator.pop).
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
  });

  testWidgets('Drawer membuka form Achievement dan Home kembali ke utama', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await _openDrawer(tester);
    await tester.tap(find.text('Add Achievement'));
    await tester.pumpAndSettle();
    expect(find.text('Add Achievement Form'), findsOneWidget);

    // Drawer yang sama tersedia di halaman form.
    await _openDrawer(tester);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
  });

  testWidgets('Kartu Tambah Education membuka form Education', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Tambah Education'));
    await tester.tap(find.text('Tambah Education'));
    await tester.pumpAndSettle();
    expect(find.text('Add Education Form'), findsOneWidget);
  });

  testWidgets('Drawer membuka form Education', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await _openDrawer(tester);
    await tester.tap(find.text('Add Education'));
    await tester.pumpAndSettle();
    expect(find.text('Add Education Form'), findsOneWidget);
  });
}
