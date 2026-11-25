import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/utils/auth_errors.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/auth_form_parts.dart';
import 'package:myportofolio_mobile/widgets/auth_mascots.dart';
import 'package:myportofolio_mobile/widgets/auth_scaffold.dart';
import 'package:provider/provider.dart';

/// Halaman Atur Ulang Kata Sandi: kata sandi baru dan konfirmasinya.
///
/// [uid] dan [token] berasal dari tautan di email atur ulang. Jika halaman
/// dibuka dari deep link, isi keduanya dari parameter tautan tersebut.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, this.uid = '', this.token = ''});

  final String uid;
  final String token;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;

    final api = context.read<ApiClient>();
    setState(() {
      _isSubmitting = true;
    });

    try {
      await api.confirmPasswordReset(
        uid: widget.uid,
        token: widget.token,
        newPassword: _password.text,
      );
      if (!mounted) return;
      showInfoSnackBar(context, 'Kata sandi diperbarui. Silakan masuk.');
      Navigator.maybePop(context);
    } catch (e) {
      if (!mounted) return;
      showInfoSnackBar(
        context,
        authErrorMessage(
          e,
          failed: 'Gagal menyimpan kata sandi',
          rejected: 'Tautan tidak valid atau sudah kedaluwarsa. Minta tautan '
              'baru.',
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      formKey: _formKey,
      headerStyle: AuthHeaderStyle.centered,
      title: 'Atur Ulang\nKata Sandi',
      subtitle: 'Buat kata sandi baru\nuntuk akunmu.',
      mascot: const PadlockMascot(width: 84),
      children: [
        AuthTextField(
          key: const Key('resetPasswordField'),
          controller: _password,
          hint: 'Kata Sandi Baru',
          icon: Icons.lock_outline,
          isPassword: true,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          validator: FormValidators.password,
        ),
        const SizedBox(height: 12),
        AuthTextField(
          key: const Key('resetConfirmField'),
          controller: _confirm,
          hint: 'Konfirmasi Kata Sandi',
          icon: Icons.lock_outline,
          isPassword: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
          validator: (value) =>
              FormValidators.confirmPassword(value, _password.text),
        ),
        const SizedBox(height: 22),
        AuthButton(
          label: 'Simpan Kata Sandi',
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
