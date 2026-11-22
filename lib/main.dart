import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';

/// Titik masuk aplikasi.
void main() {
  runApp(const MyApp());
}

/// Widget root: membangun [MaterialApp] (tema laut + halaman awal [MyHomePage]).
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPortfolio',
      theme: buildOceanTheme(),
      home: MyHomePage(),
    );
  }
}
