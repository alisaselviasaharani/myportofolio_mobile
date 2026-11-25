import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/utils/auth_errors.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/auth_form_parts.dart';
import 'package:myportofolio_mobile/widgets/auth_scaffold.dart';
import 'package:myportofolio_mobile/widgets/illustrations.dart';
import 'package:provider/provider.dart';

/// Halaman Daftar Akun: nama lengkap, email, username, kata sandi, dan
/// konfirmasinya. Jika berhasil, kembali ke halaman sebelumnya (Login) dengan
/// pesan sukses.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _username.dispose();
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
      await api.register(
        fullName: _name.text.trim(),
        email: _email.text.trim(),
        username: _username.text.trim(),
        password: _password.text,
      );
      if (!mounted) return;
      showInfoSnackBar(context, 'Akun berhasil dibuat. Silakan masuk.');
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      showInfoSnackBar(
        context,
        authErrorMessage(
          e,
          failed: 'Pendaftaran gagal',
          rejected: 'Pendaftaran ditolak. Email atau username mungkin sudah '
              'dipakai.',
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
      title: 'Daftar Akun',
      subtitle: 'Buat akun baru untuk\nmulai membangun portfolio.',
      mascot: const SeahorseMascot(height: 110),
      children: [
        AuthTextField(
          key: const Key('registerNameField'),
          controller: _name,
          hint: 'Nama Lengkap',
          icon: Icons.person_outline,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.name],
          validator: (value) => FormValidators.requiredText(
            value,
            fieldName: 'Nama lengkap',
            maxLength: 150,
          ),
        ),
        const SizedBox(height: 12),
        AuthTextField(
          key: const Key('registerEmailField'),
          controller: _email,
          hint: 'Email',
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          validator: FormValidators.requiredEmail,
        ),
        const SizedBox(height: 12),
        AuthTextField(
          key: const Key('registerUsernameField'),
          controller: _username,
          hint: 'Username',
          icon: Icons.alternate_email,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newUsername],
          validator: FormValidators.username,
        ),
        const SizedBox(height: 12),
        AuthTextField(
          key: const Key('registerPasswordField'),
          controller: _password,
          hint: 'Kata Sandi',
          icon: Icons.lock_outline,
          isPassword: true,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          validator: FormValidators.password,
        ),
        const SizedBox(height: 12),
        AuthTextField(
          key: const Key('registerConfirmField'),
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
          label: 'Daftar',
          loading: _isSubmitting,
          onPressed: _submit,
        ),
        const SizedBox(height: 16),
        AuthPrompt(
          question: 'Sudah punya akun?',
          action: 'Masuk',
          onTap: () => Navigator.maybePop(context),
        ),
      ],
    );
  }
}
