
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/l10n/app_strings.dart';
import 'package:myportofolio_mobile/screens/language_screen.dart';
import 'package:myportofolio_mobile/services/app_settings.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';
import 'package:myportofolio_mobile/widgets/settings_tile.dart';
import 'package:provider/provider.dart';

/// Halaman Pengaturan aplikasi.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  /// Menampilkan informasi fitur yang belum tersedia.
  void _comingSoon(
    BuildContext context,
    String label,
    String comingSoon,
  ) {
    showInfoSnackBar(
      context,
      '$label $comingSoon',
    );
  }

  /// Membuka halaman pengaturan bahasa.
  void _openLanguage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LanguageScreen(),
      ),
    );
  }

  /// Menampilkan pilihan tema aplikasi.
  void _showThemePicker(
    BuildContext context,
    AppStrings strings,
  ) {
    final settings = context.read<AppSettings>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(strings.appearance),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: AppThemeMode.values.map((mode) {
                  final label = switch (mode) {
                    AppThemeMode.system => strings.system,
                    AppThemeMode.light => strings.light,
                    AppThemeMode.dark => strings.dark,
                  };

                  return RadioListTile<AppThemeMode>(
                    key: ValueKey(
                      'themeOption_${mode.name}',
                    ),
                    value: mode,
                    groupValue: settings.themeMode,
                    title: Text(label),
                    onChanged: (value) {
                      if (value == null) return;

                      settings.setThemeMode(value);

                      setDialogState(() {});

                      Navigator.pop(dialogContext);
                    },
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }

  /// Menampilkan informasi aplikasi.
  void _showAbout(
    BuildContext context,
    AppStrings strings,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('MyPortfolio'),
        content: Text(
          '${strings.version} $appVersion',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: Text(strings.close),
          ),
        ],
      ),
    );
  }

  /// Mengelola proses logout.
  Future<void> _logout(
    BuildContext context, {
    required AppStrings strings,
  }) async {
    final auth = context.read<AuthState>();

    if (!auth.isLoggedIn) {
      showInfoSnackBar(
        context,
        strings.notLoggedIn,
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.logoutTitle),
        content: Text(strings.logoutMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: Text(strings.logout),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await auth.logout();

    if (!context.mounted) return;

    showInfoSnackBar(
      context,
      strings.loggedOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    final settings = context.watch<AppSettings>();
    final themeMode = settings.themeMode;

    final top =
        MediaQuery.paddingOf(context).top + oceanAppBarHeight;

    final themeLabel = switch (themeMode) {
      AppThemeMode.system => strings.system,
      AppThemeMode.light => strings.light,
      AppThemeMode.dark => strings.dark,
    };

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,

      appBar: oceanAppBar(
        title: strings.settings,
      ),

      drawer: const LeftDrawer(
        selected: DrawerDestination.settings,
      ),

      bottomNavigationBar: const OceanBottomBar(),

      body: OceanBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            18,
            top + 10,
            18,
            120,
          ),
          child: Column(
            children: [
              // Akun dan Profil.
              SettingsTile(
                icon: Icons.person_outline,
                title: strings.accountProfile,
                onTap: () => _comingSoon(
                  context,
                  strings.accountProfile,
                  strings.comingSoon,
                ),
              ),

              const SizedBox(height: 8),

              // Bahasa.
              SettingsTile(
                icon: Icons.people_outline,
                title: strings.language,
                onTap: () => _openLanguage(context),
              ),

              const SizedBox(height: 8),

              // Notifikasi.
              SettingsTile(
                icon: Icons.notifications_none,
                title: strings.notifications,
                onTap: () => _comingSoon(
                  context,
                  strings.notifications,
                  strings.comingSoon,
                ),
              ),

              const SizedBox(height: 8),

              // Tampilan aplikasi.
              SettingsTile(
                icon: Icons.wb_sunny_outlined,
                title: strings.appearance,
                subtitle: themeLabel,
                onTap: () => _showThemePicker(
                  context,
                  strings,
                ),
              ),

              const SizedBox(height: 8),

              // Tentang aplikasi.
              SettingsTile(
                icon: Icons.info_outline,
                title: strings.about,
                subtitle: '${strings.version} $appVersion',
                onTap: () => _showAbout(
                  context,
                  strings,
                ),
              ),

              const SizedBox(height: 8),

              // Keluar.
              SettingsTile(
                icon: Icons.delete_outline,
                title: strings.logout,
                destructive: true,
                onTap: () => _logout(
                  context,
                  strings: strings,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
