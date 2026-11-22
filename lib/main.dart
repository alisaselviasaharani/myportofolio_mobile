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
      // Di layar lebar (web/desktop), batasi lebar seperti layar HP agar
      // proporsinya sama dengan desain.
      builder: (context, child) => ColoredBox(
        color: const Color(0xFFCDEEF9),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: child,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}
