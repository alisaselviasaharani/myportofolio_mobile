import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/app_settings.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:provider/provider.dart';

/// Titik masuk aplikasi.
void main() {
  runApp(MyApp(apiClient: ApiClient()));
}

/// Widget root: membangun [MaterialApp] (tema laut + halaman awal [MyHomePage]).
///
/// [MultiProvider] menyisipkan [ApiClient] dan [AuthState] ke seluruh widget
/// tree sehingga bisa dibaca dari layar mana pun dengan `context.read` /
/// `context.watch`.
class MyApp extends StatelessWidget {
  const MyApp({required this.apiClient, super.key});

  final ApiClient apiClient;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: apiClient),
        ChangeNotifierProvider(create: (_) => AuthState(apiClient)),
        ChangeNotifierProvider(create: (_) => AppSettings()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
