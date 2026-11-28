import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/profile_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

Future<void> _pumpProfile(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final apiClient = ApiClient();
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider.value(value: apiClient),
        ChangeNotifierProvider(create: (_) => AuthState(apiClient)),
      ],
      child: const MaterialApp(home: ProfileScreen()),
    ),
  );
}

void main() {
  setUp(() => PortfolioStore.instance.clear());

  testWidgets('Menampilkan identitas dan tombol Login', (tester) async {
    await _pumpProfile(tester);

    expect(find.text('Alisa Selvia Saharani'), findsOneWidget);
    expect(find.text('2506618433'), findsOneWidget);
    expect(find.text('PBP D'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Ringkasan jumlah mengikuti store', (tester) async {
    final education = Education(
      institution: 'Universitas Indonesia',
      degree: 'S1 - Ilmu Komputer',
      startDate: DateTime(2023, 9, 1),
      period: 'Sep 2023',
    );
    PortfolioStore.instance
      ..addEducation(education)
      ..toggleFavorite(education);
    await _pumpProfile(tester);

    // Education dan Favorit bernilai 1; Experience dan Certifications 0.
    expect(find.text('1'), findsNWidgets(2));
    expect(find.text('0'), findsNWidgets(2));
    expect(find.text('Favorit'), findsWidgets);
  });
}
