import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_detail_screen.dart';
import 'package:myportofolio_mobile/screens/favorite_screen.dart';

final Education _ui = Education(
  institution: 'Universitas Indonesia',
  degree: 'S1 - Ilmu Komputer',
  level: DegreeLevel.bachelor,
  major: 'Ilmu Komputer',
  startDate: DateTime(2023, 9, 1),
  endDate: DateTime(2027, 6, 1),
  isCurrent: true,
  period: 'Sep 2023 – Jun 2027',
);

Future<void> _pump(WidgetTester tester, Widget home) async {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(home: home));
}

void main() {
  setUp(() => PortfolioStore.instance.clear());

  testWidgets('Favorit kosong menampilkan pesan', (tester) async {
    await _pump(tester, const FavoriteScreen());

    expect(find.text('Belum ada pendidikan favorit.'), findsOneWidget);
  });

  testWidgets('Favorit menampilkan kartu dan membuka detail', (tester) async {
    PortfolioStore.instance.toggleFavorite(_ui);
    await _pump(tester, const FavoriteScreen());

    expect(find.text('Universitas Indonesia'), findsOneWidget);
    expect(find.text('S1 – Ilmu Komputer'), findsOneWidget);

    await tester.tap(find.text('Universitas Indonesia'));
    await tester.pumpAndSettle();
    expect(find.byType(EducationDetailScreen), findsOneWidget);
  });

  testWidgets('Bintang di detail menambah dan menghapus favorit', (
    tester,
  ) async {
    await _pump(tester, EducationDetailScreen(education: _ui));

    await tester.tap(find.byTooltip('Tambah ke favorit'));
    await tester.pump();
    expect(PortfolioStore.instance.isFavorite(_ui), isTrue);
    expect(find.byTooltip('Hapus dari favorit'), findsOneWidget);

    await tester.tap(find.byTooltip('Hapus dari favorit'));
    await tester.pump();
    expect(PortfolioStore.instance.isFavorite(_ui), isFalse);
    expect(find.byTooltip('Tambah ke favorit'), findsOneWidget);
  });
}
