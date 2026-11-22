import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/models/education.dart';

const _cardNames = [
  'Tambah Experience',
  'Tambah Education',
  'Tambah Achievement',
  'Lihat Experience',
];

/// Membuka drawer lewat tombol hamburger pada AppBar.
Future<void> _openDrawer(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Open navigation menu'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => PortfolioStore.instance.clear());

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

  testWidgets('Bagian My Portfolio menampilkan jumlah item dari store', (
    WidgetTester tester,
  ) async {
    PortfolioStore.instance.addEducation(
      Education(
        institution: 'Universitas Indonesia',
        degree: 'S1 - Ilmu Komputer',
        startDate: DateTime(2023, 9, 1),
        endDate: DateTime(2027, 6, 1),
        period: '1 Sep 2023 - 1 Jun 2027',
      ),
    );
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Education'));
    expect(find.text('1 item'), findsOneWidget);
    expect(find.text('0 items'), findsNWidgets(2));
  });

  testWidgets('Tombol tambah di bottom bar membuka lembar pilihan form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Tambah'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Education'));
    await tester.pumpAndSettle();
    expect(find.text('Add Education Form'), findsOneWidget);
  });

  testWidgets('Tombol Beranda di bottom bar kembali ke halaman utama', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await _openDrawer(tester);
    await tester.tap(find.text('Add Education'));
    await tester.pumpAndSettle();
    expect(find.text('Add Education Form'), findsOneWidget);

    await tester.tap(find.byTooltip('Beranda'));
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
  });
}
