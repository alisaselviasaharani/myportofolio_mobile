import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/app_settings.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/services/notification_state.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';

import 'package:provider/provider.dart';

/// Titik masuk aplikasi.
void main() {
  runApp(
    MyApp(apiClient: ApiClient()),
  );
}

/// Widget root aplikasi MyPortfolio.
class MyApp extends StatelessWidget {
  const MyApp({
    required this.apiClient,
    super.key,
  });

  final ApiClient apiClient;

  /// Mengubah AppThemeMode menjadi ThemeMode Flutter.
  ThemeMode _getThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return ThemeMode.system;

      case AppThemeMode.light:
        return ThemeMode.light;

      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // API Client.
        Provider.value(
          value: apiClient,
        ),

        // Authentication State.
        ChangeNotifierProvider(
          create: (_) => AuthState(apiClient),
        ),

        // Application Settings.
        ChangeNotifierProvider(
          create: (_) => AppSettings(),
        ),

        // Notification State.
        ChangeNotifierProvider(
          create: (context) => NotificationState(
            context.read<AppSettings>(),
          ),
        ),
      ],

      // MaterialApp membaca perubahan AppSettings.
      child: Consumer<AppSettings>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'MyPortfolio',

            // Tema terang.
            theme: buildOceanTheme(),

            // Tema gelap sementara menggunakan dark theme bawaan.
            // Bisa diganti dengan desain Ocean Dark Theme nantinya.
            darkTheme: ThemeData.dark(),

            // Mengikuti pilihan pengguna.
            themeMode: _getThemeMode(settings.themeMode),

            // Membatasi lebar tampilan pada web/desktop.
            builder: (context, child) {
              return ColoredBox(
                color: const Color(0xFFCDEEF9),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 430,
                    ),
                    child: child,
                  ),
                ),
              );
            },

            // Halaman awal aplikasi.
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}
