import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/reset_password_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/auth_errors.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/auth_form_parts.dart';
import 'package:myportofolio_mobile/widgets/auth_mascots.dart';
import 'package:myportofolio_mobile/widgets/auth_scaffold.dart';
import 'package:provider/provider.dart';

/// Halaman Lupa Kata Sandi: meminta tautan atur ulang lewat email.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;

    final api = context.read<ApiClient>();
    final email = _email.text.trim();
    setState(() {
      _isSubmitting = true;
    });

    var sent = false;
    try {
      await api.requestPasswordReset(email);
      sent = true;
    } catch (e) {
      if (mounted) {
        showInfoSnackBar(
          context,
          authErrorMessage(e, failed: 'Gagal mengirim tautan'),
        );
      }
    } finally {
      // Lepas status loading sebelum dialog tampil, agar indikator putar di
      // tombol tidak terus berjalan di belakang dialog.
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }

    if (sent && mounted) {
      await _showSentDialog(email);
    }
  }

  /// Dialog konfirmasi. Teksnya tidak menyatakan apakah email terdaftar.
  Future<void> _showSentDialog(String email) async {
    final goToReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Cek emailmu',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: OceanColors.navy,
          ),
        ),
        content: Text(
          'Jika $email terdaftar, tautan untuk mengatur ulang kata sandi '
          'sudah dikirim. Periksa juga folder spam.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tutup'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Atur ulang sekarang'),
          ),
        ],
      ),
    );
    if (goToReset != true || !mounted) return;
    // Ganti halaman ini agar "Kembali ke Login" di halaman berikutnya
    // langsung menuju Login.
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      formKey: _formKey,
      headerStyle: AuthHeaderStyle.centered,
      title: 'Lupa Kata Sandi?',
      subtitle: 'Masukkan email terdaftar,\nkami akan mengirimkan\n'
          'tautan untuk mengatur ulang\nkata sandi.',
      mascot: const EnvelopeMascot(width: 112),
      children: [
        AuthTextField(
          key: const Key('forgotEmailField'),
          controller: _email,
          hint: 'Email',
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
          onSubmitted: (_) => _submit(),
          validator: FormValidators.requiredEmail,
        ),
        const SizedBox(height: 22),
        AuthButton(
          label: 'Kirim Tautan',
          icon: Icons.send_rounded,
          loading: _isSubmitting,
          onPressed: _submit,
        ),
        const SizedBox(height: 12),
        Center(
          child: AuthLink(
            label: 'Kembali ke Login',
            onTap: () => Navigator.maybePop(context),
          ),
        ),
      ],
    );
  }
}
