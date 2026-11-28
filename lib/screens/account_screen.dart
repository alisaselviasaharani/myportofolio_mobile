import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/l10n/app_strings.dart';
import 'package:myportofolio_mobile/models/user_profile.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/logout.dart';
import 'package:myportofolio_mobile/utils/notify.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';
import 'package:myportofolio_mobile/widgets/ocean_button.dart';
import 'package:provider/provider.dart';

/// Halaman "Akun & Profil": data akun yang sedang login (nama, username,
/// email) dari Django, ubah nama lengkap, dan keluar. Jika belum login,
/// halaman menawarkan tombol Login.
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserProfile? _profile;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (context.read<AuthState>().isLoggedIn) {
      _load();
    }
  }

  /// Pesan untuk kegagalan memuat/menyimpan akun.
  String _messageFor(Object error) {
    if (error is ApiException) {
      if (error.statusCode == 404) {
        return 'Server belum mendukung Akun & Profil. Perbarui backend Django.';
      }
      if (error.statusCode == 401) {
        return 'Sesi berakhir. Silakan login kembali.';
      }
      return 'Gagal memuat akun (status ${error.statusCode}).';
    }
    return 'Tidak dapat terhubung ke server. Pastikan backend Django berjalan.';
  }

  Future<void> _load() async {
    final token = context.read<AuthState>().token;
    if (token == null) return;
    final api = context.read<ApiClient>();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final profile = await api.getProfile(token: token);
      if (!mounted) return;
      setState(() => _profile = profile);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = _messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _login() async {
    final ok = await ensureLoggedIn(context);
    if (ok && mounted) {
      setState(() {});
      await _load();
    }
  }

  Future<void> _editName() async {
    final current = _profile?.fullName ?? '';
    final controller = TextEditingController(text: current);
    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ubah nama lengkap'),
        content: TextField(
          key: const Key('fullNameField'),
          controller: controller,
          maxLength: 150,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Nama lengkap'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            key: const Key('saveNameButton'),
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (newName == null || newName.isEmpty || newName == current) return;
    if (!mounted) return;

    final token = context.read<AuthState>().token;
    if (token == null) return;
    final api = context.read<ApiClient>();
    try {
      final updated = await api.updateProfileName(newName, token: token);
      if (!mounted) return;
      setState(() => _profile = updated);
      pushNotification(context, 'Profil diperbarui', 'Nama: ${updated.displayName}');
      showInfoSnackBar(context, 'Nama berhasil diperbarui.');
    } catch (e) {
      if (!mounted) return;
      showInfoSnackBar(context, _messageFor(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: oceanAppBar(title: strings.accountProfile),
      bottomNavigationBar: const OceanBottomBar(),
      body: OceanBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, top + 16, 20, 120),
          child: isLoggedIn ? _buildAccount() : _buildLoggedOut(),
        ),
      ),
    );
  }

  /// Huruf pertama nama untuk avatar ('?' jika data belum ada).
  static String _initial(UserProfile? profile) {
    final name = profile?.displayName ?? '';
    return name.isEmpty ? '?' : name.substring(0, 1).toUpperCase();
  }

  Widget _buildLoggedOut() {
    return _Card(
      child: Column(
        children: [
          const Icon(Icons.account_circle_outlined,
              size: 72, color: OceanColors.navy),
          const SizedBox(height: 12),
          const Text(
            'Kamu belum login.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: OceanColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Login untuk melihat dan mengubah data akunmu.',
            textAlign: TextAlign.center,
            style: TextStyle(color: OceanColors.navy),
          ),
          const SizedBox(height: 18),
          OceanButton(label: 'Login', icon: Icons.login, onPressed: _login),
        ],
      ),
    );
  }

  Widget _buildAccount() {
    final profile = _profile;
    return Column(
      children: [
        _Card(
          child: Column(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: OceanColors.deep,
                child: Text(
                  _initial(profile),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (_loading && profile == null)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(),
                )
              else if (profile == null)
                Column(
                  children: [
                    Text(
                      _error ?? 'Data akun belum dimuat.',
                      key: const Key('accountError'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: OceanColors.navy),
                    ),
                    const SizedBox(height: 8),
                    TextButton(onPressed: _load, child: const Text('Coba lagi')),
                  ],
                )
              else ...[
                Text(
                  profile.displayName,
                  key: const Key('accountName'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: OceanColors.navy,
                  ),
                ),
                const SizedBox(height: 14),
                _InfoRow(
                  icon: Icons.alternate_email,
                  label: 'Username',
                  value: profile.username,
                ),
                _InfoRow(
                  icon: Icons.mail_outline,
                  label: 'Email',
                  value: profile.email.isEmpty ? '-' : profile.email,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (profile != null) ...[
          OceanButton(
            label: 'Ubah nama',
            icon: Icons.edit_outlined,
            onPressed: _editName,
          ),
          const SizedBox(height: 12),
        ],
        OceanButton(
          label: 'Keluar',
          icon: Icons.logout,
          onPressed: () => logoutAndShowLogin(context),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: OceanColors.deep.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: OceanColors.navy),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: OceanColors.navy),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: OceanColors.navy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
