import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/l10n/app_strings.dart';
import 'package:myportofolio_mobile/screens/language_screen.dart';
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

  void _comingSoon(
    BuildContext context,
    String label,
    String comingSoon,
  ) {
    showInfoSnackBar(context, '$label $comingSoon');
  }

  void _openLanguage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LanguageScreen(),
      ),
    );
  }

  void _showAbout(
    BuildContext context,
    AppStrings strings,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('MyPortfolio'),
        content: Text('${strings.version} $appVersion'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(strings.close),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(
    BuildContext context, {
    required AppStrings strings,
  }) async {
    final auth = context.read<AuthState>();

    // Jika pengguna belum login, tampilkan informasi.
    if (!auth.isLoggedIn) {
      showInfoSnackBar(context, strings.notLoggedIn);
      return;
    }

    // Konfirmasi sebelum logout.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.logoutTitle),
        content: Text(strings.logoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(strings.logout),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await auth.logout();

    if (!context.mounted) return;

    showInfoSnackBar(context, strings.loggedOut);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final top =
        MediaQuery.paddingOf(context).top + oceanAppBarHeight;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: oceanAppBar(title: strings.settings),
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

              SettingsTile(
                icon: Icons.people_outline,
                title: strings.language,
                onTap: () => _openLanguage(context),
              ),
              const SizedBox(height: 8),

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

              SettingsTile(
                icon: Icons.wb_sunny_outlined,
                title: strings.appearance,
                subtitle: strings.light,
                onTap: () => _comingSoon(
                  context,
                  strings.appearance,
                  strings.comingSoon,
                ),
              ),
              const SizedBox(height: 8),

              SettingsTile(
                icon: Icons.info_outline,
                title: strings.about,
                subtitle: '${strings.version} $appVersion',
                onTap: () => _showAbout(context, strings),
              ),
              const SizedBox(height: 8),

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
